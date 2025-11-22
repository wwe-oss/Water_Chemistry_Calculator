
# Validation Rules

## 1. Global Validation Principles

- All configuration and runtime data must validate against their respective JSON/YAML schemas.
- All parameters must reference a valid definition in `units_of_measure`.
- Negative concentrations, negative volumes, or negative pH values are not permitted.
- All reagent impacts must be finite numeric values (no NaN, ±Infinity).
- Safety constraints must override user input in every case.
- When two or more adjustments conflict, the engine must emit a structured warning.

## 2. Schema Validation Rules

- Every config file must pass schema validation before the engine loads.
- Schema violations must produce:
  - file name
  - failed schema rule
  - failing value
  - recommended correction
- The engine cannot start with invalid configuration unless in `--override-config` developer mode.
- Cross-file validation:
  - Water sources must reference only known unit definitions.
  - Plants must reference reagent names existing in `reagents.json`.
  - Equipment definitions must reference calibration models found in `equipment.schema.json`.

## 3. Units & Measurement Validation

- Unit conversions require:
  - defined unit
  - defined category
  - valid conversion formula between source and target units
- Runtime numeric validations:
  - No division by zero in any conversion formula.
  - No logarithmic operations on non-positive values.
  - No temperature conversions below absolute zero.
- The engine must refuse:
  - Unknown units
  - Mismatched categories (ex: mass vs. volume)

## 4. Reagent Validation

### Reagent Definition Rules

- Every reagent must define:
  - name
  - concentration
  - purity (%)
  - specific ion contributions
  - safety constraints
  - residue behavior
- Reagent names must be unique.
- Reagent residue rules must specify:
  - what accumulates
  - accumulation rate
  - how it affects water chemistry

### Reagent Target Rule Validation

- Targets must reference valid water parameters.
- Targets must not exceed max safe parameter limits.
- If the target is unreachable safely, the engine must:
  - clamp the adjustment
  - issue a warning

### Reagent Calculation Validation

- Every reagent dose must be validated before returning results:
  - dose must be ≥ 0
  - resulting concentration must remain within safe system limits
- Safety constraints override target achievement.

## 5. Water Source Validation

- All baseline parameters must:
  - reference valid units
  - be non-negative
  - satisfy schema-defined parameter ranges
- Missing parameters are allowed **only** if explicitly optional in schema.
- If a parameter prevents safe dosing (e.g., extremely high hardness), engine must issue:
  - a safety block
  - a suggested corrective action

## 6. Plant & Growth Stage Validation

- Growth-stage nutrient targets must:
  - reference valid reagents
  - define complete NPK + micro requirements
  - not contain negative values
  - specify acceptable variation ranges
- Invalid stage definitions must be blocked at load time.
- Engine must validate:
  - target feasibility
  - that required reagents exist
  - that no stage requires forbidden combinations

## 7. Equipment Validation

- Calibration rules:
  - Every sensor must have a calibration profile
  - Profile must include timestamp, method, and tolerance
  - Readings outside tolerance must be rejected
- Replacement cycle validation:
  - Must define interval in valid units (hours/days)
  - Cannot be negative or zero
  - Equipment sets must reference known equipment IDs

## 8. Engine Runtime Validation

### Input Validation

- User input must be validated before any calculation:
  - volume > 0
  - pH in range [0, 14]
  - EC ≥ 0
  - All units valid and convertable

### Conflict Detection Rules

A conflict occurs when:

- Two adjustments increase/decrease the same parameter in opposite unsafe directions
- A reagent solves one imbalance while causing a worse one elsewhere
- The cumulative effect of dosing exceeds a safety threshold

The engine must:

- Detect conflicts before applying dosing
- Emit a conflict warning structure:
  - parameter
  - conflicting reagents
  - suggested resolution

### Post-Calculation Validation

After computing doses:

- Final pH must be in safe range
- Final EC must not exceed plant or system thresholds
- No parameter may exceed defined safe maxima
- If any post-validation fails, output must be:
  - auto-corrected
  - marked as “adjusted for safety”
  - flagged for review

## 9. Error Handling Rules

- Invalid user actions → structured error
- Invalid config → hard fail
- Unsafe dose → auto-correct + warning
- Missing required data → explicit error
- Unknown fields in config → warn, ignore

## 10. Logging Validation

- All warnings and errors must be logged with:

  - timestamp
  - subsystem
  - rule violated
  - input that caused violation
  - correction applied
- Validation events must appear in:

  - CLI console
  - GUI console
  - calculation trace file

## 11. Developer Mode Overrides

Developer mode (`--dev` or GUI checkbox) allows:

- bypassing schema validation
- enabling verbose numeric tracing
- disabling safety clamps
- injecting temporary units/reagents

But developer mode must NEVER:

- allow unsafe doses to be *applied*
- be enabled by default

## 12. Strict Mode

When strict mode is enabled:

- ALL configs must validate
- ALL optional parameters become required
- ALL warnings become errors
- No auto-correction permitted

Strict mode ensures total reproducibility.
