
# Engine Logic Specification

Version: 1.0
Status: Canonical

This document describes the duties, rules, and computational model of the Engine subsystem.

---

# 1. Principles

- Engine is **pure logic**.
- Deterministic outputs.
- No I/O except reading domain objects.
- No dependency on UI or CLI.
- Config-driven behavior.
- All math steps are recorded in `CalculationTrace`.

---

# 2. Responsibilities

1. **Normalize units**
2. **Compute reagent doses**
3. **Adjust water chemistry values**
4. **Handle residue interactions**
5. **Perform safety validation**
6. **Generate calculation trace**
7. **Compute post-dose water chemistry**
8. **Assist GUI with computed intermediate values**

---

# 3. Major Pipelines

## 3.1 Unit Normalization Pipeline

Converts any given measurement to the canonical base unit.

Steps:

1. Determine category
2. Read `UnitDefinition`
3. Apply `ToBaseFormula` via expression parser
4. Return normalized value

---

## 3.2 Reagent Dosing Pipeline

Given:

- Target adjustments
- ReagentCalculationProfiles
- Current water baseline
- Unit definitions

Output:

- Exact dose per reagent
- Residue effects
- CalculationTrace
- Final water chemistry

Steps:

1. Identify parameters requiring adjustment
2. For each parameter:
   - Choose reagent(s) capable of affecting it
   - Convert adjustment amount to base unit
   - Compute required dose = adjustment / adjustmentPerUnitDose
3. Apply stoichiometric constraints
4. Apply safety constraints
5. Compute cumulative effect
6. Append trace steps
7. Produce final water chemistry snapshot

---

## 3.3 Safety Validation Pipeline

Steps:

- Enforce MaxDosePerBatch
- Enforce MaxDosePerLitre
- Prevent incompatible combinations
- Validate computed adjustments fall within allowed ranges

---

## 3.4 Residue Impact Pipeline

Each reagent may have:

- pH shift
- Hardness change
- EC rise
- Cation/anion contributions

Process:

1. Accumulate all impacts
2. Apply buffering factors
3. Update water chemistry

---

## 3.5 CalculationTrace Generation

Every step produces:

- Operation name
- Input values
- Output values
- Units
- Intermediate calculations
- Notes

Trace must be deterministic.

---

# 4. Engine Output

Engine returns a `FinalCalculationResult` object containing:

- `InitialWaterParameters`
- `TargetParameters`
- `AppliedAdjustments`
- `ReagentDoses`
- `ResidueEffects`
- `SafetyResults`
- `FinalWaterParameters`
- `CalculationTrace`

---

# 5. Extensibility Rules

- Adding new parameters requires only:
  - Updating config
  - Updating domain models
  - Extending reagent profiles

Engine logic must remain generic.

---

# End of Engine Logic Spec
