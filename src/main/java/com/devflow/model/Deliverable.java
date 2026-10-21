package com.devflow.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import java.time.OffsetDateTime;

@Entity
@Table(name = "deliverables")
public class Deliverable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "project_id", nullable = false)
    private Project project;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "task_id")
    private Task task;

    @NotBlank
    @Column(nullable = false, length = 255)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(name = "deliverable_type", nullable = false, length = 50)
    private Enums.DeliverableType deliverableType;

    @Column(name = "current_version_number")
    private Integer currentVersionNumber = 1;

    @Enumerated(EnumType.STRING)
    @Column(name = "approval_status", nullable = false, length = 50)
    private Enums.ApprovalStatus approvalStatus = Enums.ApprovalStatus.PENDING_REVIEW;

    @Column(name = "created_at", updatable = false)
    private OffsetDateTime createdAt = OffsetDateTime.now();

    public Deliverable() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Project getProject() { return project; }
    public void setProject(Project project) { this.project = project; }
    public Task getTask() { return task; }
    public void setTask(Task task) { this.task = task; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Enums.DeliverableType getDeliverableType() { return deliverableType; }
    public void setDeliverableType(Enums.DeliverableType deliverableType) { this.deliverableType = deliverableType; }
    public Integer getCurrentVersionNumber() { return currentVersionNumber; }
    public void setCurrentVersionNumber(Integer currentVersionNumber) { this.currentVersionNumber = currentVersionNumber; }
    public Enums.ApprovalStatus getApprovalStatus() { return approvalStatus; }
    public void setApprovalStatus(Enums.ApprovalStatus approvalStatus) { this.approvalStatus = approvalStatus; }
    public OffsetDateTime getCreatedAt() { return createdAt; }
}
