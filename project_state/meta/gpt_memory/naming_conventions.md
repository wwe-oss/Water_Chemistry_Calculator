
# Naming Conventions

This document is the canonical and authoritative naming standard for the Water Chemistry Calculator project.
Every future GPT instance must adhere strictly to these rules.
These conventions override any defaults or preferences of the model.

---

## 1. General Principles

### 1.1 Consistency Over Preference

All naming across all layers—Domain, Engine, CLI, GUI, Config, Tests—must:

- Use the same patterns across the entire codebase
- Preserve existing names unless explicitly changed
- Follow these conventions even if another option feels cleaner

### 1.2 Intent-Preserving Naming

Names must express:

- Purpose
- Domain meaning
- Operational role
- Scope boundaries

Names must never be abbreviated in ways that obscure meaning.

---

## 2. C# Code Naming

### 2.1 Classes

PascalCaseExamples:

- ReagentCalculationProfile
- PlantInstance
- EquipmentType
- WaterBaselineParameters

### 2.2 Interfaces

Prefix with `I`, PascalCaseExamples:

- ICalculationEngine
- IUnitConverter

### 2.3 Methods

PascalCase, verbsExamples:

- CalculateDose()
- GetCultivars()
- LoadConfiguration()

### 2.4 Properties

PascalCaseExamples:

- Mass
- Purity
- SpeciesName
- CalibrationIntervalDays

### 2.5 Private Fields

`_camelCase` with underscore prefixExamples:

- _cache
- _logger
- _profilesById

### 2.6 Local Variables

camelCaseExamples:

- adjustedMass
- doseRequired
- speciesId

---

## 3. File & Folder Naming

### 3.1 Project Structure

Each project under:

    src/

    WaterChem.Domain/

    WaterChem.Engine/

    WaterChem.GUI/

    WaterChem.CLI/

    tests/

    WaterChem.Domain.Tests/

    WaterChem.Engine.Tests/


### 3.2 File Naming

File name = Class name + `.cs`

### 3.3 Folder Naming (Domain)

Semantic folders (singular):

- Reagents
- Plants
- Equipment
- Units
- WaterSources

All PascalCase.

---

## 4. JSON Config Naming

### 4.1 Keys use snake_case

Examples:

- reagent_name
- unit_symbol
- growth_stages
- equipment_type

### 4.2 File names lowercase snake_case

Examples:

- plants.json
- reagents.schema.json
- units_of_measure.yaml
- equipment.schema.json

### 4.3 Arrays use plural nouns

Examples:

- cultivars
- stages
- targets
- sources

---

## 5. UI Naming (XAML + GUI Logic)

### 5.1 XAML Controls

camelCase with suffixExamples:

- calculateButton
- speciesDropdown
- doseResultText

### 5.2 Code-Behind Members

Follow C# conventions.

---

## 6. Engine Naming Rules

### 6.1 Engine Class Structure

- [Domain Concept] + EngineExamples:
- ReagentCalculationEngine

### 6.2 Algorithmic Method Naming

Must reflect action + domainExamples:

- ComputeAdjustedDose
- EvaluateSafetyConstraints
- CalculateMassForTargetPpm

### 6.3 Cross-Domain Operations

Explicit compositesExamples:

- ReagentToWaterInteraction
- ResidueEffectEvaluator

---

## 7. Test Naming

### 7.1 Test Classes

`[ClassName]Tests`

### 7.2 Test Methods

Method_Scenario_ExpectedExamples:

- CalculateDose_WithHighPurity_ReturnsCorrectMass
- LoadConfig_WithInvalidSchema_ThrowsValidationError

---

## 8. Domain-Specific Naming Standards

### 8.1 Reagents

Classes:

- Reagent
- ReagentTarget
- ReagentMetadata
  Profiles end with `Profile`
  Residue effects end with `Effect`

### 8.2 Plants

- PlantSpecies
- PlantCultivar
- PlantInstance
- GrowthStageProfile

### 8.3 Units

- UnitDefinition
- ConversionFormula
- UnitCategory

### 8.4 Equipment

- Equipment
- EquipmentType
- CalibrationProfile
- ReplaceablePart

---

## 9. Reserved Prefixes & Prohibited Patterns

### 9.1 Prefixes NEVER to be used

- My
- Data
- Helper
- Utils
- Manager
- Thing
- Obj

### 9.2 Disallowed Words in Class Names

- Misc
- General
- Processor
- Handler (unless messaging-specific)
- Service (domain is not service-oriented)

---

## 10. Future-Constrained Naming

### 10.1 Adding New Subdomains

- Folder = Concept (singular)
- File = Class

### 10.2 Derived Types

Names must NOT abbreviate domain languageExamples:

- ChelatedReagent
- BufferedReagent

### 10.3 Additional Engine Modules

Follow:

- [Domain Concept] + Engine
- [Domain Operation] + Calculator

---

## 11. Final Enforcement Rules

### 11.1 This file is binding.

Future GPT sessions MUST use this file as the naming authority.

### 11.2 GPT must self-correct violations.

If a generated name breaks these rules, GPT must correct itself automatically.

### 11.3 This file may not be changed without explicit user approval.

---

END OF FILE
