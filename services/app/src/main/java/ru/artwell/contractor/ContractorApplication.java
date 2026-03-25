package ru.artwell.contractor;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import ru.artwell.contractor.config.PostgresDatabaseBootstrapListener;

@SpringBootApplication
public class ContractorApplication {
    public static void main(String[] args) {
        SpringApplication app = new SpringApplication(ContractorApplication.class);
        app.addListeners(new PostgresDatabaseBootstrapListener());
        app.run(args);
    }
}

