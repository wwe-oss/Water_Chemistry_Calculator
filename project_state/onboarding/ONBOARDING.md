# Onboarding (Read First)

**Location:** This file lives at `project_state/onboarding/ONBOARDING.md`.

**State =** code in `develop` + `project_state/` context + attached onboarding files.

## Order of Reading (confirm one-liners before proceeding)

1) meta/gpt_memory/project_history.md
2) collaboration/wayne_gpt_contract.md
3) collaboration/workflow_protocol.md
4) meta/gpt_memory/design_rules.md
5) meta/gpt_memory/validation_rules.md
6) specs/architecture_overview.md
7) onboarding/SPEC-1-WaterChemistry-SPEC.md
8) specs/config_system_spec.md
9) specs/engine_logic_spec.md
10) specs/domain_model_spec.md
11) specs/ui_strategy.md
12) meta/gpt_memory/naming_conventions.md
13) meta/gpt_memory/open_questions.md
14) planning/roadmap.md
15) planning/session_log.md
16) onboarding/App-development-gpt-2025-11-22T09-39-36

## Rules

- Treat `develop` branch code as **conversation state**.
- No background work; deliver in-message.
- Prefer code/JSON + exact file paths & commands.
- Changes are proposed as diffs; never silently overwrite.
- Injest compltely the first 15 files
- the 16th file is the full conversation, for reference.

## First Deliverable

1) 16-line context index + repo snapshot (folders/projects).
2) Propose next slice (Config System or Engine Logic MVP) with exact file edits and tests.
