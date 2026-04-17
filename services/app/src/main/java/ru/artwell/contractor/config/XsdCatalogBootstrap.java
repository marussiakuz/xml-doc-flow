package ru.artwell.contractor.config;

import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import ru.artwell.contractor.service.XsdCatalogService;

/**
 * Загрузка каталога XSD в БД и в память после полного поднятия контекста.
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
