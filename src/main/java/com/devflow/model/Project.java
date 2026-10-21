package com.devflow.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Entity
@Table(name = "projects", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"organization_id", "project_key"})
})
public class Project {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "organization_id", nullable = false)
    private Organization organization;

    @NotBlank
    @Column(name = "project_key", nullable = false, length = 20)
    private String projectKey;

    @NotBlank
    @Column(nullable = false, length = 200)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(length = 50)
    private Enums.ProjectStatus status = Enums.ProjectStatus.ACTIVE;

    @Enumerated(EnumType.STRING)
    @Column(length = 30)
    private Enums.Priority priority = Enums.Priority.MEDIUM;

    @Enumerated(EnumType.STRING)
    @Column(name = "health_status", length = 30)
    private Enums.HealthStatus healthStatus = Enums.HealthStatus.ON_TRACK;

    @Column(name = "start_date")
    private LocalDate startDate;

    @Column(name = "target_delivery_date")
    private LocalDate targetDeliveryDate;

    @Column(name = "created_at", updatable = false)
    private OffsetDateTime createdAt = OffsetDateTime.now();

    public Project() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Organization getOrganization() { return organization; }
    public void setOrganization(Organization organization) { this.organization = organization; }
    public String getProjectKey() { return projectKey; }
    public void setProjectKey(String projectKey) { this.projectKey = projectKey; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Enums.ProjectStatus getStatus() { return status; }
    public void setStatus(Enums.ProjectStatus status) { this.status = status; }
    public Enums.Priority getPriority() { return priority; }
    public void setPriority(Enums.Priority priority) { this.priority = priority; }
    public Enums.HealthStatus getHealthStatus() { return healthStatus; }
    public void setHealthStatus(Enums.HealthStatus healthStatus) { this.healthStatus = healthStatus; }
    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }
    public LocalDate getTargetDeliveryDate() { return targetDeliveryDate; }
    public void setTargetDeliveryDate(LocalDate targetDeliveryDate) { this.targetDeliveryDate = targetDeliveryDate; }
    public OffsetDateTime getCreatedAt() { return createdAt; }
}
