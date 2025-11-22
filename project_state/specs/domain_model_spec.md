
# Domain Model Specification

Version: 1.0
Status: Canonical + Expanded
Source File: domain_model_spec.md (merged)

This document defines *all* domain entities in the Water Chemistry Calculation System.

Domain models are:

- Pure immutable data structures
- Zero business logic
- Fully driven by config schemas
- Serialization-friendly
- Stable contracts between config loading and engine logic

This file is the **canonical single source of truth for all domain objects**.

---

# 0. Cross-Domain Principles

All domain model classes follow these universal constraints:

- **No logic** (only properties)
- **Immutable** except for collections that need initialization
- **Config-bound**: every value must appear somewhere in JSON/YAML configuration
- **Explicit types**: no `dynamic` or ambiguous structures
- **Always serializable**
- **Engine must reference domain; domain never references engine**

Relationships:

- **Reagents** affect **WaterParameters**
- **Plants** specify **target parameters** over time
- **Equipment** defines calibration + measurement capabilities
- **Units** define conversion standards
- **WaterSources** define baseline chemistry

All parameter names for chemistry must match those in:

- `configs/units_of_measure.yaml`
- `configs/reagents.schema.json`
- `configs/plants.schema.json`
- `configs/water_sources.schema.json`

---

# 1. Reagents Domain

## 1.1 Reagent

Represents a chemical substance added to water in measured quantities.

Fields:

- `Id`: string
- `Name`: string
- `ChemicalFormula`: string
- `PurityPercent`: double?
- `Concentration`: double
- `ConcentrationUnit`: string
- `Density`: double?
- `ResidueEffect`: ReagentResidueEffect?
- `Safety`: SafetyConstraints
- `Metadata`: ReagentMetadata
- `CalculationProfile`: ReagentCalculationProfile
- **Important rule:** All Reagent IDs must match IDs in `reagents.json`.

---

## 1.2 ReagentMetadata

Describes static, reference-only information.

Fields:

- `Description`: string
- `Manufacturer`: string
- `ProductCode`: string
- `Tags: string[]`
- `DocumentationUrl`: string

Metadata should never influence calculations (engine logic rule).

---

## 1.3 ReagentResidueEffect

Describes secondary impacts after dosing.

Fields:

- `AlkalinityImpact`: double
- `HardnessImpact`: double
- `ElectricalConductivityImpact`: double
- `Notes`: string

Impacts must map to recognized unit categories (validated during config load).

---

## 1.4 SafetyConstraints

Defines safe limits for chemical dosing.

Fields:

- `MaxDosePerLitre`: double
- `MaxDosePerBatch`: double
- `CumulativeLimit`: double
- `IncompatibleReagents: string[]`

Engine enforcement is *strict*; incompatible reagents cannot be dosed together.

---

## 1.5 ReagentCalculationProfile

Defines how this reagent affects water chemistry.

Fields:

- `Targets: ReagentTarget[]`
- `StoichiometricRatio`: double
- `NeutralizationFactor`: double
- `pHImpactStrength`: double
- `IsBufferingAgent`: bool

Additional Notes:

- `StoichiometricRatio` used for nutrient addition
- `NeutralizationFactor` is used for alkalinity/pH neutralization logic
- `pHImpactStrength` is a curve scalar (engine uses logarithmic pH math)

---

## 1.6 ReagentTarget

Defines which water chemistry parameter the reagent modifies.

Fields:

- `Parameter`: string
- `PreferredUnit`: string
- `AdjustmentPerUnitDose`: double
- `MaxAdjustment`: double
- `MinAdjustment`: double

Engine must validate that `Parameter` maps to a unit category in Units Domain.

---

# 2. Plants Domain

## 2.1 PlantSpecies

Represents stable genetics-level species definition.

Fields:

- `Id`: string
- `CommonName`: string
- `ScientificName`: string
- `DefaultCultivarId`: string?
- `GrowthStages: GrowthStageProfile[]`

Growth stages reference target chemistry values (pH, EC, nutrients, etc.)

---

## 2.2 PlantCultivar

Overrides species defaults with cultivar-specific traits.

Fields:

- `Id`: string
- `SpeciesId`: string
- `Name`: string
- `Notes`: string
- `Overrides: Dictionary<string,double>`
- `PreferredParameters: Dictionary<string,double>`

Cultivar overrides always override species defaults; engine merges them.

---

## 2.3 PlantInstance

Represents a real plant batch or grow.

Fields:

- `Id`: string
- `SpeciesId`: string
- `CultivarId`: string
- `GrowthStageId`: string
- `AgeDays`: int
- `TargetParameters: Dictionary<string,double>`

Engine uses AgeDays + GrowthStage definition to calculate ideal water chemistry.

---

## 2.4 GrowthStageProfile

Defines water chemistry targets for the growth stage.

Fields:

- `Id`: string
- `Name`: string
- `StageDurationDays`: int
- `RequiredParameters: Dictionary<string,double>`

Engine derives plant needs per stage through these profiles.

---

# 3. Equipment Domain

## 3.1 Equipment

Represents physical devices used in measurement or dosing.

Fields:

- `Id`: string
- `TypeId`: string
- `Name`: string
- `SerialNumber`: string
- `CalibrationProfile`: CalibrationProfile
- `ReplaceableParts: ReplaceablePart[]`

---

## 3.2 EquipmentType

Defines capabilities of the device type.

Fields:

- `Id`: string
- `Category`: string
- `MeasurementCapabilities: string[]`

Measurement capabilities map directly to unit categories (e.g., EC, pH).

---

## 3.3 EquipmentSet

Logical grouping of equipment.

Fields:

- `Id`: string
- `Name`: string
- `EquipmentIds: string[]`

---

## 3.4 ReplaceablePart

Represents consumable or wear-based components.

Fields:

- `Id`: string
- `Name`: string
- `PartNumber`: string
- `ExpectedLifetimeHours`: int
- `Notes`: string

---

## 3.5 ReplaceablePartsProfile

Defines which parts apply to which equipment types.

Fields:

- `EquipmentTypeId`: string
- `Parts: ReplaceablePart[]`

---

## 3.6 CalibrationProfile

Defines how often and how calibration works.

Fields:

- `Id`: string
- `CalibrationIntervalDays`: int
- `DriftPerDay`: double
- `CalibrationMethod`: string
- `Notes`: string

---

## 3.7 CalibrationRecord

Represents a historical calibration event.

Fields:

- `Id`: string
- `EquipmentId`: string
- `Timestamp`: DateTime
- `ValueBefore`: double
- `ValueAfter`: double
- `Technician`: string
- `Notes`: string

---

# 4. Units Domain

## 4.1 UnitCategory

Defines a measurement category (Mass, Volume, EC, pH, Hardness, etc.)

Fields:

- `Id`: string
- `Name`: string
- `BaseUnit`: string

---

## 4.2 UnitDefinition

Defines measurement units and conversion rules.

Fields:

- `Id`: string
- `CategoryId`: string
- `Abbreviation`: string
- `ToBaseFormula`: string
- `FromBaseFormula`: string

Conversion formulas are symbolic expressions evaluated by the engine.

---

## 4.3 ConversionFormula

Represents a simple algebraic conversion.

Fields:

- `Expression`: string
- `Variables: Dictionary<string,double>`

---

## 4.4 UnitsConfig

Root container for unit/category definitions.

Fields:

- `Categories: UnitCategory[]`
- `Units: UnitDefinition[]`

---

# 5. Water Sources Domain

## 5.1 WaterSource

Represents a water supply.

Fields:

- `Id`: string
- `Name`: string
- `Baseline: WaterBaselineParameters`
- `SeasonalVariabilityNotes`: string

---

## 5.2 WaterBaselineParameters

Measured raw input water values.

Fields:

- `pH`: double
- `Hardness`: double
- `Alkalinity`: double
- `Chlorine`: double
- `TDS`: double
- `EC`: double
- `Calcium`: double
- `Magnesium`: double
- `Sodium`: double
- `Iron`: double
- `Nitrate`: double
- `OtherParameters: Dictionary<string,double>`

Engine may allow parameter interpolation for seasonal changes.

---

# 6. Global Parameter Registry (NEW — required for engine)

This was missing from the uploaded version and is required for:

- cross-domain validation
- reagent → parameter targeting
- plant → target mapping
- units → category enforcement

## 6.1 ParameterDefinition

Fields:

- `Id`: string
- `Name`: string
- `UnitCategoryId`: string
- `DefaultUnit`: string
- `Description`: string

## 6.2 ParameterRegistry

Fields:

- `Parameters: ParameterDefinition[]`

Registry is derived from config schemas and maps every known parameter.

---

# 7. Rules for Engine Consumption (summary)

Every domain object must:

- Reference only IDs, never other domain objects directly
- Use parameter names exactly as defined in the registry
- Never embed logic
- Be fully serializable
- Be strict: unknown properties cause validation errors

---

# End of File (merged)S
