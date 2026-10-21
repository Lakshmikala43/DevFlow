package com.devflow.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Entity
@Table(name = "releases")
public class Release {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "project_id", nullable = false)
    private Project project;

    @NotBlank
    @Column(name = "version_name", nullable = false, length = 100)
    private String versionName;

    @Enumerated(EnumType.STRING)
    @Column(name = "release_status", nullable = false, length = 50)
    private Enums.ReleaseStatus releaseStatus = Enums.ReleaseStatus.PLANNING;

    @Column(name = "is_readiness_cleared", nullable = false)
    private Boolean isReadinessCleared = false;

    @Column(name = "target_release_date", nullable = false)
    private LocalDate targetReleaseDate;

    @Column(name = "actual_release_date")
    private LocalDate actualReleaseDate;

    @Column(name = "release_notes", columnDefinition = "TEXT")
    private String releaseNotes;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "authorized_by_user_id")
    private User authorizedBy;

    @Column(name = "created_at", updatable = false)
    private OffsetDateTime createdAt = OffsetDateTime.now();

    public Release() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Project getProject() { return project; }
    public void setProject(Project project) { this.project = project; }
    public String getVersionName() { return versionName; }
    public void setVersionName(String versionName) { this.versionName = versionName; }
    public Enums.ReleaseStatus getReleaseStatus() { return releaseStatus; }
    public void setReleaseStatus(Enums.ReleaseStatus releaseStatus) { this.releaseStatus = releaseStatus; }
    public Boolean getIsReadinessCleared() { return isReadinessCleared; }
    public void setIsReadinessCleared(Boolean isReadinessCleared) { this.isReadinessCleared = isReadinessCleared; }
    public LocalDate getTargetReleaseDate() { return targetReleaseDate; }
    public void setTargetReleaseDate(LocalDate targetReleaseDate) { this.targetReleaseDate = targetReleaseDate; }
    public LocalDate getActualReleaseDate() { return actualReleaseDate; }
    public void setActualReleaseDate(LocalDate actualReleaseDate) { this.actualReleaseDate = actualReleaseDate; }
    public String getReleaseNotes() { return releaseNotes; }
    public void setReleaseNotes(String releaseNotes) { this.releaseNotes = releaseNotes; }
    public User getAuthorizedBy() { return authorizedBy; }
    public void setAuthorizedBy(User authorizedBy) { this.authorizedBy = authorizedBy; }
    public OffsetDateTime getCreatedAt() { return createdAt; }
}
