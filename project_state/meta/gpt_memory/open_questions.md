
# Open Questions (Dynamic)

Version: 1.3
Purpose: Tracks unresolved design, architectural, behavioral, or domain-model questions that future GPT sessions must evaluate or request clarification on before proceeding.

---

## 1. Domain Modeling & Chemistry Logic

### 1.1 Reagents

- Do we require advanced dissolution models for magnesium, calcium, sulfates, bicarbonates, and chelated nutrients?
- Should buffering agents (e.g., citric acid, phosphoric acid) use curve-based titration models rather than linear approximations?
- Should “supplements” (e.g., Cal-Mag solutions) be modeled as reagent composites with predefined stoichiometric breakdowns?
- Do we need explicit modeling for residue interactions that accumulate across multiple dosing events?

### 1.2 Water Sources

- Should seasonal water-source variability become its own first-class domain entity?
- Should water sources support historical profiling and anomaly detection?
- Do we need a per-source “treatment profile” system (filters, aeration, UV, RO membranes)?

### 1.3 Plant Modeling

- Should plant cultivars allow parent-child inheritance modeling to simplify repeated trait definitions?
- Do we require environmental-response curves (light, humidity, temperature) for future expansion?
- Should growth-stage transitions support rule-based triggers (e.g., height, time, leaf count)?

---

## 2. Engine Logic & Calculation Flow

- Should the engine support reversible operations (undo/redo of applied reagents)?
- Do we need a per-step calculation trace with intermediate values preserved?
- Should calculations be memoized for identical inputs to increase performance?
- Do reagent interactions need a conflict-resolution priority system?

---

## 3. Configuration & Schema Questions

- Should each configuration file support versioning with enforced migrations?
- Should configs support environment-based overrides (dev/test/prod/local)?
- Do we need partial config updates or only full-file atomic replacements?
- Should users be able to define custom units of measure dynamically?

---

## 4. GUI/UX Questions

- Will the GUI require real-time recalculation feedback on slider/toggle changes?
- Should the GUI visualize reagent curves (titration, dilution, pH effect)?
- Should the GUI support “smart recommendations” (e.g., auto-dose suggestions)?
- Is a mobile-capable layout necessary in v1 or deferred?

---

## 5. Workflow & Operational Behavior

- Should the CLI and GUI share a unified action-logging layer?
- Should the engine run in a sandboxed mode to prevent irreversible operations?
- Do we require offline-first capability with queued state synchronization?

---

## 6. GPT Collaboration / Future Session Support

- Should GPT sessions automatically re-summarize project_state after major changes?
- Do we need a “context checksum” GPT can verify to ensure alignment before continuing?
- Should the project adopt a strict rule requiring clarification whenever intent is ambiguous?

---

## 7. Long-Term Architectural Decisions

- Should the engine migrate to a plugin-based architecture for reagent modules?
- Is multi-target output planned (APIs, mobile, web, services)?
- Should we support future integration with sensor hardware?

---

## 8. Outstanding Clarifications from Wayne

1. Confirm long-term direction for full chemistry modeling (linear vs. nonlinear).
2. Confirm which models must be precise vs. approximated for v1.
3. Confirm whether real plant-biology simulation is desired beyond nutrient uptake basics.
4. Confirm boundaries where GPT can be autonomous vs. requiring explicit instruction.
5. Confirm whether future GPT sessions may refactor for elegance when preserving intent.

---

## 9. Meta-Level Open Questions

- Should project_state include a machine-readable dependency graph?
- Should spec files include expiration dates requiring refresh?
- Should GPT enforce stricter naming conventions or remain flexible?

---

## 10. Items Waiting on Next GPT Session Before Closure

- Formalize reagent interaction table.
- Formalize water-quality adjustment pipeline.
- Finalize plant growth-stage transitions and rules.
- Confirm UI layout strategy for multi-step workflows.
