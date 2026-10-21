-- DevFlow Realistic Seed Data Migration V2

INSERT INTO organizations (name, slug, plan_tier) VALUES
('Acme Digital Studio', 'acme-digital', 'ENTERPRISE'),
('Global FinTech Labs', 'global-fintech', 'ENTERPRISE')
ON CONFLICT (slug) DO NOTHING;

INSERT INTO users (email, password_hash, full_name, role, organization_id) VALUES
('admin@devflow.local', '$2a$12$K8yR2u/d2WqQ.pQ3hN3M2uXyZf01a.3gY7w8k9L0m1N2o3P4q5R6', 'Sarah Jenkins', 'ADMIN', 1),
('pm@devflow.local', '$2a$12$K8yR2u/d2WqQ.pQ3hN3M2uXyZf01a.3gY7w8k9L0m1N2o3P4q5R6', 'Marcus Vance', 'PROJECT_MANAGER', 1),
('dev@devflow.local', '$2a$12$K8yR2u/d2WqQ.pQ3hN3M2uXyZf01a.3gY7w8k9L0m1N2o3P4q5R6', 'Elena Rostova', 'DEVELOPER', 1),
('qa@devflow.local', '$2a$12$K8yR2u/d2WqQ.pQ3hN3M2uXyZf01a.3gY7w8k9L0m1N2o3P4q5R6', 'David Kim', 'QA_TESTER', 1),
('client@apexcorp.com', '$2a$12$K8yR2u/d2WqQ.pQ3hN3M2uXyZf01a.3gY7w8k9L0m1N2o3P4q5R6', 'Rachel Thorne', 'CLIENT', 1)
ON CONFLICT (email) DO NOTHING;

INSERT INTO projects (organization_id, project_key, name, description, status, priority, health_status, start_date, target_delivery_date) VALUES
(1, 'DF-PORTAL', 'Apex OmniChannel Customer Portal', 'Mission-critical enterprise client self-service and billing portal.', 'ACTIVE', 'CRITICAL', 'ON_TRACK', '2026-09-01', '2026-11-30'),
(1, 'DF-CORE', 'Cloud Infrastructure Modernization', 'Containerized microservices orchestration and zero-trust security architecture.', 'ACTIVE', 'HIGH', 'ON_TRACK', '2026-08-15', '2026-12-15')
ON CONFLICT (organization_id, project_key) DO NOTHING;

INSERT INTO requirements (project_id, req_code, title, description, acceptance_criteria, priority, status, coverage_ratio) VALUES
(1, 'REQ-01', 'Multi-Factor Biometric Authentication', 'Users must verify identity using FIDO2 WebAuthn or TOTP authenticator.', 'Passes biometric verification with fallback to SMS OTP with rate-limiting.', 'CRITICAL', 'VERIFIED', 100.0),
(1, 'REQ-02', 'Client Invoice & PDF Export Engine', 'Automated generation of cryptographically signed PDF invoices.', 'Invoices generated in under 1.2s with verified SHA-256 seal.', 'HIGH', 'APPROVED', 85.0),
(1, 'REQ-03', 'Real-time Payment Gateway Webhooks', 'Webhook listener for settlement notifications with idempotent deduplication.', 'Guaranteed single-execution handling of all incoming credit card transactions.', 'CRITICAL', 'APPROVED', 90.0)
ON CONFLICT (project_id, req_code) DO NOTHING;

INSERT INTO tasks (project_id, requirement_id, task_key, title, description, status, priority, assignee_id, reporter_id, estimate_hours, actual_hours, due_date) VALUES
(1, 1, 'TSK-101', 'Implement WebAuthn Credential Registration Service', 'Spring Security FIDO2 ceremony handlers and credential repository.', 'DONE', 'HIGH', 3, 2, 16.0, 14.5, '2026-09-25'),
(1, 2, 'TSK-102', 'Design Client Approval PDF Layout and Template Engine', 'Render warm-ivory branded layout with client signature fields.', 'IN_REVIEW', 'MEDIUM', 3, 2, 12.0, 10.0, '2026-10-25'),
(1, 3, 'TSK-103', 'Implement Payment Webhook Idempotency Store', 'Distributed Redis/SQL lock ensuring exactly-once processing.', 'IN_PROGRESS', 'CRITICAL', 3, 2, 20.0, 8.5, '2026-10-28'),
(1, NULL, 'TSK-104', 'QA Smoke Test Suite for Payment Gateways', 'Simulate sandbox transactions under network partition conditions.', 'TODO', 'HIGH', 4, 2, 8.0, 0.0, '2026-11-02')
ON CONFLICT (project_id, task_key) DO NOTHING;

INSERT INTO deliverables (project_id, task_id, title, description, deliverable_type, current_version_number, approval_status) VALUES
(1, 2, 'Apex Portal v1.2.0 Staging Release Build', 'Full release bundle including client approval portal and PDF invoice engine.', 'SOFTWARE_BUILD', 2, 'PENDING_REVIEW')
ON CONFLICT DO NOTHING;

INSERT INTO deliverable_versions (deliverable_id, version_tag, file_path, file_size_bytes, file_checksum, release_notes, uploaded_by_user_id) VALUES
(1, 'v1.2.0-rc2', '/storage/deliverables/apex_portal_v1.2.0_rc2.zip', 48921000, 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', 'Resolved styling comments on PDF preview; updated SSL cipher suite.', 3)
ON CONFLICT (deliverable_id, version_tag) DO NOTHING;

INSERT INTO test_plans (project_id, name, description, plan_type, author_id) VALUES
(1, 'Apex Portal Acceptance Plan', 'Comprehensive end-to-end regression and client sign-off test suites.', 'SYSTEM_ACCEPTANCE', 4)
ON CONFLICT DO NOTHING;

INSERT INTO releases (project_id, version_name, release_status, is_readiness_cleared, target_release_date, release_notes, authorized_by_user_id) VALUES
(1, 'Release 1.2.0 — Production', 'STAGING', FALSE, '2026-11-15', 'Production deployment of OmniChannel Portal including invoicing and biometric auth.', 2)
ON CONFLICT DO NOTHING;

INSERT INTO release_checklists (release_id, check_category, description, is_mandatory, is_satisfied) VALUES
(1, 'QA_TESTS', 'All critical and high test cases passing (>= 98% pass rate)', TRUE, TRUE),
(1, 'CLIENT_APPROVAL', 'Client sign-off recorded for deliverable v1.2.0-rc2', TRUE, FALSE),
(1, 'SECURITY_AUDIT', 'Zero critical/high vulnerabilities and SAST report clean', TRUE, TRUE),
(1, 'COMPLIANCE', 'SOC2 / ISO27001 data residency and audit trail verified', TRUE, TRUE)
ON CONFLICT DO NOTHING;
