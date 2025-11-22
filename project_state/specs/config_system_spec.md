
# Configuration System Specification

**Version:** 1.3
**Status:** Canonical
**Authoritative Source:** This file + repo schemas + domain model spec
**Purpose:** Define the *entire* configuration system end-to-end so a new GPT session can recover the design without relying on chat history.

---

# **0. Intent of This Document (Critical)**

This specification tells any future GPT:

- **How configuration defines the system—not the code.**
- **How schemas map to domain models.**
- **How the Engine expects validated, normalized objects.**
- **How the GUI auto-populates itself based on these configs.**
- **How dynamic extension works (adding new reagents, water parameters, units, etc.).**
- **How *not* to break the architecture** when modifying config files.

This file exists so that GPT never again needs to “figure it out” from incomplete memory.

---

# **1. Core Configuration Principles**

### **1.1 Universal Requirements**

All configuration in this project must follow these rules:

1. **Configuration, not code, defines all scientific, horticultural, and physical parameters.**
2. Every config file has a corresponding JSON Schema (`*.schema.json`).
3. **Schemas are source-of-truth for structure.**
4. Domain models map **1:1** to schema structures.
5. No config may be loaded without schema validation.
6. No unit fields may bypass normalization.
7. Configs must be editable through the GUI.
8. Loading must produce a **complete, validated, normalized domain object graph.**

---

# **2. Directory Structure (Canonical)**

```
configs/
  application_settings.json
  application_settings.schema.json

  environment.yaml
  environment.schema.json

  units_of_measure.yaml
  units_of_measure.schema.json

  water_sources.json
  water_sources.schema.json

  reagents.json
  reagents.schema.json

  plants.json
  plants.schema.json

  equipment.json
  equipment.schema.json

  log_record.schema.json
  calculation_trace.schema.json
```

---

# **3. Config Loader Architecture (Authoritative Spec)**

### **3.1 Loader Responsibilities**

The loader must:

- Load JSON **and** YAML seamlessly.
- Validate every file against its schema.
- Produce domain model objects.
- Normalize units based on `units_of_measure`.
- Enforce required relationships (e.g., reagent → safety constraints).
- Resolve cross-file references.
- Produce *zero* warnings or errors before engine initialization.

### **3.2 Input → Output Contract**

| Input            | Output                                  |
| ---------------- | --------------------------------------- |
| Raw config files | Strongly typed C# domain model graph    |
| Units            | Converted to canonical/base units       |
| References       | Resolved to instantiated domain objects |
| Missing values   | Rejected (never defaulted silently)     |

### **3.3 Failure Rules**

If any error occurs:

- **Reject entire load**
- Provide structured diagnostic
- Never allow partial config state

---

# **4. Canonical Config Specifications**

Below are the missing details that future GPT *must* know.

---

# **4.1 application_settings.json**

### **Purpose**

Defines global behaviors outside scientific data:

- UI preferences
- Default units
- Logging toggles
- Engine performance flags
- Feature flags
- Autoload behavior

### **Mapping**

Maps to: **ApplicationSettings** domain model.

### **Special Rules**

- Defaults cannot override domain-scientific truths.
- The GUI dynamically uses this to preselect units.
- Must never contain environment or reagent data.

---

# **4.2 environment.yaml**

### **Purpose**

Defines:

- Project metadata
- Active measurement system
- UI themes
- Default system-of-units for interpretation

### **Key Fields**

- `project_name`
- `last_modified`
- `default_unit_system`
- `ui_theme`
- `locale`

### **Mapping**

Maps to **EnvironmentConfig** (not implemented yet but planned).

---

# **4.3 units_of_measure.yaml**

### **Purpose**

Defines the **scientific backbone** of the entire application.

### **Contains**

- Unit categories (mass, volume, concentration)
- Base units per category
- Conversion formulas
- Derived units
- Dimension rules

### **Mapping**

Maps to:

- UnitCategory
- UnitDefinition
- ConversionFormula
- UnitsConfig

### **Rules**

- Every unit referenced in *any* other config must exist here.
- Conversions must be reversible.
- One base unit per category only.

### **Normalization**

All inputs → base units.

---

# **4.4 water_sources.json**

### **Purpose**

Defines:

- Named water sources
- Baseline parameter values (pH, hardness, EC, etc.)
- Units for each parameter

### **Mapping**

Maps to:

- WaterSource
- WaterBaselineParameters

### **Extensibility**

If a user wants to add a new measured water property:

- Add new field to schema
- Add field to domain model
- Engine automatically picks it up

There is **no coupling** to reagent or plant logic.

---

# **4.5 reagents.json**

### **Purpose**

Defines every chemical input the system can dose.

### **Contains**

- Reagent metadata
- Concentration
- Calculation profile
- Residue effects
- Targets (ideal ranges)
- Safety constraints

### **Mapping**

Maps to:

- Reagent
- ReagentCalculationProfile
- ReagentResidueEffect
- ReagentTarget
- SafetyConstraints

### **Critical Rule**

This file drives the **dosing engine**.
Changes here are immediately reflected dynamically.

---

# **4.6 plants.json**

### **Purpose**

Defines:

- Species
- Cultivars
- Growth stage profiles
- Nutrient targets by life stage

### **Mapping**

Maps to:

- PlantSpecies
- PlantCultivar
- PlantInstance
- GrowthStageProfile

### **Special Behavior**

Growth stages can override nutrient targets on a per-stage basis.

---

# **4.7 equipment.json**

### **Purpose**

Defines measurement hardware.

### **Contains**

- Equipment
- Replaceable parts
- Calibration profiles
- Calibration history rules

### **Mapping**

Maps to:

- Equipment
- EquipmentType
- ReplaceablePart
- ReplaceablePartsProfile
- CalibrationProfile
- CalibrationRecord

### **Important**

Calibration logic not built yet but fully defined here.

---

# **5. Schema Validation Rules (Expanded & Complete)**

A new GPT must enforce:

### **5.1 Required Fields Exist**

- No optional → required changes allowed without schema update.
- No silent fallbacks.

### **5.2 Range Validation**

Example:

- pH ∈ [0, 14]
- Temperature not < absolute zero
- Nutrient ppm ≥ 0

### **5.3 Enumeration Validation**

- unit categories
- equipment types
- concentration units

### **5.4 Cross-file References**

Examples:

- Every reagent must reference units existing in `units_of_measure.yaml`
- Every plant stage must reference known water parameters
- Every equipment type must reference known measurement categories

### **5.5 Type Safety**

Numbers cannot be strings.
Objects cannot be arrays.
Arrays cannot be scalars.

---

# **6. Config ↔ Domain Mapping Rules (Full)**

### **6.1 Direct Structural Mapping**

The domain mirrors config, not the other way around.

### **6.2 Naming Preservation**

Field names match exactly.

### **6.3 Unit Normalization**

Upon loading:

- All numerical values are converted to base units.
- Domain models store only canonical units.
- GUI shows human-friendly units based on environment config.

### **6.4 Reference Resolution**

For example:

```
water_sources.json → references units → units_of_measure.yaml
reagents.json → references targets → plants.json growth stages
```

### **6.5 Idempotence**

Loading twice produces identical objects.
No randomness or mutation is allowed in the loader.

---

# **7. Extensibility Rules (Critical)**

### **7.1 Adding a New Water Parameter**

Steps:

1. Add to schema
2. Add to domain model
3. Engine auto-handles it
4. GUI auto-detects it

Because everything is data-driven.

### **7.2 Adding a New Reagent**

No code changes required.

### **7.3 Adding New Units**

Conversion formula required.

### **7.4 Adding UI Features**

All UI integration is dynamic based on:

- `application_settings`
- Available units
- Config categories
- Plant growth stages
- Reagent list

---

# **8. Relationship to Engine**

### **The Engine expects:**

- Fully resolved objects
- Normalized units
- Validated numeric ranges
- Complete metadata
- No missing fields

### **The Config System guarantees:**

- If config loads, engine will run.
- If config fails, engine cannot start.

This prevents undefined behavior.

---

# **9. Relationship to GUI**

The GUI dynamically loads config and automatically:

- Populates dropdowns
- Presents unit options
- Shows reagent lists
- Shows plant species and cultivars
- Displays equipment and calibration data

No UI element should be hardcoded for these.

---

# **10. Future Extensions (Guaranteed Support)**

### Will be supported through config-only changes:

- Additional nutrient types
- Additional plant development stages
- Additional reagent types
- Additional water-quality parameters
- Additional measurement equipment
- Arbitrary units

No code modification required.

---

# **END OF CONFIG SYSTEM SPECIFICATION**
