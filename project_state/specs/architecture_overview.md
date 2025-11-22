
# Water Chemistry Calculator — Architecture Overview

Version: 1.0
Status: Canonical

---

## 1. Purpose

This document defines the overall software architecture of the Water Chemistry Calculator.
It ensures that future GPT sessions and developers maintain alignment with the intended structure, boundaries, and design philosophy.

---

## 2. High-Level Architecture

The solution contains **four primary projects**:

```
WaterChem.Domain     → Domain models, pure invariants  
WaterChem.Engine     → Calculation engine (domain logic execution)  
WaterChem.CLI        → Command-line interface  
WaterChem.GUI        → WPF desktop UI  
```

Tests:

```
WaterChem.Domain.Tests  
WaterChem.Engine.Tests  
```

Configs:

```
/configs/*.json, *.yaml, *.schema.json
```

Meta / Documentation:

```
/docs/...
/meta/gpt_memory/...
```

---

## 3. Architectural Philosophy

### **Domain-Driven Design (DDD-inspired, not orthodox)**

- Domain contains **pure data structures**, invariants, and relationships.
- No I/O, no persistence, no external dependencies.
- Domain models mirror config schemas 1:1.

### **Engine Layer**

Responsible for:

- Performing all chemistry calculations
- Applying reagent dosing logic
- Normalizing units
- Applying constraints and safety checks
- Producing intermediate calculation traces

Engine is side-effect free (deterministic).

### **CLI Layer**

- Thin wrapper
- Loads config
- Accepts parameters
- Invokes engine
- Outputs results in text format
- No logic inside CLI

### **GUI Layer**

- WPF MVVM architecture
- ViewModels call the Engine
- Displays charts, tables, and dosing recommendations
- Provides editing UI for config files
- Clean separation of UI → ViewModel → Engine → Domain

---

## 4. Config-Driven Architecture

All domain entities are mapped to config files stored in `/configs`.

Examples:

- Reagents → `/configs/reagents.json`
- Plants → `/configs/plants.json`
- Units → `/configs/units_of_measure.yaml`
- Equipment → `/configs/equipment.json`
- Water sources → `/configs/water_sources.json`

The domain classes are structurally derived from these schemas.

Engine logic is **100% dependent** on domain values loaded from config.

No hardcoding.
No repeated definitions.

---

## 5. Data Flow

```
Config → Domain → Engine → Results
```

Expanded:

```
JSON/YAML configs
      ↓
Config Loader
      ↓
Domain Models (pure)
      ↓
Engine Computation Pipelines
      ↓
CalculationTrace + Final Results
      ↓
CLI Text or GUI Visualization
```

---

## 6. Major Subsystems

### **6.1 Reagent System**

Includes:

- Reagent definitions
- Concentrations
- Residue effects
- Target adjustments
- ReagentCalculationProfile
- SafetyConstraints

### **6.2 Plant System**

Includes:

- PlantSpecies
- PlantCultivar
- PlantInstance
- GrowthStageProfile

### **6.3 Equipment System**

Includes:

- Equipment
- EquipmentType
- ReplaceablePart
- CalibrationProfile
- CalibrationRecord

### **6.4 Units / Measurement System**

Includes:

- UnitCategory
- UnitDefinition
- ConversionFormula
- UnitsConfig loader

### **6.5 Water Source System**

Includes:

- WaterSource
- WaterBaselineParameters

---

## 7. Execution Pipelines

### **7.1 Reagent Dosing Pipeline**

Input:

- Target adjustment (per species/cultivar/growth stage)
- Current water baseline
- Reagent catalog
- Units config

Output:

- Required reagent doses
- Safety checks
- Residue interactions
- CalculationTrace steps
- Final water chemistry after dosing

### **7.2 Unit Normalization Pipeline**

Converts:

- ppm ↔ mg/L
- °dGH ↔ CaCO3 mg/L
- EC ↔ TDS equivalents
- percent weight → mg/L contributions

### **7.3 Equipment Calibration Pipelines**

Tracks:

- calibration decay
- last calibration date
- expected drift
- profile-based recalibration intervals

---

## 8. Boundary Rules

### Domain cannot depend on:

- Engine
- CLI
- GUI
- JSON/YAML parsing libraries
- WPF
- Any external APIs

### Engine can depend on:

- Domain
- Unit conversion helpers
- Config loader

### CLI can depend on:

- Engine
- A config loader
- Domain for data structures

### GUI can depend on:

- Engine
- Domain (data models)

---

## 9. Naming Conventions (Linked to GPT Memory)

See:
`meta/gpt_memory/naming_conventions.md`

---

## 10. Status

Architecture is stable.
Extensions must respect boundaries without introducing coupling.
