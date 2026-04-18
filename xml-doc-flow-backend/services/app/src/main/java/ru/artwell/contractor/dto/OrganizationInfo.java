package ru.artwell.contractor.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class OrganizationInfo {
    private Long id;
    private String name;
    private String inn;
    private String ogrn;
    private ConstructionObjectAddressDto address;

    public OrganizationInfo(Long id, String name, String inn, String ogrn, ConstructionObjectAddressDto address) {
        this.id = id;
        this.name = name;
        this.inn = inn;
        this.ogrn = ogrn;
        this.address = address;
    }
}
