# DevFlow Automated Testing & Verification Guide

## Test Suite Structure

DevFlow maintains automated tests across both backend and frontend layers:

- **Backend Unit & Integration Tests**: Located in `src/test/java/com/devflow/`
  - `AuthServiceTest.java`: Validates registration, password hashing, and JWT token issuance.
  - `ProjectServiceTest.java`: Validates project lifecycle, role assignment, and health metrics.
  - `ApprovalWorkflowTest.java`: Tests client approval transitions, revision lockouts, and feedback capture.
  - `ReleaseReadinessTest.java`: Verifies gatekeeper rules (blockers, test pass thresholds, sign-offs).
  - `RequirementTraceabilityTest.java`: Tests requirement linking and coverage calculations.

- **Frontend Tests**: Located in `tests/`
  - `approval_workflow.test.js`: Validates client revision and decision states.
  - `release_gate.test.js`: Validates readiness calculation logic.
  - `kanban_status.test.js`: Validates task status transitions.

## Running Tests

```bash
# Run backend tests
mvn test

# Run frontend tests
npm test
```
