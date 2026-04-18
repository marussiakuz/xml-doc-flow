package ru.artwell.contractor.service;

import org.springframework.stereotype.Component;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;
import java.io.StringReader;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import ru.artwell.contractor.dto.ConstructionObjectAddressDto;
import ru.artwell.contractor.dto.ParticipantDto;
import ru.artwell.contractor.dto.WorkVolumeDto;

@Component
public class XmlMetadataExtractor {

    private static final String NS_XSLT = "http://www.w3.org/1999/XSL/Transform";
    private static final String NS_XML_SCHEMA = "http://www.w3.org/2001/XMLSchema";
    private static final String NS_SVG = "http://www.w3.org/2000/svg";

    public Document parseXml(String xml) {
        return parseXmlSecurely(xml);
    }

    public RootQName extractRootQName(Document document) {
        Element root = document.getDocumentElement();
        return new RootQName(root.getNamespaceURI(), root.getLocalName());
    }

    /**
     * Отсекает служебные форматы из validation-files (xsl, xsd, svg и т.п.).
     * Электронный документ Минстроя — это XML с корнем вида {@code cf:aogrooks} и т.д..
     */
    public void assertBusinessDocumentRoot(RootQName root) {
        String ns = root.namespaceUri() == null ? "" : root.namespaceUri();
        String local = root.localName() == null ? "" : root.localName();

        if (NS_XSLT.equals(ns) && ("stylesheet".equals(local) || "transform".equals(local))) {
            throw new IllegalArgumentException(
                    "Загружен файл XSLT-стилей (.xsl). Нужно загрузить XML, сформированный по XSD " +
                            "(например корневой элемент вроде cf:aogrooks для AOGROOKS)"
            );
        }
        if (NS_XML_SCHEMA.equals(ns) && "schema".equals(local)) {
            throw new IllegalArgumentException(
                    "Загрузите XML-экземпляр документа, проверяемый по схеме."
            );
        }
        if (NS_SVG.equals(ns) && "svg".equals(local)) {
            throw new IllegalArgumentException(
                    "Загрузите XML-документ акта/журнала."
            );
        }
    }

    public String extractDocumentNumber(Document document) {
        XPathFactory xPathFactory = XPathFactory.newInstance();
        XPath xPath = xPathFactory.newXPath();
        try {
            XPathExpression expr = xPath.compile(
                    "//*[local-name()='actInfo']//*[local-name()='documentInfo']/*[local-name()='number'][1]/text()"
            );
            String value = (String) expr.evaluate(document, XPathConstants.STRING);
            if (value != null && !value.isBlank()) return value.trim();

            XPathExpression fallback = xPath.compile(
                    "//*[local-name()='actInfo']//*[local-name()='documentDetails']//*[local-name()='number'][1]/text()"
            );
            value = (String) fallback.evaluate(document, XPathConstants.STRING);
            if (value != null && !value.isBlank()) return value.trim();

            XPathExpression fallback2 = xPath.compile(
                    "//*[local-name()='documentDetails']//*[local-name()='number'][1]/text()"
            );
            value = (String) fallback2.evaluate(document, XPathConstants.STRING);
            if (value != null && !value.isBlank()) return value.trim();

            XPathExpression fallback3 = xPath.compile(
                    "//*[local-name()='documentInfo']//*[local-name()='number'][1]/text()"
            );
            value = (String) fallback3.evaluate(document, XPathConstants.STRING);
            if (value != null && !value.isBlank()) return value.trim();

            XPathExpression fallback4 = xPath.compile(
                    "//*[local-name()='number'][1]/text()"
            );
            value = (String) fallback4.evaluate(document, XPathConstants.STRING);
            if (value != null && !value.isBlank()) return value.trim();

            throw new IllegalArgumentException("Не удалось извлечь номер документа из XML (элемент documentInfo/number).");
        } catch (Exception e) {
            if (e instanceof IllegalArgumentException) throw (IllegalArgumentException) e;
            throw new IllegalArgumentException("Ошибка извлечения номера документа из XML: " + e.getMessage(), e);
        }
    }

    /**
     * Пытается извлечь дату документа из типовых узлов Минстроя; при отсутствии — {@link Optional#empty()}.
     */
    public Optional<LocalDate> extractDocumentDate(Document document) {
        XPathFactory xPathFactory = XPathFactory.newInstance();
        XPath xPath = xPathFactory.newXPath();
        String[] xpaths = new String[]{
                "//*[local-name()='actInfo']//*[local-name()='documentInfo']/*[local-name()='date'][1]/text()",
                "//*[local-name()='actInfo']//*[local-name()='documentDetails']//*[local-name()='date'][1]/text()",
                "//*[local-name()='documentDetails']//*[local-name()='date'][1]/text()",
                "//*[local-name()='documentInfo']//*[local-name()='date'][1]/text()"
        };
        for (String xp : xpaths) {
            try {
                String raw = (String) xPath.compile(xp).evaluate(document, XPathConstants.STRING);
                if (raw != null && !raw.isBlank()) {
                    Optional<LocalDate> parsed = parseFlexibleDate(raw.trim());
                    if (parsed.isPresent()) return parsed;
                }
            } catch (Exception ignored) {
            }
        }
        return Optional.empty();
    }

    /**
     * Наименование объекта капитального строительства ({@code permanentObjectInfo/permanentObjectName}).
     */
    public Optional<String> extractPermanentObjectName(Document document) {
        return firstNonBlankXPath(document,
                "//*[local-name()='permanentObjectInfo']/*[local-name()='permanentObjectName'][1]/text()");
    }

    /**
     * GUID объекта: {@code permanentObjectUUID} (корень BaseDocument) или {@code permanentObjectId} в {@code permanentObjectInfo}.
     */
    public Optional<String> extractPermanentObjectUUID(Document document) {
        Optional<String> u = firstNonBlankXPath(document, "//*[local-name()='permanentObjectUUID'][1]/text()");
        if (u.isPresent()) return u;
        return firstNonBlankXPath(document,
                "//*[local-name()='permanentObjectInfo']/*[local-name()='permanentObjectId'][1]/text()");
    }

    /**
     * Структурированный адрес объекта
     */
    public Optional<ConstructionObjectAddressDto> extractPermanentObjectAddressStructured(Document document) {
        XPathFactory xPathFactory = XPathFactory.newInstance();
        XPath xPath = xPathFactory.newXPath();
        try {
            Node n = (Node) xPath.compile(
                    "//*[local-name()='permanentObjectInfo']//*[local-name()='permanentObjectAddress']"
                            + "//*[local-name()='detalizedAddress'][1]"
            ).evaluate(document, XPathConstants.NODE);
            if (n instanceof Element el) {
                ConstructionObjectAddressDto dto = parseDetalizedAddressElement(el);
                if (dto.fullAddress() != null && !dto.fullAddress().isBlank()) {
                    return Optional.of(dto);
                }
                if (!isBlank(dto.oktmo()) || hasAnyStructuredPart(dto)) {
                    return Optional.of(dto);
                }
                String legacy = formatDetalizedAddress(el);
                if (!legacy.isBlank()) {
                    return Optional.of(new ConstructionObjectAddressDto(
                            null, null, null, null, null, null, null, null, legacy));
                }
            }
        } catch (Exception ignored) {
        }
        Optional<String> stringOnly = firstNonBlankXPath(document,
                "//*[local-name()='permanentObjectInfo']//*[local-name()='permanentObjectAddress']"
                        + "//*[local-name()='stringAddress'][1]/text()");
        return stringOnly.map(s -> new ConstructionObjectAddressDto(
                null, null, null, null, null, null, null, null, s.trim()));
    }

    /**
     * Строка для legacy-колонки.
     */
    public Optional<String> extractPermanentObjectAddress(Document document) {
        return extractPermanentObjectAddressStructured(document).flatMap(dto -> {
            if (dto.fullAddress() != null && !dto.fullAddress().isBlank()) {
                return Optional.of(dto.fullAddress().trim());
            }
            if (!isBlank(dto.oktmo())) {
                return Optional.of(dto.oktmo().trim());
            }
            return Optional.empty();
        });
    }

    /**
     * Участники по типовым ролям в {@code actInfo} (застройщик, подрядчик, проектировщик, техзаказчик).
     */
    public List<ParticipantDto> extractParticipants(Document document) {
        XPathFactory xPathFactory = XPathFactory.newInstance();
        XPath xPath = xPathFactory.newXPath();
        List<ParticipantDto> out = new ArrayList<>();
        String[][] roles = {
                {"developer", ParticipantDto.ROLE_DEVELOPER},
                {"buildingContractor", ParticipantDto.ROLE_BUILDING_CONTRACTOR},
                {"projectDocumentationContractor", ParticipantDto.ROLE_PROJECT_DOCUMENTATION_CONTRACTOR},
                {"technicalCustomer", ParticipantDto.ROLE_TECHNICAL_CUSTOMER},
        };
        for (String[] pair : roles) {
            try {
                Node roleNode = (Node) xPath.compile(
                        "//*[local-name()='actInfo']/*[local-name()='" + pair[0] + "'][1]"
                ).evaluate(document, XPathConstants.NODE);
                if (!(roleNode instanceof Element roleEl)) continue;
                extractParticipantFromRoleElement(roleEl, pair[1]).ifPresent(out::add);
            } catch (Exception ignored) {
            }
        }
        return out;
    }

    /**
     * Извлекает объёмы работ из XML.
     * <p>AOOK: элементы {@code workStructuresListItem} → {@code structureElementName} + {@code structureAmountInfo}.
     * <p>AOSR: элементы {@code hiddenWorkInfo} → {@code workName} (без количества).
     */
    public List<WorkVolumeDto> extractWorkVolumes(Document document) {
        List<WorkVolumeDto> result = new ArrayList<>();
        NodeList aookItems = document.getElementsByTagNameNS("*", "workStructuresListItem");
        for (int i = 0; i < aookItems.getLength(); i++) {
            if (!(aookItems.item(i) instanceof Element item)) continue;
            String name = elementText(item, "structureElementName");
            if (name.isBlank()) continue;
            Element amountInfo = findFirstDescendantLocal(item, "structureAmountInfo");
            BigDecimal quantity = null;
            if (amountInfo != null) {
                String amountText = elementText(amountInfo, "amount");
                String unit = elementText(amountInfo, "unit");
                if (!amountText.isBlank()) {
                    try {
                        quantity = new BigDecimal(amountText.trim());
                    } catch (NumberFormatException ignored) {
                    }
                }
                if (!unit.isBlank()) {
                    name = name + " (" + unit.trim() + ")";
                }
            }
            result.add(new WorkVolumeDto(name, quantity));
        }
        NodeList aosrItems = document.getElementsByTagNameNS("*", "hiddenWorkInfo");
        for (int i = 0; i < aosrItems.getLength(); i++) {
            if (!(aosrItems.item(i) instanceof Element item)) continue;
            String workName = elementText(item, "workName");
            if (!workName.isBlank()) {
                result.add(new WorkVolumeDto(workName, null));
            }
        }
        // AOSR actual structure: worksList/worksListItem/workDescription/workName
        NodeList worksItems = document.getElementsByTagNameNS("*", "worksListItem");
        for (int i = 0; i < worksItems.getLength(); i++) {
            if (!(worksItems.item(i) instanceof Element item)) continue;
            Element workDesc = findFirstDescendantLocal(item, "workDescription");
            if (workDesc == null) continue;
            String workName = elementText(workDesc, "workName");
            if (!workName.isBlank()) {
                result.add(new WorkVolumeDto(workName, null));
            }
        }
        return result;
    }

    public RootQName extractRootQName(String xml) {
        return extractRootQName(parseXmlSecurely(xml));
    }

    public String extractDocumentNumber(String xml) {
        return extractDocumentNumber(parseXmlSecurely(xml));
    }

    public Optional<LocalDate> extractDocumentDate(String xml) {
        return extractDocumentDate(parseXmlSecurely(xml));
    }

    public Optional<String> extractPermanentObjectName(String xml) {
        return extractPermanentObjectName(parseXmlSecurely(xml));
    }

    public Optional<String> extractPermanentObjectUUID(String xml) {
        return extractPermanentObjectUUID(parseXmlSecurely(xml));
    }

    public Optional<ConstructionObjectAddressDto> extractPermanentObjectAddressStructured(String xml) {
        return extractPermanentObjectAddressStructured(parseXmlSecurely(xml));
    }

    public Optional<String> extractPermanentObjectAddress(String xml) {
        return extractPermanentObjectAddress(parseXmlSecurely(xml));
    }

    public List<ParticipantDto> extractParticipants(String xml) {
        return extractParticipants(parseXmlSecurely(xml));
    }

    private Optional<ParticipantDto> extractParticipantFromRoleElement(Element roleElement, String roleCode) {
        Element legal = findFirstDescendantLocal(roleElement, "legalEntity");
        if (legal != null) {
            String name = elementText(legal, "name");
            String inn = elementText(legal, "inn");
            String ogrn = elementText(legal, "ogrn");
            if (ogrn.isEmpty()) ogrn = elementText(legal, "ogrnip");
            Element addrRoot = findFirstDescendantLocal(legal, "address");
            ConstructionObjectAddressDto addrDto = extractPostalAddressFromAddressElement(addrRoot).orElse(null);
            if (isBlank(name) && isBlank(inn) && isBlank(ogrn)) return Optional.empty();
            return Optional.of(new ParticipantDto(roleCode, nullToEmpty(name), nullToEmpty(inn), nullToEmpty(ogrn), addrDto));
        }
        Element ie = findFirstDescendantLocal(roleElement, "individualEntrepreneur");
        if (ie != null) {
            String lastName = elementText(ie, "lastName");
            String firstName = elementText(ie, "firstName");
            String middleName = elementText(ie, "middleName");
            String name = Stream.of(lastName, firstName, middleName)
                    .filter(s -> !s.isBlank())
                    .collect(Collectors.joining(" "));
            String inn = findInnNearIndividual(roleElement, ie);
            String ogrn = elementText(ie, "ogrnip");
            if (ogrn.isEmpty()) ogrn = elementText(ie, "ogrn");
            if (name.isBlank() && inn.isBlank()) return Optional.empty();
            Element addrIe = findFirstDescendantLocal(ie, "address");
            ConstructionObjectAddressDto addrDto = extractPostalAddressFromAddressElement(addrIe).orElse(null);
            return Optional.of(new ParticipantDto(roleCode, name, inn, ogrn, addrDto));
        }
        return Optional.empty();
    }

    private Optional<ConstructionObjectAddressDto> extractPostalAddressFromAddressElement(Element addressContainer) {
        if (addressContainer == null) return Optional.empty();
        Element det = findFirstDescendantLocal(addressContainer, "detalizedAddress");
        if (det != null) {
            ConstructionObjectAddressDto dto = parseDetalizedAddressElement(det);
            if (dto.fullAddress() != null && !dto.fullAddress().isBlank()) return Optional.of(dto);
            if (!isBlank(dto.oktmo()) || hasAnyStructuredPart(dto)) return Optional.of(dto);
            String legacy = formatDetalizedAddress(det);
            if (!legacy.isBlank()) {
                return Optional.of(new ConstructionObjectAddressDto(
                        null, null, null, null, null, null, null, null, legacy));
            }
            return Optional.empty();
        }
        Element strEl = findFirstDescendantLocal(addressContainer, "stringAddress");
        if (strEl != null) {
            String t = strEl.getTextContent() != null ? strEl.getTextContent().trim() : "";
            if (!t.isBlank()) {
                return Optional.of(new ConstructionObjectAddressDto(
                        null, null, null, null, null, null, null, null, t));
            }
        }
        return Optional.empty();
    }

    private static String findInnNearIndividual(Element roleRoot, Element individualEntrepreneur) {
        String direct = elementText(individualEntrepreneur, "inn");
        if (!isBlank(direct)) return direct.trim();
        Element org = findFirstDescendantLocal(roleRoot, "organization");
        if (org != null) {
            Element le = findFirstDescendantLocal(org, "legalEntity");
            if (le != null) {
                String inn = elementText(le, "inn");
                if (!isBlank(inn)) return inn.trim();
            }
        }
        return "";
    }

    private static boolean hasAnyStructuredPart(ConstructionObjectAddressDto dto) {
        return !isBlank(dto.country())
                || !isBlank(dto.region())
                || !isBlank(dto.district())
                || !isBlank(dto.locality())
                || !isBlank(dto.street())
                || !isBlank(dto.house())
                || !isBlank(dto.postalCode());
    }

    private ConstructionObjectAddressDto parseDetalizedAddressElement(Element det) {
        String country = elementText(det, "country");
        String region = elementText(det, "entityOfFederation");
        String district = elementText(det, "districtOrRegionCode");
        String settlement = elementText(det, "settlement");
        Element localityEl = findFirstDescendantLocal(det, "locality");
        String locality = "";
        if (localityEl != null) {
            String lt = elementText(localityEl, "localityType");
            String ln = elementText(localityEl, "localityName");
            locality = Stream.of(lt, ln).filter(s -> !s.isBlank()).collect(Collectors.joining(" "));
        }
        if (locality.isBlank() && !settlement.isBlank()) locality = settlement;
        Element rn = findFirstDescendantLocal(det, "roadNetwork");
        String street = "";
        if (rn != null) {
            String a = elementText(rn, "roadNetworkElement");
            String b = elementText(rn, "roadNetworkObject");
            street = Stream.of(a, b).filter(s -> !s.isBlank()).collect(Collectors.joining(", "));
        }
        Element building = findFirstDescendantLocal(det, "building");
        String house = "";
        if (building != null) {
            String bt = elementText(building, "buildingType");
            String bn = elementText(building, "buildingNumber");
            house = Stream.of(bt, bn).filter(s -> !s.isBlank()).collect(Collectors.joining(" "));
        }
        String postalCode = elementText(det, "postalCode");
        String oktmo = elementText(det, "oktmo");
        String full = ConstructionObjectAddressDto.computeFullAddress(
                country, region, district, locality, street, house, postalCode);
        return new ConstructionObjectAddressDto(
                opt(country), opt(region), opt(district),
                locality.isBlank() ? null : locality.trim(),
                street.isBlank() ? null : street.trim(),
                house.isBlank() ? null : house.trim(),
                postalCode.isBlank() ? null : postalCode.trim(),
                oktmo.isBlank() ? null : oktmo.trim(),
                full.isBlank() ? null : full
        );
    }

    private static String opt(String s) {
        return (s == null || s.isBlank()) ? null : s.trim();
    }

    private static Element findFirstDescendantLocal(Element root, String localName) {
        NodeList all = root.getElementsByTagNameNS("*", localName);
        return all.getLength() == 0 ? null : (Element) all.item(0);
    }

    private static String elementText(Element parent, String childLocal) {
        NodeList nl = parent.getElementsByTagNameNS("*", childLocal);
        if (nl.getLength() == 0) return "";
        Node n = nl.item(0);
        return n.getTextContent() != null ? n.getTextContent().trim() : "";
    }

    private String formatDetalizedAddress(Element detalizedAddress) {
        StringBuilder sb = new StringBuilder();
        NodeList children = detalizedAddress.getChildNodes();
        for (int i = 0; i < children.getLength(); i++) {
            Node n = children.item(i);
            if (n.getNodeType() != Node.ELEMENT_NODE) continue;
            Element child = (Element) n;
            String label = child.getLocalName();
            if (label == null || label.isEmpty()) label = child.getTagName();
            String text = child.getTextContent() != null ? child.getTextContent().trim() : "";
            if (text.isEmpty()) continue;
            if (sb.length() > 0) sb.append(", ");
            sb.append(label).append(": ").append(text);
        }
        return sb.toString();
    }

    private Optional<String> firstNonBlankXPath(Document document, String expression) {
        XPathFactory xPathFactory = XPathFactory.newInstance();
        XPath xPath = xPathFactory.newXPath();
        try {
            String value = (String) xPath.compile(expression).evaluate(document, XPathConstants.STRING);
            if (value != null && !value.isBlank()) return Optional.of(value.trim());
        } catch (Exception ignored) {
        }
        return Optional.empty();
    }

    private static boolean isBlank(String s) {
        return s == null || s.isBlank();
    }

    private static String nullToEmpty(String s) {
        return s == null ? "" : s.trim();
    }

    private static Optional<LocalDate> parseFlexibleDate(String raw) {
        String s = raw;
        if (s.length() >= 10 && s.charAt(4) == '-' && s.charAt(7) == '-') {
            try {
                return Optional.of(LocalDate.parse(s.substring(0, 10)));
            } catch (DateTimeParseException ignored) {
            }
        }
        if (s.length() >= 10 && s.charAt(2) == '.' && s.charAt(5) == '.') {
            try {
                int d = Integer.parseInt(s.substring(0, 2));
                int m = Integer.parseInt(s.substring(3, 5));
                int y = Integer.parseInt(s.substring(6, 10));
                return Optional.of(LocalDate.of(y, m, d));
            } catch (Exception ignored) {
            }
        }
        return Optional.empty();
    }

    private static Document parseXmlSecurely(String xml) {
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setNamespaceAware(true);
            factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
            factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
            factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
            factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
            factory.setXIncludeAware(false);
            factory.setExpandEntityReferences(false);
            DocumentBuilder builder = factory.newDocumentBuilder();
            return builder.parse(new InputSource(new StringReader(xml)));
        } catch (Exception e) {
            throw new IllegalArgumentException("XML не удалось распарсить: " + e.getMessage(), e);
        }
    }

    public record RootQName(String namespaceUri, String localName) {

        public static Optional<RootQName> parseExpandedForm(String expanded) {
            if (expanded == null || expanded.isEmpty() || expanded.charAt(0) != '{') return Optional.empty();
            int close = expanded.indexOf('}');
            if (close < 1 || close >= expanded.length() - 1) return Optional.empty();
            String uri = expanded.substring(1, close);
            String local = expanded.substring(close + 1);
            if (local.isEmpty()) return Optional.empty();
            return Optional.of(new RootQName(uri.isEmpty() ? null : uri, local));
        }

        public static Optional<String> localNameFromExpandedForm(String expanded) {
            return parseExpandedForm(expanded).map(RootQName::localName);
        }
    }
}
