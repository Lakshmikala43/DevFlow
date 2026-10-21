# DevFlow Security Policy & Threat Model

## 1. Zero Secrets & Local-First Principles

DevFlow is strictly designed to operate without embedding, requiring, or exposing API keys, secret credentials, or paid cloud APIs:
- Authentication is handled locally via BCrypt password hashing and self-signed stateless JWT tokens.
- No third-party AI keys (OpenAI/Anthropic) are required or embedded.
- No third-party email service credentials (SendGrid/Mailgun) are hardcoded; local development uses an internal mail sink / mock logger.
- Environment variable examples are safe and contain placeholder keys only.
- Committed `.env*` files are strictly banned and excluded via `.gitignore`.

## 2. Access Control Model

DevFlow implements defense-in-depth authorization:
- **Tenant Isolation**: Every entity (projects, tasks, deliverables, defects) is partitioned by `organization_id`. Database queries strictly filter by tenant.
- **Client Sandbox**: Users with the `CLIENT` role cannot view internal developer work logs, raw QA notes, or unreleased draft requirements. They only access designated deliverable review versions and client-facing release notes.
- **CSRF & Injection Mitigation**: Stateless JWT with strict CORS origins, prepared statements via Hibernate ORM, and sanitized HTML output preventing XSS.
