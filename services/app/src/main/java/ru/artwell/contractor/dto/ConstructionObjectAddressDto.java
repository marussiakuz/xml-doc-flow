package ru.artwell.contractor.dto;

import ru.artwell.contractor.persistence.entity.ConstructionObjectEntity;
import ru.artwell.contractor.persistence.entity.OrganizationEntity;

import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Структурированный почтовый адрес по схеме CommonTypes ({@code detalizedAddress} / {@code stringAddress} в XML Минстроя).
 * Используется для объекта капитального строительства, организаций и участников.
 *
 * @param country      страна
 * @param region       субъект РФ ({@code entityOfFederation})
 * @param district     район / округ ({@code districtOrRegionCode})
 * @param locality     населённый пункт (опционально)
 * @param street       улица (опционально)
 * @param house        дом/строение (опционально)
 * @param postalCode   индекс (опционально)
 * @param oktmo        ОКТМО
 * @param fullAddress  собранная строка для отображения и legacy-колонки {@code address}/{@code legal_address}
 */
public record ConstructionObjectAddressDto(
        String country,
        String region,
        String district,
        String locality,
        String street,
        String house,
        String postalCode,
        String oktmo,
        String fullAddress
) {

    /**
     * Строка для UI: основные части через запятую (без ОКТМО — он передаётся отдельным полем).
     */
    public static String computeFullAddress(String country, String region, String district, String locality,
                                            String street, String house, String postalCode) {
        return Stream.of(country, region, district, locality, street, house, postalCode)
                .filter(s -> s != null && !s.isBlank())
                .map(String::trim)
                .collect(Collectors.joining(", "));
    }

    public static ConstructionObjectAddressDto fromEntity(ConstructionObjectEntity e) {
        String full = computeFullAddress(
                e.getCountry(),
                e.getRegion(),
                e.getDistrict(),
                e.getLocality(),
                e.getStreet(),
                e.getHouse(),
                e.getPostalCode()
        );
        if (full.isBlank() && e.getAddress() != null && !e.getAddress().isBlank()) {
            full = e.getAddress().trim();
        }
        return new ConstructionObjectAddressDto(
                e.getCountry(),
                e.getRegion(),
                e.getDistrict(),
                e.getLocality(),
                e.getStreet(),
                e.getHouse(),
                e.getPostalCode(),
                e.getOktmo(),
                full.isBlank() ? null : full
        );
    }

    public static ConstructionObjectAddressDto fromOrganizationEntity(OrganizationEntity e) {
        String full = computeFullAddress(
                e.getCountry(),
                e.getRegion(),
                e.getDistrict(),
                e.getLocality(),
                e.getStreet(),
                e.getHouse(),
                e.getPostalCode()
        );
        if (full.isBlank() && e.getLegalAddress() != null && !e.getLegalAddress().isBlank()) {
            full = e.getLegalAddress().trim();
        }
        return new ConstructionObjectAddressDto(
                e.getCountry(),
                e.getRegion(),
                e.getDistrict(),
                e.getLocality(),
                e.getStreet(),
                e.getHouse(),
                e.getPostalCode(),
                e.getOktmo(),
                full.isBlank() ? null : full
        );
    }
}
