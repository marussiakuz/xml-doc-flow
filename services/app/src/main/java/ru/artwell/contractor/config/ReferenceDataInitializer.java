package ru.artwell.contractor.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import ru.artwell.contractor.persistence.entity.*;
import ru.artwell.contractor.persistence.repository.*;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Создаёт тестовую организацию, одного пользователя и объект строительства по умолчанию;
 * синхронизирует справочник {@code document_types} с загруженными XSD.
 */
@Component
@Order(0)
public class ReferenceDataInitializer implements ApplicationRunner {

    public static final String DEFAULT_OBJECT_CODE = "DEFAULT-OBJECT-1";

    private final OrganizationRepository organizationRepository;
    private final UserRepository userRepository;
    private final ConstructionObjectRepository constructionObjectRepository;
    private final DocumentTypeRepository documentTypeRepository;
    private final XsdDefinitionRepository xsdDefinitionRepository;

    private final String testUsername;
    private final String testPassword;
    private final String organizationInn;

    public ReferenceDataInitializer(OrganizationRepository organizationRepository,
                                    UserRepository userRepository,
                                    ConstructionObjectRepository constructionObjectRepository,
                                    DocumentTypeRepository documentTypeRepository,
                                    XsdDefinitionRepository xsdDefinitionRepository,
                                    @Value("${app.seed.test-username}") String testUsername,
                                    @Value("${app.seed.test-password}") String testPassword,
                                    @Value("${app.seed.organization-inn}") String organizationInn) {
        this.organizationRepository = organizationRepository;
        this.userRepository = userRepository;
        this.constructionObjectRepository = constructionObjectRepository;
        this.documentTypeRepository = documentTypeRepository;
        this.xsdDefinitionRepository = xsdDefinitionRepository;
        this.testUsername = testUsername;
        this.testPassword = testPassword;
        this.organizationInn = organizationInn;
    }

    @Override
    @Transactional
    public void run(ApplicationArguments args) {
        OrganizationEntity organization = ensureOrganization();
        UserEntity testUser = ensureTestUser(organization);
        ensureDefaultConstructionObject(testUser);
        syncDocumentTypesFromXsd();
        ensureUnknownDocumentType();
    }

    private OrganizationEntity ensureOrganization() {
        return organizationRepository.findAll().stream().findFirst().orElseGet(() ->
                organizationRepository.save(new OrganizationEntity(
                        "ООО «Артвелл» (тестовая организация)",
                        "Артвелл",
                        "CUSTOMER",
                        organizationInn,
                        null,
                        null,
                        true
                ))
        );
    }

    private UserEntity ensureTestUser(OrganizationEntity organization) {
        return userRepository.findByUsername(testUsername).orElseGet(() -> {
            String hash = new BCryptPasswordEncoder().encode(testPassword);
            return userRepository.save(new UserEntity(
                    testUsername,
                    hash,
                    "Тестовый пользователь",
                    "ADMIN",
                    organization,
                    "test@example.local",
                    true
            ));
        });
    }

    private void ensureDefaultConstructionObject(UserEntity testUser) {
        if (constructionObjectRepository.findByObjectCode(DEFAULT_OBJECT_CODE).isPresent()) {
            return;
        }
        constructionObjectRepository.save(new ConstructionObjectEntity(
                DEFAULT_OBJECT_CODE,
                "Тестовый объект капитального строительства",
                "Адрес не задан",
                testUser,
                testUser,
                testUser,
                testUser,
                "active"
        ));
    }

    private void syncDocumentTypesFromXsd() {
        Map<String, String> typeCodeToXsdPath = new LinkedHashMap<>();
        for (XsdDefinitionEntity x : xsdDefinitionRepository.findAll()) {
            if (x.getDocumentType() == null || x.getDocumentType().isBlank()) {
                continue;
            }
            typeCodeToXsdPath.putIfAbsent(x.getDocumentType(), x.getXsdResourcePath());
        }
        for (Map.Entry<String, String> e : typeCodeToXsdPath.entrySet()) {
            String code = e.getKey();
            if (documentTypeRepository.findByTypeCode(code).isEmpty()) {
                documentTypeRepository.save(new DocumentTypeEntity(
                        code,
                        code,
                        "Исполнительная документация",
                        e.getValue(),
                        true
                ));
            }
        }
    }

    private void ensureUnknownDocumentType() {
        if (documentTypeRepository.findByTypeCode("UNKNOWN").isEmpty()) {
            documentTypeRepository.save(new DocumentTypeEntity(
                    "UNKNOWN",
                    "Неизвестный тип документа",
                    "Служебный",
                    null,
                    true
            ));
        }
    }
}
