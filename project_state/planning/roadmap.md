
# Project Roadmap

Version: 1.1
Status: Canonical / Continuity-Critical

This file is the **master continuity anchor** for the Water Chemistry Calculator project.
It allows any future GPT instance to immediately recover project context, current state,
milestones, constraints, next actions, and remaining work — *without relying on canvas memory*.

---

# 1. Completed Work

✔ Core architectural model chosen
✔ Full project directory structure stabilized
✔ All config schemas created
✔ Domain models drafted (70% complete)
✔ Engine logic specification produced
✔ GUI strategy defined
✔ CLI entry-points drafted
✔ Persistent memory system designed
✔ `project_state` directory established
✔ GPT memory folder created (`meta/gpt_memory/`)
✔ All collaboration & workflow files created
✔ Session log system operational
✔ Feature branches merged → `develop` branch stable
✔ Config system spec aligned with domain

---

# 2. Current Focus Point

### **Stabilization of cross-session continuity**

Goal:
Ensure *any* new GPT session can load the repo and reconstruct the exact working state with **no loss of intent**.

Current tasks under this focus:

- Expand each memory file with all critical missing context
- Merge missing details from specs, canvas output, and earlier design discussion
- Correct inconsistencies between schemas and domain-model definitions
- Ensure roadmap, contract, workflow, and specs are all coherent
- Prepare for domain-model completion and engine implementation

---

# 3. Major Milestones

## 3.1 Domain Model Completion

**Status:** ~70% complete**Remaining:**

- Units domain full implementation
- WaterSources full implementation
- Cross-validation helpers
- Domain-level invariants
- Add complete XML docstrings

---

## 3.2 Config Load Pipeline (High Priority)

**Status:** Not StartedIncludes:

- JSON/YAML parsing
- Schema validation
- Construction of full domain graph
- Unit normalization recalc
- Error reporting & recovery
- Tight integration with Engine initialization

---

## 3.3 Engine Implementation

**Status:** Not StartedCore Components Required:

- Unit Conversion Engine
- Reagent Dose Calculation Engine
- Residue Interaction Logic
- Safety Validator
- CalculationTrace builder (high-detail)
- Immutable log output (JSON + text)
- Environment-aware pH shifting logic
- Temperature-aware computations

---

## 3.4 GUI (WPF, MVVM Strict)

**Status:** UX spec completed**Remaining:**

- ViewModel definitions
- NavigationService
- Data-binding models
- Real-time display of engine results
- Input validation layer
- Basic error dialogs
- Results visualization

---

## 3.5 CLI Development

**Status:** Skeleton onlyNeeds:

- Config load
- Run engine
- Display results
- Export logs
- Optional JSON mode

---

## 3.6 Testing Infrastructure

**Status:** MinimalMust add:

- Unit tests for each domain model
- Schema validation tests
- Engine math tests
- UI viewmodel tests using MVVM test harness
- Integration tests for config → domain → engine → result

---

# 4. Intent Preservation (Critical for Future GPT Sessions)

The project must remain:

- Config-driven
- Deterministic
- Extensible
- Rigid in boundaries (Domain/Engine/GUI/CLI separation)
- Free of drift
- Free of hardcoding
- Centered on *Wayne’s intent*:

### Wayne’s Intent (Summary)

- Max flexibility for future modifications
- Never block GPT with rigid rules
- System must be clean, logical, scalable
- Domain must stay pure
- Engine must stay reusable and testable
- UI must stay clean MVVM and never include logic
- GPT must always have freedom to propose better designs
- Repo is the **only** permanent memory

---

# 5. Next Action — GPT Boot Instructions

This section tells the **next GPT instance** EXACTLY where to resume work.

```
1. Load all files in project_state/* AND meta/gpt_memory/*
2. Verify no divergences between:
     - domain_model_spec.md
     - domain C# files in src/WaterChem.Domain
     - config_system_spec.md
     - actual config files in /configs

3. Expand any incomplete memory files with missing details.

4. THEN begin full implementation of the Units domain:
     - UnitCategory.cs
     - UnitDefinition.cs
     - ConversionFormula.cs
     - UnitsConfig.cs
     with:
         - constraints
         - invariants
         - validation helpers
         - XML docs

5. After Units domain, begin WaterSource domain.

6. Update tests accordingly.

7. Update roadmap.md after each phase.
```

---

# 6. Open Questions (carry forward)

1. Should engine API be formalized in a dedicated file? (`engine_interface.md`)
2. Should we generate WPF mockups/spec wireframes?
3. Should config normalization be strict or allow warnings?
4. Should multi-species nutrient interactions be deferred to v2?
5. Should the repository auto-version each state file?

---

# 7. Long-Term Extensions (v2+)

(Not required now but keep compatibility in mind)

- Multi-plant scheduling
- Batch-mixing automation
- Bluetooth meter integration
- Mobile companion app
- Cloud-syncing profiles
- Custom reagent calculators
- Tank-state simulation

---

# End of Roadmap
