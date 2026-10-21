package com.devflow;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

/**
 * DevFlow — Enterprise Software Delivery and Client Approval Management Platform.
 * Tagline: "From First Task to Final Release."
 */
@SpringBootApplication
@EnableJpaAuditing
@EntityScan(basePackages = "com.devflow.model")
@EnableJpaRepositories(basePackages = "com.devflow.repository")
public class DevFlowApplication {

    public static void main(String[] args) {
        SpringApplication.run(DevFlowApplication.class, args);
        System.out.println("==========================================================");
        System.out.println(" DevFlow Platform Started Successfully");
        System.out.println(" Tagline: From First Task to Final Release.");
        System.out.println(" Web Portal: http://localhost:8080");
        System.out.println("==========================================================");
    }
}
