package ru.artwell.contractor.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ConstructionObjectInfo {
    private Long id;
    private String name;
    private ConstructionObjectAddressDto address;
    /** Бизнес-код или GUID объекта из XML (приоритет — {@code permanentObjectUuid}). */
    private String objectCode;

    public ConstructionObjectInfo(Long id, String name, ConstructionObjectAddressDto address, String objectCode) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.objectCode = objectCode;
    }
}
