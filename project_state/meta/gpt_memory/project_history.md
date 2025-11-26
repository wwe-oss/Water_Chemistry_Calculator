
# project_history.md

## Project History — Water Chemistry Calculator

This document captures a chronological, high-signal summary of all major architectural decisions, domain definitions, patterns, constraints, refactors, corrections, and intent clarifications made throughout development.
It exists so that a future GPT instance can reconstruct the full operational context without requiring the original session.

---

## 2025-02 — Project Initialization

- Multi-project .NET solution created:
  - WaterChem.Domain
  - WaterChem.Engine
  - WaterChem.GUI (WPF)
  - WaterChem.CLI
  - Unit Test Projects
- GitHub scaffolding: issue templates, PR templates, labels, branch rules.
- Development branch established as safe working branch.

---

## 2025-02 — Domain-First Architecture Decision

- Adopted a DDD-lite approach.
- **Domain = vocabulary.**Pure data, real-world concepts, independent of infrastructure.
- **Engine = behavior.**Performs calculations, transformations, adjustments.
- **GUI/CLI = surfaces.**
  Zero business logic.

Primary reason: clarity, transparency, and cognitive manageability.

---

## 2025-02 — Configuration-Driven System

- All domain instances originate from external JSON/YAML configs.
- JSON Schemas define structure:
  - reagents.schema.json
  - units_of_measure.schema.json
  - plants.schema.json
  - water_sources.schema.json
  - equipment.schema.json
- Absolutely **no hardcoded chemical constants** in code.
- Calculation logic must use config-supplied values only.

---

## 2025-02 — Completed Domain Structures

### Reagents Domain

- Reagent
- ReagentMetadata
- ReagentCalculationProfile
- ReagentResidueEffect
- SafetyConstraints
- ReagentTarget
  **All fully implemented to match schema.**

### Plants Domain

- PlantSpecies
- PlantCultivar
- GrowthStageProfile
- PlantInstance
  **All implemented.**

### Equipment Domain

- Equipment
- EquipmentType
- EquipmentSet
- ReplaceablePart
- ReplaceablePartsProfile
- CalibrationRecord
- CalibrationProfile
  **All implemented but to be verified against schema.**

### Units Domain

- UnitDefinition
- UnitCategory
- UnitsConfig
- ConversionFormula
  **Files exist but require full implementation.**

### Water Sources Domain

- WaterSource
- WaterBaselineParameters
  **Schemas defined; implementation pending.**

---

## 2025-02 — Intent Clarification (Critical to System Function)

### User Intent

- Flexible, adaptive system — no rigidity unless absolutely required.
- GPT should have freedom to innovate within architectural boundaries.
- Avoid flooding the user with unnecessary A/B/C option branches.
- Preserve continuity, transparency, correctness, and alignment.

### Architectural Intent

- Ensure clarity by:
  - pure domain
  - behavior isolated to engine
  - configuration driving everything
  - no silent deviations
  - consistent naming conventions

### Collaboration Intent

- Ensure GPT understands the user’s cognitive model:
  - direct communication
  - low tolerance for drift
  - high emphasis on accuracy and alignment
  - requirement for transparency
  - requirement for consistency

This intent must be preserved across future sessions.

---

## 2025-02 — Critical Decisions Logged

### Supplements as Reagents

User asked whether products like CALiMAGic fit the reagent model.
Decision: **YES — all chemical additions are reagents.**

### No Enums Without Schema Source

GPT confirmed:

- No reagent type enums should be invented.
- Everything derives from config structures.

### The Domain Must Stay Pure

Domain classes must never contain:

- calculation logic
- persistence logic
- parsing logic

### The Engine Will Eventually Contain:

- pH adjustment logic
- nutrient ppm deviation corrections
- chemical interaction modeling
- dilution & concentration adjustments
- equipment-influenced variation modeling
- dosage recommendation algorithms

---

## 2025-02 — Major Corrections & Refinements

- Added EquipmentSet where needed.
- Fixed discrepancies between config schema and domain models.
- Identified missing files or naming mismatches early.
- Ensured naming scheme consistency across:
  - C# (PascalCase)
  - config (snake_case)
- Verified multiple ambiguous earlier assumptions.

---

## 2025-02 — Project State Externalization

Due to memory drift risks:

- Created **project_state/** directory in the repo.
- Includes:
  - collaboration contract
  - workflow protocol
  - all spec files
  - all gpt memory files
  - roadmap
- GPT must load these to reconstruct the session.

This allows **complete session resurrection**.

---

## 2025-02 — Stabilization Protocol

- Shift away from depending on chat memory.
- Lean on the repo as persistent context.
- GPT instructed to merge one file at a time with 100% precision.
- No tool-wrapped output.
- No extraneous explanation.

Goal: enable seamless handoff to a new GPT instance without loss.

---

## Next Steps Summary (High Resolution)

See roadmap.md for details.Condensed version:

1. Finish Units domain implementation.
2. Finish WaterSources domain implementation.
3. Implement Engine (core computational logic):
   - pH adjustment
   - alkalinity interaction
   - nutrient balance
   - dosing
   - dilution
4. Implement CLI workflows.
5. Develop full WPF GUI:
   - guided wizard
   - tabbed expert interface
   - equipment calibration flows
6. Build automated test suite.
7. Integrate all layers and finalize.

---

# END OF FILE
