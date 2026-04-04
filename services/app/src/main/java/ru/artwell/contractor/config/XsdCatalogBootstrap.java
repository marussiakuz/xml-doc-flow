package ru.artwell.contractor.config;

import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import ru.artwell.contractor.service.XsdCatalogService;

/**
 * Загрузка каталога XSD в БД и в память после полного поднятия контекста.
 * <p>
 * {@code @PostConstruct} + {@code @Transactional} на сервисе не гарантирует транзакцию (вызов идёт до
 * прокси), из‑за чего записи в {@code xsd_definitions} могли не фиксироваться до запросов API —
 * тогда {@link XsdCatalogService#detectDocumentType} не находил корни вроде {@code aook}.
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class XsdCatalogBootstrap implements ApplicationRunner {

    private final XsdCatalogService xsdCatalogService;

    public XsdCatalogBootstrap(XsdCatalogService xsdCatalogService) {
        this.xsdCatalogService = xsdCatalogService;
    }

    @Override
    public void run(ApplicationArguments args) throws Exception {
        xsdCatalogService.bootstrapCatalog();
    }
}
