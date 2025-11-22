
# Project Roadmap

Version: 1.0
Status: Canonical

This is the *master continuity file* for the Water Chemistry Calculator.

---

# 1. Completed Work

✔ Architecture chosen
✔ Config system schemas created
✔ Domain models (most) generated
✔ Engine logic specification complete
✔ Repo cleaned & stabilized
✔ Branches merged into `develop`
✔ Project structure validated
✔ Persistent context system designed

---

# 2. Current Focus Point

**Stabilizing cross-session continuity by externalizing GPT memory into repo files.**

This includes:

- Collaboration contract
- Workflow protocol
- Specs
- GPT memory files

---

# 3. Next Major Milestones

### 3.1 Complete Domain Model Code

Status: ~70%Remaining:

- Units domain full code
- WaterSources domain full code
- Cross-validation helpers

### 3.2 Implement Config Load Pipeline

Status: not startedIncludes:

- Schema validation
- JSON/YAML parsing
- Domain mapping
- Unit normalization

### 3.3 Engine Implementation

Status: not startedComponents:

- Unit conversion engine
- Dosing engine
- Residue impact calculator
- Safety validator
- CalculationTrace builder

### 3.4 GUI Development

Status: not startedIncludes:

- Water source editor
- Reagent editor
- Parameter dashboard
- Adjustment calculator screen

### 3.5 CLI Development

Status: minimalAdd:

- Config load
- Run calculation
- Output trace

---

# 4. Next Action for GPT (always the next boot point)

```
Continue generating the persistent memory files in meta/gpt_memory,  
then begin the Unit Domain full code definitions.
```

---

# 5. Open Questions

(These will be populated dynamically)

---

# End of Roadmap
