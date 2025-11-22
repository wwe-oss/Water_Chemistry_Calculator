
# Configuration System Specification

Version: 1.0
Status: Canonical

This document defines how configuration files operate, how schemas map to domain models, and how config loading interacts with the Engine.

---

# 1. Config Principles

- All configuration is stored in JSON or YAML.
- Every config file has a schema (`*.schema.json`).
- Domain models map 1:1 to schema-defined structures.
- No config values are hardcoded in code.
- All units are normalized during load.
- Config can be edited by the GUI.

---

# 2. Directory Structure

```
configs/
  application_settings.json
  calculation_trace.schema.json
  environment.yaml
  equipment.json
  equipment.schema.json
  plants.json
  plants.schema.json
  reagents.json
  reagents.schema.json
  units_of_measure.yaml
  units_of_measure.schema.json
  water_sources.json
  water_sources.schema.json
```

---

# 3. Config Loader Requirements

Must handle:

- JSON
- YAML
- Validation against schema
- Deserializing into domain objects
- Normalization of required unit fields

Loader output:

- Fully validated domain object graph

---

# 4. Important Configuration Files

## 4.1 application_settings.json

Controls:

- Default units
- Logging settings
- UI preferences
- Engine performance flags

---

## 4.2 environment.yaml

Defines:

- Measurement systems
- Default unit preferences
- Project metadata
- UI theme

---

## 4.3 reagents.json

Defines:

- All reagent objects
- Concentrations
- Residue effects
- Safety constraints
- Calculation profiles

Maps to:

- Reagent
- ReagentCalculationProfile
- ReagentResidueEffect
- SafetyConstraints
- ReagentTarget

---

## 4.4 plants.json

Defines:

- Species
- Cultivars
- Growth stage profiles

Maps to:

- PlantSpecies
- PlantCultivar
- GrowthStageProfile

---

## 4.5 equipment.json

Defines:

- Equipment
- ReplacableParts
- CalibrationProfiles

Maps to:

- Equipment
- EquipmentType
- ReplaceablePart
- CalibrationProfile
- CalibrationRecord

---

## 4.6 units_of_measure.yaml

Defines:

- Unit categories
- Unit definitions
- Base units
- Conversion formulas

Maps to:

- UnitCategory
- UnitDefinition
- UnitsConfig

---

## 4.7 water_sources.json

Defines:

- Water sources
- Baseline parameters

Maps to:

- WaterSource
- WaterBaselineParameters

---

# 5. Schema Validation Rules

- All required fields must be present
- All numbers must be within allowed constraints
- All dictionary keys must match known parameters
- Unit fields must reference valid units in units_of_measure

---

# 6. Config to Domain Mapping

The mapping is direct:

- Same naming
- Same structure
- No transformation aside from unit normalization

---

# 7. Extensibility

New water parameters?
→ Add to schema → Add to domain → Engine automatically handles.

New reagent?
→ Add to config → Done.

New equipment type?
→ Add to config → GUI picks it up dynamically.

---

# End of Config System Specification
