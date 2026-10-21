package com.devflow.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import java.time.OffsetDateTime;

@Entity
@Table(name = "approvals")
public class Approval {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "deliverable_version_id", nullable = false)
    private Long deliverableVersionId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "client_user_id", nullable = false)
    private User clientUser;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private Enums.ApprovalDecision decision;

    @NotBlank
    @Column(name = "feedback_notes", nullable = false, columnDefinition = "TEXT")
    private String feedbackNotes;

    @Column(name = "decision_timestamp", nullable = false)
    private OffsetDateTime decisionTimestamp = OffsetDateTime.now();

    public Approval() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getDeliverableVersionId() { return deliverableVersionId; }
    public void setDeliverableVersionId(Long deliverableVersionId) { this.deliverableVersionId = deliverableVersionId; }
    public User getClientUser() { return clientUser; }
    public void setClientUser(User clientUser) { this.clientUser = clientUser; }
    public Enums.ApprovalDecision getDecision() { return decision; }
    public void setDecision(Enums.ApprovalDecision decision) { this.decision = decision; }
    public String getFeedbackNotes() { return feedbackNotes; }
    public void setFeedbackNotes(String feedbackNotes) { this.feedbackNotes = feedbackNotes; }
    public OffsetDateTime getDecisionTimestamp() { return decisionTimestamp; }
    public void setDecisionTimestamp(OffsetDateTime decisionTimestamp) { this.decisionTimestamp = decisionTimestamp; }
}
