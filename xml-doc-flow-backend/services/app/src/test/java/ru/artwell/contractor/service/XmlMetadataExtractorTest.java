package ru.artwell.contractor.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.w3c.dom.Document;

import java.time.LocalDate;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class XmlMetadataExtractorTest {

    private static final String AOOK_XML = """
            <?xml version="1.0" encoding="UTF-8"?>
            <cf:aook xmlns:cf="urn:cfrf:names:tc:UFES:cf:aook:2" xmlns:cft="urn:cfrf:names:tc:UFES:cf:types">
              <cf:actInfo>
                <cf:documentInfo>
                  <cft:number>AOOK-2026-001</cft:number>
                  <cft:date>2026-04-19</cft:date>
                </cf:documentInfo>
              </cf:actInfo>
            </cf:aook>
            """;

    private static final String XML_WITHOUT_NUMBER = """
            <?xml version="1.0" encoding="UTF-8"?>
            <cf:aook xmlns:cf="urn:cfrf:names:tc:UFES:cf:aook:2">
              <cf:actInfo/>
            </cf:aook>
            """;

    private static final String XSD_XML = """
            <?xml version="1.0" encoding="UTF-8"?>
            <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
              <xs:element name="root" type="xs:string"/>
            </xs:schema>
            """;

    private static final String XSLT_XML = """
            <?xml version="1.0" encoding="UTF-8"?>
            <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
            </xsl:stylesheet>
            """;

    private XmlMetadataExtractor extractor;

    @BeforeEach
    void setUp() {
        extractor = new XmlMetadataExtractor();
    }

    // --- parseXml ---

    @Test
    void parseValidXml_returnsDocument() {
        Document doc = extractor.parseXml(AOOK_XML);
        assertThat(doc).isNotNull();
        assertThat(doc.getDocumentElement().getLocalName()).isEqualTo("aook");
    }

    @Test
    void parseMalformedXml_throwsIllegalArgumentException() {
        assertThatThrownBy(() -> extractor.parseXml("<<broken>>"))
                .isInstanceOf(IllegalArgumentException.class);
    }

    // --- extractDocumentNumber ---

    @Test
    void extractDocumentNumber_returnsNumber() {
        Document doc = extractor.parseXml(AOOK_XML);
        String number = extractor.extractDocumentNumber(doc);
        assertThat(number).isEqualTo("AOOK-2026-001");
    }

    @Test
    void extractDocumentNumber_missingNumber_throwsException() {
        Document doc = extractor.parseXml(XML_WITHOUT_NUMBER);
        assertThatThrownBy(() -> extractor.extractDocumentNumber(doc))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("номер");
    }

    // --- extractDocumentDate ---

    @Test
    void extractDocumentDate_returnsDate() {
        Document doc = extractor.parseXml(AOOK_XML);
        Optional<LocalDate> date = extractor.extractDocumentDate(doc);
        assertThat(date).contains(LocalDate.of(2026, 4, 19));
    }

    @Test
    void extractDocumentDate_missingDate_returnsEmpty() {
        Document doc = extractor.parseXml(XML_WITHOUT_NUMBER);
        Optional<LocalDate> date = extractor.extractDocumentDate(doc);
        assertThat(date).isEmpty();
    }

    // --- assertBusinessDocumentRoot ---

    @Test
    void assertBusinessDocumentRoot_normalDocument_doesNotThrow() {
        Document doc = extractor.parseXml(AOOK_XML);
        XmlMetadataExtractor.RootQName root = extractor.extractRootQName(doc);
        // should not throw
        extractor.assertBusinessDocumentRoot(root);
    }

    @Test
    void assertBusinessDocumentRoot_xsdFile_throwsException() {
        Document doc = extractor.parseXml(XSD_XML);
        XmlMetadataExtractor.RootQName root = extractor.extractRootQName(doc);
        assertThatThrownBy(() -> extractor.assertBusinessDocumentRoot(root))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("XML-экземпляр");
    }

    @Test
    void assertBusinessDocumentRoot_xsltFile_throwsException() {
        Document doc = extractor.parseXml(XSLT_XML);
        XmlMetadataExtractor.RootQName root = extractor.extractRootQName(doc);
        assertThatThrownBy(() -> extractor.assertBusinessDocumentRoot(root))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("XSLT");
    }
}
