-- DevFlow Initial Schema Migration V1
-- Enterprise Software Delivery and Client Approval Management Platform

CREATE TABLE IF NOT EXISTS organizations (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    plan_tier VARCHAR(50) DEFAULT 'ENTERPRISE',
    logo_url VARCHAR(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('ADMIN', 'PROJECT_MANAGER', 'DEVELOPER', 'QA_TESTER', 'CLIENT')),
    organization_id BIGINT REFERENCES organizations(id) ON DELETE SET NULL,
    avatar_url VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS organization_members (
    id BIGSERIAL PRIMARY KEY,
    organization_id BIGINT NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    member_role VARCHAR(50) NOT NULL,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_org_user UNIQUE (organization_id, user_id)
);

CREATE TABLE IF NOT EXISTS projects (
    id BIGSERIAL PRIMARY KEY,
    organization_id BIGINT NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    project_key VARCHAR(20) NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'ACTIVE' CHECK (status IN ('PLANNING', 'ACTIVE', 'PAUSED', 'COMPLETED', 'ARCHIVED')),
    priority VARCHAR(30) DEFAULT 'MEDIUM' CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    health_status VARCHAR(30) DEFAULT 'ON_TRACK' CHECK (health_status IN ('ON_TRACK', 'NEEDS_ATTENTION', 'AT_RISK')),
    start_date DATE,
    target_delivery_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_org_project_key UNIQUE (organization_id, project_key)
);

CREATE TABLE IF NOT EXISTS project_members (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    assigned_role VARCHAR(50) NOT NULL,
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_proj_user UNIQUE (project_id, user_id)
);

CREATE TABLE IF NOT EXISTS milestones (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    target_date DATE NOT NULL,
    completion_percentage INT DEFAULT 0,
    is_achieved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS requirements (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    req_code VARCHAR(30) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    acceptance_criteria TEXT NOT NULL,
    priority VARCHAR(30) DEFAULT 'HIGH' CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    status VARCHAR(50) DEFAULT 'DRAFT' CHECK (status IN ('DRAFT', 'UNDER_REVIEW', 'APPROVED', 'IMPLEMENTED', 'VERIFIED')),
    coverage_ratio NUMERIC(5,2) DEFAULT 0.0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_proj_req_code UNIQUE (project_id, req_code)
);

CREATE TABLE IF NOT EXISTS requirement_history (
    id BIGSERIAL PRIMARY KEY,
    requirement_id BIGINT NOT NULL REFERENCES requirements(id) ON DELETE CASCADE,
    version INT NOT NULL,
    changed_by_user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    change_summary TEXT NOT NULL,
    snapshot_data TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tasks (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    requirement_id BIGINT REFERENCES requirements(id) ON DELETE SET NULL,
    milestone_id BIGINT REFERENCES milestones(id) ON DELETE SET NULL,
    task_key VARCHAR(30) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'BACKLOG' CHECK (status IN ('BACKLOG', 'TODO', 'IN_PROGRESS', 'IN_REVIEW', 'DONE')),
    priority VARCHAR(30) DEFAULT 'MEDIUM' CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    assignee_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    reporter_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    estimate_hours NUMERIC(6,2) DEFAULT 0.0,
    actual_hours NUMERIC(6,2) DEFAULT 0.0,
    due_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_proj_task_key UNIQUE (project_id, task_key)
);

CREATE TABLE IF NOT EXISTS task_dependencies (
    id BIGSERIAL PRIMARY KEY,
    parent_task_id BIGINT NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
    dependent_task_id BIGINT NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
    dependency_type VARCHAR(50) DEFAULT 'BLOCKS',
    CONSTRAINT uq_task_dep UNIQUE (parent_task_id, dependent_task_id)
);

CREATE TABLE IF NOT EXISTS task_comments (
    id BIGSERIAL PRIMARY KEY,
    task_id BIGINT NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    comment_text TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS work_logs (
    id BIGSERIAL PRIMARY KEY,
    task_id BIGINT NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    hours_spent NUMERIC(6,2) NOT NULL,
    log_date DATE NOT NULL,
    activity_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS deliverables (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    task_id BIGINT REFERENCES tasks(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    deliverable_type VARCHAR(50) NOT NULL CHECK (deliverable_type IN ('SOFTWARE_BUILD', 'DESIGN_SPEC', 'ARCHITECTURE_DOC', 'STAGING_PREVIEW', 'RELEASE_PACKAGE')),
    current_version_number INT DEFAULT 1,
    approval_status VARCHAR(50) DEFAULT 'PENDING_REVIEW' CHECK (approval_status IN ('DRAFT', 'PENDING_REVIEW', 'REVISION_REQUESTED', 'APPROVED', 'REJECTED')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS deliverable_versions (
    id BIGSERIAL PRIMARY KEY,
    deliverable_id BIGINT NOT NULL REFERENCES deliverables(id) ON DELETE CASCADE,
    version_tag VARCHAR(50) NOT NULL,
    file_path VARCHAR(500),
    file_size_bytes BIGINT DEFAULT 0,
    file_checksum VARCHAR(128),
    release_notes TEXT,
    uploaded_by_user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_deliv_version UNIQUE (deliverable_id, version_tag)
);

CREATE TABLE IF NOT EXISTS approvals (
    id BIGSERIAL PRIMARY KEY,
    deliverable_version_id BIGINT NOT NULL REFERENCES deliverable_versions(id) ON DELETE CASCADE,
    client_user_id BIGINT NOT NULL REFERENCES users(id),
    decision VARCHAR(50) NOT NULL CHECK (decision IN ('APPROVED', 'REVISION_REQUESTED', 'CONDITIONAL_ACCEPTANCE')),
    feedback_notes TEXT NOT NULL,
    decision_timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS approval_comments (
    id BIGSERIAL PRIMARY KEY,
    approval_id BIGINT NOT NULL REFERENCES approvals(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS test_plans (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    plan_type VARCHAR(50) DEFAULT 'SYSTEM_ACCEPTANCE',
    author_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS test_cases (
    id BIGSERIAL PRIMARY KEY,
    test_plan_id BIGINT NOT NULL REFERENCES test_plans(id) ON DELETE CASCADE,
    requirement_id BIGINT REFERENCES requirements(id) ON DELETE SET NULL,
    case_code VARCHAR(30) NOT NULL,
    title VARCHAR(255) NOT NULL,
    preconditions TEXT,
    execution_steps TEXT NOT NULL,
    expected_result TEXT NOT NULL,
    is_automated BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_plan_case_code UNIQUE (test_plan_id, case_code)
);

CREATE TABLE IF NOT EXISTS test_runs (
    id BIGSERIAL PRIMARY KEY,
    test_plan_id BIGINT NOT NULL REFERENCES test_plans(id) ON DELETE CASCADE,
    run_name VARCHAR(200) NOT NULL,
    executed_by_user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE,
    summary_status VARCHAR(50) DEFAULT 'IN_PROGRESS'
);

CREATE TABLE IF NOT EXISTS test_results (
    id BIGSERIAL PRIMARY KEY,
    test_run_id BIGINT NOT NULL REFERENCES test_runs(id) ON DELETE CASCADE,
    test_case_id BIGINT NOT NULL REFERENCES test_cases(id) ON DELETE CASCADE,
    status VARCHAR(50) NOT NULL CHECK (status IN ('PASSED', 'FAILED', 'BLOCKED', 'SKIPPED')),
    actual_output TEXT,
    execution_duration_ms BIGINT DEFAULT 0,
    recorded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS defects (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    test_result_id BIGINT REFERENCES test_results(id) ON DELETE SET NULL,
    defect_key VARCHAR(30) NOT NULL,
    title VARCHAR(255) NOT NULL,
    severity VARCHAR(30) NOT NULL CHECK (severity IN ('CRITICAL', 'MAJOR', 'MINOR', 'COSMETIC')),
    priority VARCHAR(30) NOT NULL CHECK (priority IN ('P1', 'P2', 'P3', 'P4')),
    status VARCHAR(50) DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'INVESTIGATING', 'FIXED', 'VERIFIED', 'CLOSED')),
    reproduction_steps TEXT NOT NULL,
    resolved_by_user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_proj_defect_key UNIQUE (project_id, defect_key)
);

CREATE TABLE IF NOT EXISTS releases (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    version_name VARCHAR(100) NOT NULL,
    release_status VARCHAR(50) DEFAULT 'PLANNING' CHECK (release_status IN ('PLANNING', 'STAGING', 'READY_FOR_DEPLOY', 'DEPLOYED', 'CANCELLED')),
    is_readiness_cleared BOOLEAN DEFAULT FALSE,
    target_release_date DATE NOT NULL,
    actual_release_date DATE,
    release_notes TEXT,
    authorized_by_user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS release_checklists (
    id BIGSERIAL PRIMARY KEY,
    release_id BIGINT NOT NULL REFERENCES releases(id) ON DELETE CASCADE,
    check_category VARCHAR(50) NOT NULL CHECK (check_category IN ('QA_TESTS', 'CLIENT_APPROVAL', 'SECURITY_AUDIT', 'COMPLIANCE', 'DEPLOYMENT_OPS')),
    description VARCHAR(300) NOT NULL,
    is_mandatory BOOLEAN DEFAULT TRUE,
    is_satisfied BOOLEAN DEFAULT FALSE,
    verified_by_user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    verification_notes TEXT
);

CREATE TABLE IF NOT EXISTS notifications (
    id BIGSERIAL PRIMARY KEY,
    recipient_user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    event_type VARCHAR(100) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message_body TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    target_url VARCHAR(300),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS notification_preferences (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    notify_on_assignment BOOLEAN DEFAULT TRUE,
    notify_on_approval_decision BOOLEAN DEFAULT TRUE,
    notify_on_defect_logged BOOLEAN DEFAULT TRUE,
    notify_on_release_cleared BOOLEAN DEFAULT TRUE,
    CONSTRAINT uq_user_pref UNIQUE (user_id)
);

CREATE TABLE IF NOT EXISTS audit_logs (
    id BIGSERIAL PRIMARY KEY,
    organization_id BIGINT REFERENCES organizations(id) ON DELETE SET NULL,
    user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id VARCHAR(100) NOT NULL,
    previous_state TEXT,
    new_state TEXT,
    ip_address VARCHAR(64),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Essential Performance & Query Indexes
CREATE INDEX IF NOT EXISTS idx_users_org ON users(organization_id);
CREATE INDEX IF NOT EXISTS idx_projects_org ON projects(organization_id);
CREATE INDEX IF NOT EXISTS idx_tasks_project ON tasks(project_id);
CREATE INDEX IF NOT EXISTS idx_tasks_assignee ON tasks(assignee_id);
CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);
CREATE INDEX IF NOT EXISTS idx_requirements_proj ON requirements(project_id);
CREATE INDEX IF NOT EXISTS idx_deliverables_proj ON deliverables(project_id);
CREATE INDEX IF NOT EXISTS idx_approvals_version ON approvals(deliverable_version_id);
CREATE INDEX IF NOT EXISTS idx_defects_proj ON defects(project_id);
CREATE INDEX IF NOT EXISTS idx_defects_status ON defects(status);
CREATE INDEX IF NOT EXISTS idx_releases_proj ON releases(project_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(recipient_user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_audit_org ON audit_logs(organization_id, created_at);
