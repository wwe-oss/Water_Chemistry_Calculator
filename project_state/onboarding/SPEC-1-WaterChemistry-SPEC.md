# SPEC-1-Water Chemistry Dosing Engine & Logger

## Background

You value precision, explicit assumptions, and traceability. The “getting to know each other” narrative is part of the product because it encodes intent and decision criteria—not just code. This SPEC captures both technical and human context so contractors can implement without losing the why.

### Working Agreement
- No hidden assumptions; assumptions are stated explicitly.
- Small, verifiable steps; each change is diff-friendly.
- Deterministic outputs; no background work or “wait and see”.
- Human context matters: decisions include motivation, tradeoffs, and constraints.

## Requirements

### Must Have (M)
- Single-language implementation **C#/.NET (Windows-first)**; engine as a class library with exhaustive unit tests; minimal CLI first; GUI later.
- Domain: automated irrigation water for plants; initial target range **pH 5.8–6.2**.
- Reagents & Paths:
  - **Dechlorination:** Sodium metabisulfite (Na₂S₂O₅), product-defined assay/purity; compute mass for free chlorine/chloramine removal; track resulting **Na⁺** and **SO₄²⁻**.
  - **pH Down:** Sodium bisulfate (NaHSO₄), activity-aware; track Na⁺ and SO₄²⁻.
  - **pH Up:** Aeration/off-gassing model (ambient CO₂ configurable); NaHCO₃ only for corrections.
- Cumulative residue tracking: Na⁺, SO₄²⁻, ionic strength/TDS contribution (no rounding in storage).
- Plant & genome profiles: configurable target ranges/sensitivities per species/cultivar; assign to plants/batches.
- Water source profiles: e.g., hose, DI, distilled; each with baseline parameters; default **5‑gallon** volume configurable.
- Equipment profiles: brand/model, tolerances, calibration procedures and validity windows; reagent/test‑kit expiry tracking.
- Configuration-driven: external **JSON** for environmentals, reagents (assay, hydration state), water/equipment profiles, solver tolerances, and UI precision.
- Units: full conversion graph (mass, volume, ion & as CaCO₃, molarity/normality, temperature, EC/TDS). Internal math at max precision; display precision configurable.
- Immutable audit logging: append-only with timestamps (timezone-aware), actor, inputs, outputs, calc trace; robust error handling and structured logs.
- Timers/notifications for waits (e.g., equilibration) with notifications.

### Should Have (S)
- Solubility and unsafe-change checks with concise UI messaging.
- What‑if sandbox and recipe export.

### Could Have (C)
- Inventory lots & costs; device ingestion; CSV/app-dump import/export; GUI; CI; additional reagents; installers.

### Won’t Have (W) in v1
- Live device integrations; multi-language implementations; complex GUI.

## Method

### Technology Stack (Windows-first)
- **Language/Runtime:** C# / .NET (LTS)
- **IDE:** Visual Studio Code on Windows 11
- **Core Libraries:** UnitsNet, MathNet.Numerics, System.Text.Json, Microsoft.Data.Sqlite
- **Useful Extensions:** C# Dev Kit, NuGet Package Manager GUI, JSON Tools, XML Tools

### Repository & Directory Structure
```
src/
  WaterChem.Engine/
  WaterChem.Domain/
  WaterChem.GUI/
  WaterChem.CLI/
configs/
  reagents.json
  equipment.json
  plants.json
  water_sources.json
  environment.json
logs/
docs/
tests/
  WaterChem.Engine.Tests/
  WaterChem.Domain.Tests/
README.md
```

### Project Wiring (References)
- GUI → Engine
- Engine → Domain
- (Optional) CLI → Engine

### Configuration Schemas (Drafts)

#### Plants
```json
{
  "plants": [
    {
      "species_id": "cannabis_sativa",
      "species_name": "Cannabis sativa",
      "stages": {
        "seedling": { "ph_range": [5.5, 6.0], "ec_range": [0.8, 1.2], "nutrient_uptake": {} },
        "vegetative": { "ph_range": [5.8, 6.2], "ec_range": [1.2, 1.8], "nutrient_uptake": {} },
        "flowering": { "ph_range": [6.0, 6.5], "ec_range": [1.8, 2.5], "nutrient_uptake": {} },
        "preharvest": { "ph_range": [6.0, 6.5], "ec_range": [1.0, 1.5], "nutrient_uptake": {} }
      },
      "cultivars": [
        {
          "cultivar_id": "example_cultivar",
          "name": "Example Cultivar",
          "notes": "optional",
          "instances": [
            {
              "instance_id": "plant_001",
              "location": "tent_a",
              "water_source_id": "hose_water",
              "equipment_ids": ["acinfinity_ph_pro", "generic_ec_meter"],
              "notes": "optional"
            }
          ]
        }
      ]
    }
  ]
}
```

#### Water Sources
```json
{
  "water_sources": [
    {
      "id": "hose_water",
      "display_name": "Outdoor Hose Water",
      "type": "tap",
      "baseline": {
        "ph": null,
        "ec": null,
        "tds": null,
        "temperature_c": null,
        "chlorine_mg_per_l": null,
        "chloramine_mg_per_l": null,
        "hardness_mg_per_l": null,
        "alkalinity_mg_per_l": null
      },
      "notes": "Optional notes about this water source."
    },
    {
      "id": "distilled",
      "display_name": "Distilled Water",
      "type": "distilled",
      "baseline": {
        "ph": null,
        "ec": 0.0,
        "tds": 0.0,
        "temperature_c": null,
        "chlorine_mg_per_l": 0.0,
        "chloramine_mg_per_l": 0.0,
        "hardness_mg_per_l": 0.0,
        "alkalinity_mg_per_l": 0.0
      },
      "notes": "Chemically neutral reference water."
    }
  ]
}
```

#### Reagents
```json
{
  "reagents": [
    {
      "id": "sodium_metabisulfite",
      "display_name": "Sodium Metabisulfite (Campden Tablets)",
      "state": "solid",
      "formula": "Na2S2O5",
      "assay_percent": 100.0,
      "density_g_per_ml": null,
      "vendor": null,
      "product_name": null,
      "notes": "Used for dechlorination. Produces Na+ and sulfate residues.",
      "calculation": {
        "targets": ["chlorine", "chloramine"],
        "effects": {
          "sodium_mg_per_g": null,
          "sulfate_mg_per_g": null
        }
      }
    },
    {
      "id": "sodium_bisulfate",
      "display_name": "Sodium Bisulfate (pH Down)",
      "state": "solid",
      "formula": "NaHSO4",
      "assay_percent": 93.0,
      "density_g_per_ml": null,
      "vendor": "PoolTime",
      "product_name": "pH Down",
      "notes": "Primary acid for reducing pH.",
      "calculation": {
        "targets": ["ph"],
        "effects": {
          "sodium_mg_per_g": null,
          "sulfate_mg_per_g": null
        }
      }
    }
  ]
}
```

#### Equipment
```json
{
  "equipment": [
    {
      "id": "acinfinity_ph_pro",
      "type": "ph_meter",
      "display_name": "AC Infinity pH Meter Pro",
      "measurements": ["ph", "temperature"],
      "temperature_compensated": false,
      "tolerance": { "ph": 0.01 },
      "tolerance_default_allowed": true,
      "calibration": {
        "required": true,
        "solutions": ["pH 4.00", "pH 7.00", "pH 10.00"],
        "history": [],
        "valid_days": 30,
        "valid_reading_count": 200,
        "use_based_recommendations": true
      },
      "replaceable_parts": {
        "has_replaceable_parts": true,
        "parts": [
          {
            "name": "pH Electrode",
            "vendor": null,
            "product_name": null,
            "purchase_link": null,
            "notes": null
          }
        ]
      },
      "notes": ""
    },
    {
      "id": "generic_ec_meter",
      "type": "ec_meter",
      "display_name": "Generic EC/TDS Meter",
      "measurements": ["ec", "tds", "temperature"],
      "temperature_compensated": true,
      "tolerance": { "ec": 2.0, "tds": 2.0 },
      "tolerance_default_allowed": true,
      "calibration": {
        "required": false,
        "history": [],
        "valid_days": null,
        "valid_reading_count": null,
        "use_based_recommendations": false
      },
      "replaceable_parts": { "has_replaceable_parts": false, "parts": [] },
      "notes": "Generic handheld meter."
    }
  ]
}
```

### High-Level Engine Components
- **Domain Models:** Reagent, WaterSource, PlantProfile, Equipment, Measurement, DosePlan, AuditEntry
- **Engine Services:** ChemistryService (stoichiometry/acid-base), DosePlanner, ResidueTracker, UnitConverter, ValidationService
- **Persistence:** Append-only SQLite (WAL) for logs; JSON configs loaded/validated at startup

```plantuml
@startuml
skinparam shadowing false
package "WaterChem" {
  package Domain {
    class Reagent { id; formula; assayPercent; state }
    class WaterSource { id; baseline }
    class PlantProfile { speciesId; stages }
    class Equipment { id; tolerances; calibration }
  }
  package Engine {
    class ChemistryService
    class DosePlanner
    class ResidueTracker
    class UnitConverter
    class ValidationService
  }
  Domain.Reagent --> Engine.ChemistryService
  Domain.WaterSource --> Engine.DosePlanner
  Domain.PlantProfile --> Engine.DosePlanner
  Domain.Equipment --> Engine.ValidationService
}
@enduml
```

## Implementation

1. **Solution Setup**: Create Engine, Domain, GUI (WPF), and optional CLI projects. Add references (GUI→Engine, Engine→Domain, CLI→Engine). Add xUnit test projects.
2. **Packages**: Add UnitsNet, MathNet.Numerics, Microsoft.Data.Sqlite, System.Text.Json.
3. **Config Loader & Validators**: Implement JSON schema validation for `configs/*.json`; fail-fast with clear errors.
4. **Audit Store**: Create SQLite with append-only table for `AuditEntry` (timestamp with timezone, actor, inputs, outputs, trace JSON).
5. **ChemistryService (MVP)**: Implement dechlorination and pH down calculations with precision types; return residue deltas.
6. **DosePlanner**: Combine baseline water + target range + reagent capabilities to propose dose steps; include “what‑if” preview.
7. **CLI**: Commands to load configs, compute doses, and write audit entries.
8. **GUI (later)**: Minimal WPF screen to run a plan and view results/logs.

## Milestones
- **M1 – Repo & Skeleton**: Projects, references, tests, CI stub.
- **M2 – Configs**: Finalize JSON schemas and validators; seed example configs.
- **M3 – Chemistry v1**: Dechlorination + pH Down solver with unit tests.
- **M4 – Residue Tracking**: Accumulate Na⁺/SO₄²⁻/TDS; unsafe-change checks.
- **M5 – Audit & CLI**: Append-only logs + working CLI.
- **M6 – GUI MVP**: Minimal WPF UI to run dosing and view logs.

## Gathering Results
- **Functional**: Achieved pH/EC vs targets on sample scenarios; verify stoichiometric traces.
- **Reliability**: Unit test coverage ≥90% for Engine; determinism checks across inputs.
- **Usability**: Time-to-dose ≤ 60s from baseline → plan; clear error messages.
- **Data Quality**: 100% of operations produce an immutable audit entry.

## Need Professional Help in Developing Your Architecture?
Please contact me at [sammuti.com](https://sammuti.com) :)
