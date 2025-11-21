# Contributing Guidelines

## Branch Strategy

- `main`: production-grade, stable only.
- `develop`: integration branch.
- `feature/*`: always branch from `develop`, then merge back via PR.

## Feature Branch Workflow

1. `git checkout develop`
2. `git pull`
3. `git checkout -b feature/<name>`
4. Make changes
5. Commit often
6. Push and open PR into `develop`

## Code Standards

- No hard-coded constants (use configs)
- All formulas must be documented
- Engine logic must be deterministic
- Public APIs must have XML documentation
- Test coverage required for Engine

## Commit Messages

Use the convention:

```
type(scope): message
```

Example:

```
feat(engine): add pH reduction solver
fix(domain): repair reagent assay validation
```

## Pull Requests

- Must pass all tests
- Must receive at least 1 approval
- Must update documentation if applicable
- Must update schemas when configs change
