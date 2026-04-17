package ru.artwell.contractor.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ParticipantInfo {
    private String role;
    private String roleName;
    private OrganizationInfo organization;
    private ConstructionObjectAddressDto address;

    public ParticipantInfo(String role, String roleName, OrganizationInfo organization,
                           ConstructionObjectAddressDto address) {
        this.role = role;
        this.roleName = roleName;
        this.organization = organization;
        this.address = address;
    }
}
