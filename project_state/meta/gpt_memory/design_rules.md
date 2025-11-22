
# Design Rules

Version: 1.0

- Domain: pure data only
- Engine: pure logic only
- GUI: no business logic
- CLI: minimal interaction
- Config drives all behavior
- No circular dependencies
- No hardcoded units
- No hardcoded reagent effects
- No framework-specific leakage into domain
- Prefer immutability when possible
