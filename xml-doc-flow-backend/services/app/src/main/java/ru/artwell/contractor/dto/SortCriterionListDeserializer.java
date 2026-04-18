package ru.artwell.contractor.dto;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonToken;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Принимает {@code sort} как JSON-массив строк или одну строку {@code "field,dir"}.
 */
public class SortCriterionListDeserializer extends JsonDeserializer<List<String>> {

    @Override
    public List<String> deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        JsonToken token = p.currentToken();
        if (token == JsonToken.VALUE_NULL) {
            return List.of();
        }
        if (token == JsonToken.VALUE_STRING) {
            String v = p.getValueAsString();
            if (v == null || v.isBlank()) {
                return List.of();
            }
            return List.of(v.trim());
        }
        if (token == JsonToken.START_ARRAY) {
            List<String> out = new ArrayList<>();
            while (p.nextToken() != JsonToken.END_ARRAY) {
                if (p.currentToken() == JsonToken.VALUE_STRING) {
                    String s = p.getValueAsString();
                    if (s != null && !s.isBlank()) {
                        out.add(s.trim());
                    }
                }
            }
            return out;
        }
        return List.of();
    }
}
