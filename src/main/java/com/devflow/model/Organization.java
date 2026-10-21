package com.devflow.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import java.time.OffsetDateTime;

@Entity
@Table(name = "organizations")
public class Organization {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Column(nullable = false, length = 150)
    private String name;

    @NotBlank
    @Column(nullable = false, unique = true, length = 100)
    private String slug;

    @Column(name = "plan_tier", length = 50)
    private String planTier = "ENTERPRISE";

    @Column(name = "created_at", updatable = false)
    private OffsetDateTime createdAt = OffsetDateTime.now();

    public Organization() {}

    public Organization(String name, String slug) {
        this.name = name;
        this.slug = slug;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
    public String getPlanTier() { return planTier; }
    public void setPlanTier(String planTier) { this.planTier = planTier; }
    public OffsetDateTime getCreatedAt() { return createdAt; }
}
