package ru.artwell.contractor.service;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import ru.artwell.contractor.dto.ConstructionObjectAddressDto;
import ru.artwell.contractor.dto.ParticipantDto;
import ru.artwell.contractor.persistence.entity.OrganizationEntity;
import ru.artwell.contractor.persistence.repository.OrganizationRepository;

import java.util.Optional;

/**
 * Поиск организации по ИНН или создание новой записи из данных участника XML.
 */
@Service
public class OrganizationResolver {

    private final OrganizationRepository organizationRepository;

    public OrganizationResolver(OrganizationRepository organizationRepository) {
        this.organizationRepository = organizationRepository;
    }

    public OrganizationEntity findOrCreateOrganization(ParticipantDto p) {
        String inn = p.inn() != null ? p.inn().trim() : "";
        if (!inn.isEmpty()) {
            Optional<OrganizationEntity> opt = organizationRepository.findByInn(inn);
            if (opt.isPresent()) {
                OrganizationEntity o = opt.get();
                if (p.name() != null && !p.name().isBlank()) {
                    o.setOrgName(p.name());
                }
                if (p.ogrn() != null && !p.ogrn().isBlank()) {
                    o.setOgrn(p.ogrn().trim());
                }
                if (p.address() != null) {
                    applyOrganizationStructuredAddress(o, p.address());
                }
                return organizationRepository.save(o);
            }
        }
        OrganizationEntity created = new OrganizationEntity(
                blankToDefault(p.name(), "Без наименования"),
                null,
                "UNKNOWN",
                inn.isEmpty() ? null : inn,
                null,
                blankToNull(p.ogrn()),
                null,
                true
        );
        if (p.address() != null) {
            applyOrganizationStructuredAddress(created, p.address());
        }
        try {
            return organizationRepository.save(created);
        } catch (DataIntegrityViolationException e) {
            if (!inn.isEmpty()) {
                return organizationRepository.findByInn(inn)
                        .orElseThrow(() -> new IllegalStateException(
                                "Конфликт при создании организации с ИНН " + inn, e));
            }
            throw e;
        }
    }

    private static void applyOrganizationStructuredAddress(OrganizationEntity e, ConstructionObjectAddressDto a) {
        e.setCountry(blankToNull(a.country()));
        e.setRegion(blankToNull(a.region()));
        e.setDistrict(blankToNull(a.district()));
        e.setLocality(blankToNull(a.locality()));
        e.setStreet(blankToNull(a.street()));
        e.setHouse(blankToNull(a.house()));
        e.setPostalCode(blankToNull(a.postalCode()));
        e.setOktmo(blankToNull(a.oktmo()));
        if (a.fullAddress() != null && !a.fullAddress().isBlank()) {
            e.setLegalAddress(a.fullAddress().trim());
        } else if (a.oktmo() != null && !a.oktmo().isBlank()) {
            e.setLegalAddress(a.oktmo().trim());
        }
    }

    private static String blankToNull(String s) {
        if (s == null || s.isBlank()) {
            return null;
        }
        return s.trim();
    }

    private static String blankToDefault(String s, String def) {
        if (s == null || s.isBlank()) {
            return def;
        }
        return s.trim();
    }
}
