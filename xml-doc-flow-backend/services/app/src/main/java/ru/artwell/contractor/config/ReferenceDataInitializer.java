package ru.artwell.contractor.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import ru.artwell.contractor.persistence.entity.*;
import ru.artwell.contractor.persistence.repository.*;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Создаёт тестовую организацию, пользователей с ролями, объект строительства, права на типы документов;
 * синхронизирует справочник {@code document_types} с загруженными XSD.
 */
@Component
@Order(0)
public class ReferenceDataInitializer implements ApplicationRunner {

    /** Читаемые названия для типов с латинскими кодами директорий. */
    private static final java.util.Map<String, String> LATIN_CODE_TYPE_NAMES =
            java.util.Map.ofEntries(
                    java.util.Map.entry("AOGROOKS",
                            "Акт освидетельствования геодезической разбивочной основы ОКС"),
                    java.util.Map.entry("AOOK",
                            "Акт освидетельствования ответственных конструкций"),
                    java.util.Map.entry("AOSR",
                            "Акт освидетельствования скрытых работ"),
                    java.util.Map.entry("AOUSITO",
                            "Акт освидетельствования участков сетей ИТО"),
                    java.util.Map.entry("AROOKSNM",
                            "Акт разбивки осей объекта капитального строительства на местности"),
                    java.util.Map.entry("gsn221",
                            "Акт выездной внеплановой проверки"),
                    java.util.Map.entry("gsn222",
                            "Акт документарной внеплановой проверки"),
                    java.util.Map.entry("gsn31",
                            "Извещение об устранении нарушений"),
                    java.util.Map.entry("gsnProtocolInspection",
                            "Протокол осмотра"),
                    java.util.Map.entry("gsnDecisionPrescriptExecutionDateChange",
                            "Решение органа по ходатайству о продлении срока исполнения предписания"),
                    java.util.Map.entry("gsnActControlEventResult",
                            "Акт по результатам контрольного мероприятия без взаимодействия с контролируемым лицом")
            );

    private static String resolveTypeName(String code) {
        return LATIN_CODE_TYPE_NAMES.getOrDefault(code, code);
    }

    public static final String DEFAULT_OBJECT_CODE = "DEFAULT-OBJECT-1";

    private final OrganizationRepository organizationRepository;
    private final UserRepository userRepository;
    private final ConstructionObjectRepository constructionObjectRepository;
    private final DocumentTypeRepository documentTypeRepository;
    private final XsdDefinitionRepository xsdDefinitionRepository;
    private final RoleDocumentPermissionRepository roleDocumentPermissionRepository;
    private final UserObjectAccessRepository userObjectAccessRepository;
    private final PasswordEncoder passwordEncoder;

    private final String testUsername;
    private final String testPassword;
    private final String organizationInn;
    private final String demoPassword;

    public ReferenceDataInitializer(OrganizationRepository organizationRepository,
                                    UserRepository userRepository,
                                    ConstructionObjectRepository constructionObjectRepository,
                                    DocumentTypeRepository documentTypeRepository,
                                    XsdDefinitionRepository xsdDefinitionRepository,
                                    RoleDocumentPermissionRepository roleDocumentPermissionRepository,
                                    UserObjectAccessRepository userObjectAccessRepository,
                                    PasswordEncoder passwordEncoder,
                                    @Value("${app.seed.test-username}") String testUsername,
                                    @Value("${app.seed.test-password}") String testPassword,
                                    @Value("${app.seed.demo-password}") String demoPassword,
                                    @Value("${app.seed.organization-inn}") String organizationInn) {
        this.organizationRepository = organizationRepository;
        this.userRepository = userRepository;
        this.constructionObjectRepository = constructionObjectRepository;
        this.documentTypeRepository = documentTypeRepository;
        this.xsdDefinitionRepository = xsdDefinitionRepository;
        this.roleDocumentPermissionRepository = roleDocumentPermissionRepository;
        this.userObjectAccessRepository = userObjectAccessRepository;
        this.passwordEncoder = passwordEncoder;
        this.testUsername = testUsername;
        this.testPassword = testPassword;
        this.demoPassword = demoPassword;
        this.organizationInn = organizationInn;
    }

    @Override
    @Transactional
    public void run(ApplicationArguments args) {
        OrganizationEntity organization = ensureOrganization();
        UserEntity admin = ensureTestUser(organization);
        ConstructionObjectEntity defaultObject = ensureDefaultConstructionObject(admin);
        ensureContractorUser(organization);
        UserEntity customer = ensureCustomerUser(organization);
        ensureCustomerAccessToObject(customer, defaultObject);
        syncDocumentTypesFromXsd();
        ensureUnknownDocumentType();
        initRoleDocumentPermissions();
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
                        null,
                        true
                ))
        );
    }

    private UserEntity ensureTestUser(OrganizationEntity organization) {
        return userRepository.findByUsername(testUsername).orElseGet(() ->
                userRepository.save(new UserEntity(
                        testUsername,
                        passwordEncoder.encode(testPassword),
                        "Тестовый пользователь (администратор)",
                        "ADMIN",
                        organization,
                        "test@example.local",
                        true
                ))
        );
    }

    private void ensureContractorUser(OrganizationEntity organization) {
        UserEntity u = userRepository.findByUsername("contractor").orElseGet(() ->
                userRepository.save(new UserEntity(
                        "contractor",
                        passwordEncoder.encode(demoPassword),
                        "Тестовый подрядчик",
                        "CONTRACTOR",
                        organization,
                        "contractor@example.local",
                        true
                ))
        );

        if (passwordEncoder.matches("password", u.getPasswordHash()) && !passwordEncoder.matches(demoPassword, u.getPasswordHash())) {
            u.setPasswordHash(passwordEncoder.encode(demoPassword));
            userRepository.save(u);
        }
    }

    private UserEntity ensureCustomerUser(OrganizationEntity organization) {
        UserEntity u = userRepository.findByUsername("customer").orElseGet(() ->
                userRepository.save(new UserEntity(
                        "customer",
                        passwordEncoder.encode(demoPassword),
                        "Тестовый заказчик",
                        "CUSTOMER",
                        organization,
                        "customer@example.local",
                        true
                ))
        );
        if (passwordEncoder.matches("password", u.getPasswordHash()) && !passwordEncoder.matches(demoPassword, u.getPasswordHash())) {
            u.setPasswordHash(passwordEncoder.encode(demoPassword));
            userRepository.save(u);
        }
        return u;
    }

    private void ensureCustomerAccessToObject(UserEntity customer, ConstructionObjectEntity object) {
        if (userObjectAccessRepository.existsByUser_IdAndConstructionObject_Id(customer.getId(), object.getId())) {
            return;
        }
        userObjectAccessRepository.save(new UserObjectAccessEntity(customer, object, "VIEW"));
    }

    private ConstructionObjectEntity ensureDefaultConstructionObject(UserEntity testUser) {
        return constructionObjectRepository.findByObjectCode(DEFAULT_OBJECT_CODE).orElseGet(() ->
                constructionObjectRepository.save(new ConstructionObjectEntity(
                        DEFAULT_OBJECT_CODE,
                        "Тестовый объект капитального строительства",
                        "Адрес не задан",
                        testUser,
                        testUser,
                        testUser,
                        testUser,
                        "active"
                ))
        );
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
            String humanName = resolveTypeName(code);
            documentTypeRepository.findByTypeCode(code).ifPresentOrElse(
                    existing -> {
                        if (existing.getTypeName() == null || existing.getTypeName().equals(existing.getTypeCode())) {
                            existing.setTypeName(humanName);
                            documentTypeRepository.save(existing);
                        }
                    },
                    () -> documentTypeRepository.save(new DocumentTypeEntity(
                            code,
                            humanName,
                            "Исполнительная документация",
                            e.getValue(),
                            true
                    ))
            );
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

    private void initRoleDocumentPermissions() {
        for (DocumentTypeEntity type : documentTypeRepository.findAll()) {
            if ("UNKNOWN".equals(type.getTypeCode())) {
                continue;
            }
            if (roleDocumentPermissionRepository.findByRoleAndDocumentType_TypeCode("CONTRACTOR", type.getTypeCode()).isEmpty()) {
                roleDocumentPermissionRepository.save(new RoleDocumentPermissionEntity(
                        "CONTRACTOR",
                        type,
                        true,
                        true
                ));
            }
            if (roleDocumentPermissionRepository.findByRoleAndDocumentType_TypeCode("CUSTOMER", type.getTypeCode()).isEmpty()) {
                roleDocumentPermissionRepository.save(new RoleDocumentPermissionEntity(
                        "CUSTOMER",
                        type,
                        false,
                        true
                ));
            }
        }
    }
}
