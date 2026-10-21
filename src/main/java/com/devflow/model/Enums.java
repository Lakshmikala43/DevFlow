package com.devflow.model;

public class Enums {

    public enum Role {
        ADMIN,
        PROJECT_MANAGER,
        DEVELOPER,
        QA_TESTER,
        CLIENT
    }

    public enum ProjectStatus {
        PLANNING,
        ACTIVE,
        PAUSED,
        COMPLETED,
        ARCHIVED
    }

    public enum Priority {
        LOW,
        MEDIUM,
        HIGH,
        CRITICAL
    }

    public enum HealthStatus {
        ON_TRACK,
        NEEDS_ATTENTION,
        AT_RISK
    }

    public enum RequirementStatus {
        DRAFT,
        UNDER_REVIEW,
        APPROVED,
        IMPLEMENTED,
        VERIFIED
    }

    public enum TaskStatus {
        BACKLOG,
        TODO,
        IN_PROGRESS,
        IN_REVIEW,
        DONE
    }

    public enum DeliverableType {
        SOFTWARE_BUILD,
        DESIGN_SPEC,
        ARCHITECTURE_DOC,
        STAGING_PREVIEW,
        RELEASE_PACKAGE
    }

    public enum ApprovalStatus {
        DRAFT,
        PENDING_REVIEW,
        REVISION_REQUESTED,
        APPROVED,
        REJECTED
    }

    public enum ApprovalDecision {
        APPROVED,
        REVISION_REQUESTED,
        CONDITIONAL_ACCEPTANCE
    }

    public enum DefectSeverity {
        CRITICAL,
        MAJOR,
        MINOR,
        COSMETIC
    }

    public enum DefectStatus {
        OPEN,
        INVESTIGATING,
        FIXED,
        VERIFIED,
        CLOSED
    }

    public enum ReleaseStatus {
        PLANNING,
        STAGING,
        READY_FOR_DEPLOY,
        DEPLOYED,
        CANCELLED
    }

    public enum ChecklistCategory {
        QA_TESTS,
        CLIENT_APPROVAL,
        SECURITY_AUDIT,
        COMPLIANCE,
        DEPLOYMENT_OPS
    }
}
