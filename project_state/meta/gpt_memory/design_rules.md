
# Design Rules

Version: 1.1 (Merged & Expanded)

## 1. Domain Layer Rules

- Domain contains **only data structures**, value objects, aggregates, and invariants.
- No business logic that depends on external systems or frameworks.
- No framework types (no EF types, no UI types, no infrastructure types).
- Domain objects are **persistence-agnostic**.
- Domain objects must express **intent explicitly** (fields must be meaningfully named, no “misc”, “other”, etc.).
- Prefer **immutability** whenever feasible.
- Domain models must map 1:1 with configuration schema definitions.
- Domain models must not perform calculations—only hold values and express constraints.
- Domain may contain *validation logic* only if it expresses *domain invariants* (not transformation or conversion logic).

## 2. Engine Layer Rules

- Engine contains all **logic**, transformations, calculations, and rules.
- Engine is the only layer allowed to:
  - Perform reagent calculations.
  - Evaluate residue effects.
  - Apply plant stage logic.
  - Combine inputs from domain + config.
- No UI, no CLI, no EF, no I/O.
- Engine is stateless when possible; stateful components must be isolated.
- All units must be converted through the units subsystem—**no hardcoded conversions**.
- Logic must be functional, pure, deterministic unless explicitly documented.
- Engine logic must rely exclusively on configuration-driven inputs and domain models.

## 3. GUI Layer Rules

- GUI contains **no business logic**.
- GUI reads state provided by Engine or CLI.
- GUI triggers calculations but never performs them.
- GUI may:
  - Build view models.
  - Map data to user controls.
  - Display Engine results.
- GUI may not:
  - Convert units.
  - Compute reagent doses.
  - Determine required calibration.
  - Evaluate growth stages.
- GUI follows MVVM:
  - ViewModels may contain **UI-specific state**, never domain logic.
  - Views are strictly declarative.

## 4. CLI Rules

- CLI provides a text interface to the Engine.
- CLI contains minimal logic:
  - Input parsing.
  - Passing data to Engine.
  - Printing output.
- No calculations.
- No direct domain manipulation.

## 5. Configuration Rules

- **Config drives all behavior.** Nothing is hardcoded.
- Every constant (units, boundaries, reagent effects, safety limits, growth stage thresholds, equipment tolerances, etc.) must come from config.
- Config files must have JSON schema equivalents.
- Config schema changes must propagate to:
  - domain models
  - engine logic
  - UI schema-aware components (if any)

## 6. Dependency Rules

- No circular dependencies between:
  - Domain ↔ Engine
  - Engine ↔ GUI
  - Domain ↔ GUI
- Dependencies flow **inward**:
  - GUI → Engine → Domain

## 7. Unit & Conversion Rules

- No hardcoded unit conversion constants.
- Units must be registered through configuration.
- All unit conversion must occur through the Units subsystem.
- Units subsystem must remain independent from reagents, plants, water sources, and equipment.

## 8. Reagent Logic Rules

- No hardcoded reagent effects.
- No logic tied to specific reagent names.
- All effects, constraints, and target mappings must be config-driven.
- ReagentCalculationProfile defines:
  - how dose is computed
  - scaling rules
  - interaction flags
- Safety constraints must always be enforced in Engine.

## 9. Equipment Rules

- Equipment models define:
  - capabilities
  - calibration profiles
  - replaceable parts
- No logic in domain.
- Engine handles:
  - calibration due dates
  - equipment suitability
  - measurement uncertainty propagation

## 10. Water Source Rules

- All water baseline chemistry is loaded from config.
- No defaults are hardcoded.
- Engine performs:
  - dominance analysis
  - alkalinity adjustments
  - pH-dependent transformations

## 11. Coding Standards

- All code production-ready.
- Meaningful naming required.
- No magic numbers.
- No implicit type conversions.
- Extensive inline documentation:
  - document *why*, not just *what*.
- Use established design patterns when appropriate:
  - Strategy (calculation modes)
  - Factory (unit creation)
  - Adapter (equipment capability mapping)
  - Builder (complex Engine requests)
  - MVVM (GUI)

## 12. Error Handling Rules

- Engine returns structured errors with:
  - error code
  - human-readable description
  - recommended corrective action
- Domain should not throw complex exceptions.
- UI should display meaningful errors without stack traces.
- CLI prints concise error messages.

## 13. Persistence / State Rules

- Domain models are not allowed to contain persistence concerns.
- No EF annotations in domain classes.
- If EF is used later, mappings are external (Fluent API).

## 14. Testing Rules

- Tests exist at:
  - domain model validation level
  - engine logic correctness level
  - config schema validation level
- Test data is explicit and documented.
- Engine must be fully testable without UI or CLI.

## 15. Architectural Integrity Rules

- Simplicity > cleverness.
- Consistency > novelty.
- Clarity > optimization.
- Everything must be predictable and reproducible.
- The project must remain modular, decomposable, and extendable.
