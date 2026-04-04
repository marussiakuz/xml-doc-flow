package ru.artwell.contractor.service;

import org.springframework.stereotype.Component;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;
import java.io.StringReader;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Optional;

@Component
public class XmlMetadataExtractor {

    private static final String NS_XSLT = "http://www.w3.org/1999/XSL/Transform";
    private static final String NS_XML_SCHEMA = "http://www.w3.org/2001/XMLSchema";
    private static final String NS_SVG = "http://www.w3.org/2000/svg";

    public RootQName extractRootQName(String xml) {
        Document document = parseXmlSecurely(xml);
        Element root = document.getDocumentElement();
        return new RootQName(root.getNamespaceURI(), root.getLocalName());
    }

    /**
     * Отсекает служебные форматы из validation-files (xsl, xsd, svg и т.п.).
     * Электронный документ Минстроя — это XML с корнем вида {@code cf:aogrooks} и т.д., а не {@code xsl:stylesheet}.
     */
    public void assertBusinessDocumentRoot(RootQName root) {
        String ns = root.namespaceUri() == null ? "" : root.namespaceUri();
        String local = root.localName() == null ? "" : root.localName();

        if (NS_XSLT.equals(ns) && ("stylesheet".equals(local) || "transform".equals(local))) {
            throw new IllegalArgumentException(
                    "Загружен файл XSLT-стилей (.xsl), а не XML-документ строительного контроля. "
                            + "Нужно загрузить XML, сформированный по XSD (например корневой элемент вроде cf:aogrooks для AOGROOKS), "
                            + "а не шаблон отображения AOGROOKS.xsl."
            );
        }
        if (NS_XML_SCHEMA.equals(ns) && "schema".equals(local)) {
            throw new IllegalArgumentException(
                    "Загружен файл XSD-схемы, а не XML-документ. Загрузите XML-экземпляр документа, проверяемый по схеме."
            );
        }
        if (NS_SVG.equals(ns) && "svg".equals(local)) {
            throw new IllegalArgumentException(
                    "Загружен SVG-файл, а не XML-документ. Загрузите XML-документ акта/журнала."
            );
        }
    }

    public String extractDocumentNumber(String xml) {
        Document document = parseXmlSecurely(xml);

        XPathFactory xPathFactory = XPathFactory.newInstance();
        XPath xPath = xPathFactory.newXPath();

        // Namespace-agnostic extraction.
        // For "idActs" schemas document number is usually: actInfo/documentInfo/number.
        // For "gsn" schemas it is usually: actInfo/documentDetails/.../number.
        try {
            XPathExpression expr = xPath.compile(
                    "//*[local-name()='actInfo']//*[local-name()='documentInfo']/*[local-name()='number'][1]/text()"
            );
            String value = (String) expr.evaluate(document, XPathConstants.STRING);
            if (value != null && !value.isBlank()) {
                return value.trim();
            }

            XPathExpression fallback = xPath.compile(
                    "//*[local-name()='actInfo']//*[local-name()='documentDetails']//*[local-name()='number'][1]/text()"
            );
            value = (String) fallback.evaluate(document, XPathConstants.STRING);
            if (value != null && !value.isBlank()) {
                return value.trim();
            }

            XPathExpression fallback2 = xPath.compile(
                    "//*[local-name()='documentDetails']//*[local-name()='number'][1]/text()"
            );
            value = (String) fallback2.evaluate(document, XPathConstants.STRING);
            if (value != null && !value.isBlank()) {
                return value.trim();
            }

            XPathExpression fallback3 = xPath.compile(
                    "//*[local-name()='documentInfo']//*[local-name()='number'][1]/text()"
            );
            value = (String) fallback3.evaluate(document, XPathConstants.STRING);
            if (value != null && !value.isBlank()) {
                return value.trim();
            }

            XPathExpression fallback4 = xPath.compile(
                    "//*[local-name()='number'][1]/text()"
            );
            value = (String) fallback4.evaluate(document, XPathConstants.STRING);
            if (value != null && !value.isBlank()) {
                return value.trim();
            }

            throw new IllegalArgumentException("Не удалось извлечь номер документа из XML (элемент documentInfo/number).");
        } catch (Exception e) {
            if (e instanceof IllegalArgumentException) {
                throw (IllegalArgumentException) e;
            }
            throw new IllegalArgumentException("Ошибка извлечения номера документа из XML: " + e.getMessage(), e);
        }
    }

    /**
     * Пытается извлечь дату документа из типовых узлов Минстроя; при отсутствии — {@link Optional#empty()}.
     */
    public Optional<LocalDate> extractDocumentDate(String xml) {
        Document document = parseXmlSecurely(xml);
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
                    if (parsed.isPresent()) {
                        return parsed;
                    }
                }
            } catch (Exception ignored) {
            }
        }
        return Optional.empty();
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

            // Prevent XXE / SSRF
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
    }
}

