# DevFlow Engineering Contribution Guidelines

## Git Branching Strategy
- Main branch: `main` (production-ready code).
- Feature branches: `feature/<feature-name>` (e.g., `feature/client-approvals`, `feature/release-gatekeeper`).
- Bugfix branches: `fix/<bug-name>` (e.g., `fix/jwt-expiration-handler`).
- Pull Requests: Must include testing evidence, problem statement, and pass all CI checks before merge (`git merge --no-ff`).

## Dual Collaborator Workflow
- Commits and pull requests are distributed across lead architecture (`DevFlow Lead Architect <lead@devflow.io>`) and engineering contributors (`Lakshmikala <lkv8793@gmail.com>`).
- Every merge commit adheres to the standard pattern:
  `Merge pull request #XX from feature/<feature-name>: <description>`
