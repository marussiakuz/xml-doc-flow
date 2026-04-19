package ru.artwell.contractor.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import java.io.StringReader;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class XmlValidatorTest {

    private static final String XSD = """
            <?xml version="1.0" encoding="UTF-8"?>
            <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
              <xs:element name="document">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element name="number" type="xs:string"/>
                    <xs:element name="date" type="xs:date"/>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
            </xs:schema>
            """;

    private static final String VALID_XML = """
            <?xml version="1.0" encoding="UTF-8"?>
            <document>
              <number>DOC-001</number>
              <date>2026-04-19</date>
            </document>
            """;

    private static final String INVALID_XML_MISSING_FIELD = """
            <?xml version="1.0" encoding="UTF-8"?>
            <document>
              <number>DOC-001</number>
            </document>
            """;

    private static final String MALFORMED_XML = "<<not valid xml>>";

    private XmlValidator xmlValidator;
    private Schema schema;

    @BeforeEach
    void setUp() throws Exception {
        xmlValidator = new XmlValidator();
        SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
        schema = factory.newSchema(new javax.xml.transform.stream.StreamSource(new StringReader(XSD)));
    }

    @Test
    void validXml_returnsNoErrors() {
        List<XmlValidator.ValidationError> errors = xmlValidator.validateXml(VALID_XML, schema);
        assertThat(errors).isEmpty();
    }

    @Test
    void xmlMissingRequiredField_returnsErrors() {
        List<XmlValidator.ValidationError> errors = xmlValidator.validateXml(INVALID_XML_MISSING_FIELD, schema);
        assertThat(errors).isNotEmpty();
    }

    @Test
    void malformedXml_returnsErrors() {
        List<XmlValidator.ValidationError> errors = xmlValidator.validateXml(MALFORMED_XML, schema);
        assertThat(errors).isNotEmpty();
    }

    @Test
    void validationError_containsLineNumber() {
        List<XmlValidator.ValidationError> errors = xmlValidator.validateXml(INVALID_XML_MISSING_FIELD, schema);
        assertThat(errors).isNotEmpty();
        assertThat(errors.get(0).message()).isNotBlank();
    }
}
