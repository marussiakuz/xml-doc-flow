package ru.artwell.contractor.service;

import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import ru.artwell.contractor.dto.ParticipantDto;
import ru.artwell.contractor.persistence.entity.DocumentParticipantEntity;
import ru.artwell.contractor.persistence.entity.DocumentVersionEntity;
import ru.artwell.contractor.persistence.entity.OrganizationEntity;
import ru.artwell.contractor.persistence.repository.DocumentParticipantRepository;

import java.util.List;

/**
 * Сохранение участников документа из XML в {@code document_participants}.
 */
@Service
public class ParticipantPersister {

    private final XmlMetadataExtractor xmlMetadataExtractor;
    private final DocumentParticipantRepository documentParticipantRepository;
    private final OrganizationResolver organizationResolver;

    public ParticipantPersister(XmlMetadataExtractor xmlMetadataExtractor,
                                DocumentParticipantRepository documentParticipantRepository,
                                OrganizationResolver organizationResolver) {
        this.xmlMetadataExtractor = xmlMetadataExtractor;
        this.documentParticipantRepository = documentParticipantRepository;
        this.organizationResolver = organizationResolver;
    }

    public void persistParticipants(Document doc, DocumentVersionEntity version) {
        if (doc == null) {
            return;
        }
        List<ParticipantDto> participants = xmlMetadataExtractor.extractParticipants(doc);
        for (ParticipantDto p : participants) {
            if (isParticipantEmpty(p)) {
                continue;
            }
            OrganizationEntity org = organizationResolver.findOrCreateOrganization(p);
            String participantType = (p.inn() == null || p.inn().isBlank()) && p.name() != null && !p.name().isBlank()
                    ? "INDIVIDUAL_ENTREPRENEUR"
                    : "LEGAL_ENTITY";
            documentParticipantRepository.save(new DocumentParticipantEntity(
                    version,
                    org,
                    p.role(),
                    participantType,
                    p.name(),
                    innOrNull(p),
                    null
            ));
        }
    }

    private static boolean isParticipantEmpty(ParticipantDto p) {
        boolean noName = p.name() == null || p.name().isBlank();
        boolean noInn = p.inn() == null || p.inn().isBlank();
        return noName && noInn;
    }

    private static String innOrNull(ParticipantDto p) {
        if (p.inn() == null || p.inn().isBlank()) {
            return null;
        }
        return p.inn().trim();
    }
}
