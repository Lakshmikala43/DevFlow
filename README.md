# DevFlow

> **“From First Task to Final Release.”**
> Enterprise Full-Stack Software Delivery and Client Approval Management Platform.

---

## 1. Project Overview

**DevFlow** is a production-grade, centralized software delivery lifecycle and client approval orchestration platform built for IT companies, software consultancies, development agencies, and startups. It bridges the gap between engineering teams and clients by unifying requirements engineering, sprint execution, QA defect tracking, deliverable versioning, client review & sign-offs, and automated release readiness in a single workspace.

### Core Value Pillars

- **Unified Delivery Lifecycle**: Connects requirements $\rightarrow$ tasks $\rightarrow$ deliverables $\rightarrow$ QA test cases $\rightarrow$ client approvals $\rightarrow$ releases.
- **Client Sign-off & Revision Loops**: Dedicated client portal for deliverable version approvals, revisions with contextual feedback, and immutable decision histories.
- **Release Readiness Gatekeeper**: Automated calculation of release readiness based on test pass rates, blocker defect status, and required stakeholder sign-offs.
- **Enterprise Role-Based Access Control**: Strict segregation between Administrators, Project Managers, Developers, QA Testers, and External Clients.
- **Zero API Keys & Local First**: Operates 100% self-contained without mandatory paid external APIs or cloud secrets.

---

## 2. Visual Identity & Design System

DevFlow uses a human-centric, professional aesthetic intentionally designed to avoid generic AI admin styling:

- **Warm Ivory / Cream Canvas** (`#FBF9F5` / `#F7F4EE`): Clean, warm background reducing eye strain.
- **Deep Charcoal Typography** (`#1F2421` / `#23272A`): High-contrast, readable executive typography.
- **Terracotta / Coral Primary Action** (`#E05A47`): Purposeful accent for primary calls-to-action and decisions.
- **Emerald Forest Status** (`#2E7D32`): Clear indicator for passing tests, approved deliverables, and ready releases.
- **Warm Amber Status** (`#D97706`): Alert indicator for pending client reviews and blocked tasks.
- **Muted Plum Accent** (`#7C3AED`): Subtle highlighting for milestones and executive summaries.

---

## 3. Technology Stack

### Backend
- **Framework**: Java 17, Spring Boot 3.2.3
- **Security**: Spring Security 6 with JWT & Role-Based Access Control
- **Persistence**: Spring Data JPA, Hibernate, PostgreSQL & H2
- **Database Migrations**: Flyway Core
- **Build System**: Apache Maven 3.9+

### Frontend
- **Framework**: React 18 with TypeScript 5
- **Tooling**: Vite 5
- **Icons**: Lucide Icons
- **Visualizations**: Recharts
- **Styling**: Modern CSS Design System & Utility Modules

---

## 4. User Roles & Permission Matrix

| Role | Organization Scope | Project Management | Tasks & Code | QA Testing | Client Approvals | Release Sign-Off |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **Administrator** | Full Access | Full Access | View & Assign | View Reports | Audit Only | Platform Policy |
| **Project Manager** | Team Scoped | Full Control | Manage & Assign | Review Metrics | Track & Nudge | Authorize & Gate |
| **Developer** | Project Scoped | View Assumed | Execute & Upload | Link Defects | View Feedback | Track Changes |
| **QA Tester** | Project Scoped | View Assumed | Link Issues | Author & Execute | Validate Fixes | Checklist Verification |
| **Client** | Restricted | View Only | View Deliverables | View Status | Approve / Reject | Review Release Notes |

---

## 5. Functional Modules

1. **Authentication & Onboarding**: Session management, secure credential handling, and team invitation onboarding.
2. **Organization & Team Management**: Multi-tenant organizations, seat management, and directory filtering.
3. **Project Management & Milestones**: Health indicators, deadline tracking, and interactive timelines.
4. **Requirements Workspace**: Traceability matrix linking requirements to tasks, tests, and deliverables.
5. **Task & Sprint Management**: Interactive Kanban boards (Backlog, To Do, In Progress, In Review, Done) with dependencies.
6. **Deliverable Version Registry**: File upload validation, sanitized metadata, and version progression history.
7. **Client Review & Approval Portal**: Interactive deliverable review, approval/revision submission with mandatory feedback.
8. **QA & Defect Management**: Test plan creation, test run executions, defect logging, and severity matrix.
9. **Release Gatekeeper & Checklist**: Automated readiness checks, block conditions, and release note compilation.
10. **In-App Notification Center**: Real-time event notifications for assignments, review requests, and approvals.
11. **Reports, Analytics & CSV Export**: Real-time progress analytics, velocity, approval turnaround, and exportable reports.

---

## 6. Quickstart & Local Installation

### Prerequisites
- Java 17 JDK or higher
- Node.js 18+ and npm
- Maven 3.8+ (or use `./mvnw`)

### Running Locally

```bash
# 1. Clone repository
git clone https://github.com/Lakshmikala43/DevFlow.git
cd DevFlow

# 2. Run backend (Spring Boot on http://localhost:8080)
mvn spring-boot:run

# 3. In another terminal, run frontend (Vite on http://localhost:3000)
npm install
npm run dev
```

### Running with Docker Compose

```bash
docker-compose up --build -d
```

### Running Automated Test Suites

```bash
# Backend unit & integration tests
mvn test

# Frontend component & logic tests
npm test
```

### Verifying Production SLOC

```bash
python scripts/measure_loc.py
```

---

## 7. License & Authorship

- **License**: UNLICENSED (Proprietary commercial software platform)
- **Lead Architect**: DevFlow Core Engineering Team (`lead@devflow.io`)
- **Author**: Lakshmikala (`lkv8793@gmail.com`)
