package com.devflow.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Entity
@Table(name = "tasks")
public class Task {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "project_id", nullable = false)
    private Project project;

    @NotBlank
    @Column(name = "task_key", nullable = false, length = 30)
    private String taskKey;

    @NotBlank
    @Column(nullable = false, length = 255)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private Enums.TaskStatus status = Enums.TaskStatus.BACKLOG;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private Enums.Priority priority = Enums.Priority.MEDIUM;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "assignee_id")
    private User assignee;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reporter_id")
    private User reporter;

    @Column(name = "estimate_hours", precision = 6, scale = 2)
    private BigDecimal estimateHours = BigDecimal.ZERO;

    @Column(name = "actual_hours", precision = 6, scale = 2)
    private BigDecimal actualHours = BigDecimal.ZERO;

    @Column(name = "due_date")
    private LocalDate dueDate;

    @Column(name = "created_at", updatable = false)
    private OffsetDateTime createdAt = OffsetDateTime.now();

    public Task() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Project getProject() { return project; }
    public void setProject(Project project) { this.project = project; }
    public String getTaskKey() { return taskKey; }
    public void setTaskKey(String taskKey) { this.taskKey = taskKey; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Enums.TaskStatus getStatus() { return status; }
    public void setStatus(Enums.TaskStatus status) { this.status = status; }
    public Enums.Priority getPriority() { return priority; }
    public void setPriority(Enums.Priority priority) { this.priority = priority; }
    public User getAssignee() { return assignee; }
    public void setAssignee(User assignee) { this.assignee = assignee; }
    public User getReporter() { return reporter; }
    public void setReporter(User reporter) { this.reporter = reporter; }
    public BigDecimal getEstimateHours() { return estimateHours; }
    public void setEstimateHours(BigDecimal estimateHours) { this.estimateHours = estimateHours; }
    public BigDecimal getActualHours() { return actualHours; }
    public void setActualHours(BigDecimal actualHours) { this.actualHours = actualHours; }
    public LocalDate getDueDate() { return dueDate; }
    public void setDueDate(LocalDate dueDate) { this.dueDate = dueDate; }
    public OffsetDateTime getCreatedAt() { return createdAt; }
}
