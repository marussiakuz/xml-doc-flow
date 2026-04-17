package ru.artwell.contractor.dto;

/**
 * Участник по данным XML.
 */
public record ParticipantDto(
        String role,
        String name,
        String inn,
        String ogrn,
        ConstructionObjectAddressDto address
) {
    public static final String ROLE_DEVELOPER = "DEVELOPER";
    public static final String ROLE_BUILDING_CONTRACTOR = "BUILDING_CONTRACTOR";
    public static final String ROLE_PROJECT_DOCUMENTATION_CONTRACTOR = "PROJECT_DOCUMENTATION_CONTRACTOR";
    public static final String ROLE_TECHNICAL_CUSTOMER = "TECHNICAL_CUSTOMER";
}
