
# Domain Model Specification

Version: 1.0
Status: Canonical

This document defines every domain entity in the Water Chemistry Calculator system.

Domain models are:

- Pure data classes
- No logic
- Fully derived from config schemas
- Immutable where possible
- Free of I/O and external dependencies

---

# 1. Reagents Domain

## 1.1 Reagent

Represents a chemical substance added to water.

Fields:

- `Id` (string)
- `Name` (string)
- `ChemicalFormula` (string)
- `PurityPercent` (double?)
- `Concentration` (double)
- `ConcentrationUnit` (string)
- `Density` (double?)
- `ResidueEffect` (ReagentResidueEffect?)
- `Safety` (SafetyConstraints)
- `Metadata` (ReagentMetadata)
- `CalculationProfile` (ReagentCalculationProfile)

---

## 1.2 ReagentMetadata

Describes factual, reference information.

Fields:

- `Description`
- `Manufacturer`
- `ProductCode`
- `Tags: string[]`
- `DocumentationUrl`

---

## 1.3 ReagentResidueEffect

Describes side effects after dosing.

Fields:

- `AlkalinityImpact` (double)
- `HardnessImpact` (double)
- `ElectricalConductivityImpact` (double)
- `Notes` (string)

---

## 1.4 SafetyConstraints

Defines limits for safe chemical use.

Fields:

- `MaxDosePerLitre`
- `MaxDosePerBatch`
- `CumulativeLimit`
- `IncompatibleReagents: string[]`

---

## 1.5 ReagentCalculationProfile

Defines how this reagent affects water chemistry.

Fields:

- `Targets: ReagentTarget[]`
- `StoichiometricRatio`
- `NeutralizationFactor`
- `pHImpactStrength`
- `IsBufferingAgent`

---

## 1.6 ReagentTarget

Defines a target parameter the reagent adjusts.

Fields:

- `Parameter` (string)
- `PreferredUnit`
- `AdjustmentPerUnitDose` (double)
- `MaxAdjustment`
- `MinAdjustment`

---

# 2. Plants Domain

## 2.1 PlantSpecies

Represents plant-level constants.

Fields:

- `Id`
- `CommonName`
- `ScientificName`
- `DefaultCultivarId`
- `GrowthStages: GrowthStageProfile[]`

---

## 2.2 PlantCultivar

Represents cultivar-level overrides.

Fields:

- `Id`
- `SpeciesId`
- `Name`
- `Notes`
- `Overrides: Dictionary<string,double>`
- `PreferredParameters: Dictionary<string,double>`

---

## 2.3 PlantInstance

Represents one growing plant batch.

Fields:

- `Id`
- `SpeciesId`
- `CultivarId`
- `GrowthStageId`
- `AgeDays`
- `TargetParameters: Dictionary<string,double>`

---

## 2.4 GrowthStageProfile

Defines water chemistry requirements per stage.

Fields:

- `Id`
- `Name`
- `StageDurationDays`
- `RequiredParameters: Dictionary<string,double>`

---

# 3. Equipment Domain

## 3.1 Equipment

Represents physical devices.

Fields:

- `Id`
- `TypeId`
- `Name`
- `SerialNumber`
- `CalibrationProfile`
- `ReplaceableParts: ReplaceablePart[]`

---

## 3.2 EquipmentType

Defines classification of equipment.

Fields:

- `Id`
- `Category`
- `MeasurementCapabilities: string[]`

---

## 3.3 EquipmentSet

A collection of equipment grouped logically.

Fields:

- `Id`
- `Name`
- `EquipmentIds: string[]`

---

## 3.4 ReplaceablePart

Represents a consumable or degradable component.

Fields:

- `Id`
- `Name`
- `PartNumber`
- `ExpectedLifetimeHours`
- `Notes`

---

## 3.5 ReplaceablePartsProfile

Maps equipment to expected part replacements.

Fields:

- `EquipmentTypeId`
- `Parts: ReplaceablePart[]`

---

## 3.6 CalibrationProfile

Rules for calibration.

Fields:

- `Id`
- `CalibrationIntervalDays`
- `DriftPerDay`
- `CalibrationMethod`
- `Notes`

---

## 3.7 CalibrationRecord

Historical record of calibration.

Fields:

- `Id`
- `EquipmentId`
- `Timestamp`
- `ValueBefore`
- `ValueAfter`
- `Technician`
- `Notes`

---

# 4. Units Domain

## 4.1 UnitCategory

Defines a measurement category (e.g., Mass, Volume, Concentration).

Fields:

- `Id`
- `Name`
- `BaseUnit`

---

## 4.2 UnitDefinition

Represents a unit and its conversion to/from base unit.

Fields:

- `Id`
- `CategoryId`
- `Abbreviation`
- `ToBaseFormula`
- `FromBaseFormula`

---

## 4.3 ConversionFormula

Simple expression that defines conversion.

Fields:

- `Expression`
- `Variables: Dictionary<string,double>`

---

## 4.4 UnitsConfig

Root object containing all categories + definitions.

Fields:

- `Categories: UnitCategory[]`
- `Units: UnitDefinition[]`

---

# 5. Water Sources Domain

## 5.1 WaterSource

Represents a water supply source.

Fields:

- `Id`
- `Name`
- `Baseline: WaterBaselineParameters`
- `SeasonalVariabilityNotes`

---

## 5.2 WaterBaselineParameters

Represents measured input water.

Fields:

- `pH`
- `Hardness`
- `Alkalinity`
- `Chlorine`
- `TDS`
- `EC`
- `Calcium`
- `Magnesium`
- `Sodium`
- `Iron`
- `Nitrate`
- `OtherParameters: Dictionary<string,double>`

---

# End of Domain Specification
