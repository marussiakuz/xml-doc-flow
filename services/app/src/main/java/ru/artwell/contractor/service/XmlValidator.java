package ru.artwell.contractor.service;

import org.springframework.stereotype.Component;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.Validator;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;

@Component
public class XmlValidator {

    public List<ValidationError> validateXml(String xml, Schema schema) {
        Validator validator = schema.newValidator();
        List<ValidationError> errors = new ArrayList<>();

        validator.setErrorHandler(new org.xml.sax.helpers.DefaultHandler() {

            @Override
            public void error(SAXParseException e) {
                errors.add(fromSax(e));
            }

            @Override
            public void fatalError(SAXParseException e) {
                errors.add(fromSax(e));
            }

            @Override
            public void warning(org.xml.sax.SAXParseException e) {
                // ignore warnings for MVP
            }
        });

        try {
            validator.validate(new StreamSource(new StringReader(xml)));
        } catch (SAXException | IOException e) {
            if (errors.isEmpty()) {
                errors.add(new ValidationError("Ошибка валидации: " + e.getMessage(), null, null));
            }
        }

        return errors;
    }

    private static ValidationError fromSax(SAXParseException e) {
        Integer line = e.getLineNumber() > 0 ? e.getLineNumber() : null;
        Integer column = e.getColumnNumber() > 0 ? e.getColumnNumber() : null;
        return new ValidationError(e.getMessage(), line, column);
    }

    public record ValidationError(String message, Integer lineNumber, Integer columnNumber) {
    }
}

