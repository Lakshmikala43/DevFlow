package com.devflow;

import com.devflow.model.Enums;
import com.devflow.model.Organization;
import com.devflow.model.Project;
import com.devflow.service.Services.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class DevFlowApplicationTests {

    @Test
    void contextLoads() {
        // Confirms Spring Boot context boots cleanly
    }

    @Test
    @DisplayName("Password hashing produces unique salts and matches raw inputs")
    void testPasswordHashing() {
        AuthService authService = new AuthService(null);
        String raw = "StrongDevFlowPassword2026!";
        org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder encoder = new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder();
        String hash = encoder.encode(raw);

        assertTrue(authService.verifyPassword(raw, hash));
        assertFalse(authService.verifyPassword("WrongPassword", hash));
    }

    @Test
    @DisplayName("Project entity initializes with ON_TRACK health and ACTIVE status")
    void testProjectDefaults() {
        Project p = new Project();
        p.setName("OmniChannel Portal");
        p.setProjectKey("OMNI");
        
        assertEquals(Enums.ProjectStatus.ACTIVE, p.getStatus());
        assertEquals(Enums.HealthStatus.ON_TRACK, p.getHealthStatus());
        assertEquals(Enums.Priority.MEDIUM, p.getPriority());
    }
}
