
# UI Strategy Specification

**Project:** Water Chemistry Calculator
**Component:** WPF GUI
**Document Purpose:**
This file defines the strategic principles, interaction flow, UI architecture, and integration boundaries for the graphical interface.
It exists to ensure UI development remains aligned with domain-driven design, engine logic, and user intent—without reintroducing drift.

---

## 1. Core Principles

The UI must adhere to the following:

### **1.1 Separation of Concerns**

- GUI **never** implements chemistry logic.
- It interacts *only* with:
  - `WaterChem.Engine` (calculations)
  - Domain models (read-only binding & validation)
  - Config loader services (init-time only)

### **1.2 MVVM Pattern (Strict)**

WPF must follow MVVM with the following constraints:

- **Models** → hydrated domain objects *(never modified directly)*
- **ViewModels** → hold reactive state, map user input, trigger engine calls
- **Views** → XAML-only, no logic besides animations/visual states

No hybrid patterns, no “code-behind except for View-only behavior”.

### **1.3 Data Consistency**

Domain objects are **immutable inputs** for UI display.
User-modifiable state exists **only** inside ViewModels.

### **1.4 Accessibility**

UI must follow:

- Clear contrasts
- Font scaling support
- Keyboard navigation for all workflows
- Minimal cognitive load

---

## 2. High-Level UX Goals

### **2.1 Intuitive Operations**

Users must be able to:

- Select water source
- Enter measured water chemistry
- Select equipment used
- Select each reagent and dose
- View expected outcomes
- Apply adjustments
- Export logs

All without interacting with internal concepts such as config structure or domain models.

### **2.2 Progressive Disclosure**

Show simple → expand to reveal complexity:

- Beginner: high-level actions only
- Advanced: optional detail panes (nutrients breakdown, EC computation, reagent residue, etc.)

### **2.3 Real-Time Feedback**

Whenever any input changes:

- UI requests recomputation from the engine
- Engine returns recalculated:
  - EC
  - Residual alkalinity
  - Nutrient profile
  - Dosing recommendations
  - Hazard/safety warnings

---

## 3. UI Architecture

### 3.1 Project Structure

The GUI project (`WaterChem.GUI`) will contain:

```
Views/
  MainWindow.xaml
  WaterSourceView.xaml
  ReagentSelectionView.xaml
  DoseCalculatorView.xaml
  EquipmentView.xaml
  ResultsView.xaml

ViewModels/
  MainWindowViewModel.cs
  WaterSourceViewModel.cs
  ReagentSelectionViewModel.cs
  DoseCalculatorViewModel.cs
  EquipmentViewModel.cs
  ResultsViewModel.cs

Converters/
  UnitDisplayConverter.cs
  MeasurementFormatter.cs

Services/
  DialogService.cs
  NavigationService.cs
  UiConfigLoader.cs
```

---

## 4. Data Flow

### 4.1 Initialization

```
Load configs → Build Units → Build Reagents → Build Equipment → Build Plants → Build Water Sources → Initialize ViewModels
```

### 4.2 Primary UI Loop

```
User Input → ViewModel State Change → Engine.Compute() → Updated Results → UI Refresh
```

### 4.3 Immutable Boundaries

- Domain objects = never changed by user
- ViewModel = transformation + UI state
- Engine = computation & simulation

---

## 5. Navigation Flow (User Journey)

### **5.1 Home / Main Window**

Options:

- Enter Water Chemistry
- Select Reagents
- Select Equipment
- Run Calculation
- Review Results
- Export Log

### **5.2 Water Source Selection**

- Choose predefined profile OR
- Manual entry
- Optional baseline import from water_sources.json

### **5.3 Reagent Selection**

- Multi-select basis
- Each reagent loads:
  - Metadata
  - Targets
  - Calculation profile
  - Safety constraints

### **5.4 Dose Calculation Screen**

- Real-time updates as user enters:
  - tank/volume size
  - desired targets
  - measured water chemistry
- Engine results displayed live

### **5.5 Results Screen**

Shows:

- Recommended dose per reagent
- Nutrient contribution
- EC change
- pH shift
- Residue warnings
- Safety flags
- Export buttons

---

## 6. Styling & Design

### 6.1 Visual Identity

- Clean minimalistic WPF design
- Light/dark mode optional
- Icon set from project assets
- No skeuomorphism; strictly functional

### 6.2 Layout Rules

- StackPanels for vertical sequences
- Grids for structured forms
- Tabbed navigation for subpages
- Collapsible advanced sections

### 6.3 Error Handling

UI surface must never throw exceptions:

- All input validated at VM level
- Error states displayed inline
- Fatal errors → show dialog with recovery steps

---

## 7. Integration Contract With Engine

The UI must call exactly one exposed method for computations:

```
CalculationResult Compute(WaterInput input);
```

Engine returns a deterministic, complete snapshot of all resulting state.
UI does not perform partial calculations.

---

## 8. Long-Term UI Extensions

This spec allows easy future expansions:

- Multi-plant scheduling
- Batch mixing automation
- Bluetooth-connected equipment
- Cloud sync / user profiles
- Mobile companion app
- Visualization dashboards

Nothing in this file restricts these future paths.

---

# End of File
