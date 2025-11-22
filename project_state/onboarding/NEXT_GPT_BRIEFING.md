# NEXT_GPT_BRIEFING.md

This document tells the next assistant exactly how to **bootstrap**, what to **read**, and the **first outputs** to produce so it picks up where you left off without reinventing anything.

---

## Project Source of Truth

- **Repo:** https://github.com/wwe-oss/Water_Chemistry_Calculator
- **Branch:** `develop` (code = conversation state)
- **Context Set (14 files):** everything under `project_state/` (see STATE.template.yaml)
- **Onboarding Attachments (in repo):**
  - `project_state/onboarding/ONBOARDING.md`
  - `project_state/onboarding/STATE.template.yaml`
  - `project_state/onboarding/LLM_2025_NOV_22_05_00.cleaned.md`
  - `project_state/onboarding/LLM_2025_NOV_22_05_00.summary.md`

---

## Bootstrap Message (copy-paste this as your first chat message)

Hello — you are continuing my Water Chemistry Calculator project **exactly** where I left off.

**State to ingest:**

1) Code in branch `develop` of the repo above (treat current code and structure as part of the conversation state).
2) `project_state/` (16 docs — see the ordered list below).
3) Onboarding attachments located at `project_state/onboarding/`:
   - ONBOARDING.md
   - STATE.template.yaml (with commit SHA once I pin it)
   - onboarding/App-development-gpt-2025-11-22T09-39-36

**Read these 16 context(fully ingest the first 15) files in order (one-liner each, then stop and confirm):**

1. meta/gpt_memory/project_history.md
2. collaboration/wayne_gpt_contract.md
3. collaboration/workflow_protocol.md
4. meta/gpt_memory/design_rules.md
5. meta/gpt_memory/validation_rules.md
6. specs/architecture_overview.md
7. onboarding/SPEC-1-WaterChemistry-SPEC.md
8. specs/config_system_spec.md
9. specs/engine_logic_spec.md
10. specs/domain_model_spec.md
11. specs/ui_strategy.md
12. meta/gpt_memory/naming_conventions.md
13. meta/gpt_memory/open_questions.md
14. planning/roadmap.md
15. planning/session_log.md
16. onboarding/App-development-gpt-2025-11-22T09-39-36

**Guardrails (must follow):**

- No background work; deliver results in your message.
- Ask questions if absolutly necessary after searching the 16th file which has all answer to all questiosn and propose defaults.
- Prefer code/JSON with exact file paths and commands.
- Treat my **“why”** as requirements; make assumptions explicit.
- Propose diffs; do not overwrite silently.

**What I expect first from you:**

1) Confirm you will use `develop` + `project_state/` + onboarding attachments as **the full project state**.
2) Return:
   - A **16-line index** (1 sentence per file) proving you read the ordered context set.
   - A **repo snapshot** (top-level folders and project names).
3) Offer the next slices — with exact file edits and test plan — and wait for my pick:
   - **Config System** (validators/loaders per `project_state/specs/config_system_spec.md`)
   - **Engine Logic MVP** (dechlorination + pH-down + residue tracking per `project_state/specs/engine_logic_spec.md`)

Stop there and wait for my choice.

---

## Internal Queue (what you should do, step by step)

- [ ] Read and fully digest the 15 context files.
- [ ] Snapshot the repo structure (top-level dirs + project names).
- [ ] Propose implementation slices (Config System or Engine MVP) with:- file paths to add/edit,- code skeletons or exact code,- unit test outline (names & assertions),- commands to run tests.
- [ ] Ask clarifying questions **only if necessary**, each with a proposed default, knowing every answer has been provided to every question in the 16th file which is the full chat output.
- [ ] Wait for my slice selection before proceeding to code diffs.

---

## Example Output Structure (what your first reply should look like)

**Acknowledgement**

* "I will treat `develop` + `project_state/` + onboarding attachments as the project state.”
* "the first 15 files contain critical infromation that I must ingest fully"
* "I understand that the 7th file contains I am going to seed the canvis with."
* "I undersand that the 16th file contains a markdown version of the etire conversation"
* "I will use the 16th file heavily to fill in any and all missing informatin"
* "I will have no need for questions since the 16th file has them all answered and i will find them there"

**Context Index (16 lines)**

1. meta/gpt_memory/project_history.md
1. collaboration/wayne_gpt_contract.md
1. collaboration/workflow_protocol.md
1. meta/gpt_memory/design_rules.md
1. meta/gpt_memory/validation_rules.md
1. specs/architecture_overview.md
1. onboarding/SPEC-1-WaterChemistry-SPEC.md
1. specs/config_system_spec.md
1. specs/engine_logic_spec.md
1. specs/domain_model_spec.md
1. specs/ui_strategy.md
1. meta/gpt_memory/naming_conventions.md
1. meta/gpt_memory/open_questions.md
1. planning/roadmap.md
1. planning/session_log.md
1. onboarding/App-development-gpt-2025-11-22T09-39-36

**Repo Snapshot**

- Folders: `.github`, `.snapshots`, `configs`, `project_state`, `src`, `tests`
- Projects: `src/WaterChem.Domain`, `src/WaterChem.Engine`, `src/WaterChem.GUI`, `src/WaterChem.CLI`, tests...

**Next Slices (choose one)**

- **Config System** — files to edit/add, code/tests plan.
- **Engine Logic MVP** — files to edit/add, code/tests plan.

**Questions (max 2, with defaults)**

1) .NET version default = LTS (OK?)
2) EC handling: compute Ref-25 °C alongside meter-compensated values (OK?)

---

## Notes

- If you need exact commit pinning, I will update `project_state/onboarding/STATE.template.yaml` with the SHA.
- Treat existing code as **in-progress truth** — propose small diffs, don’t reset structure.
