# Onboarding (Read First)

State = code in `develop` + `project_state/` context + attached canvas/chat exports.

## Order of Reading (confirm one-liners before proceeding)
1) meta/gpt_memory/project_history.md
2) collaboration/wayne_gpt_contract.md
3) collaboration/workflow_protocol.md
4) meta/gpt_memory/design_rules.md
5) meta/gpt_memory/validation_rules.md
6) specs/architecture_overview.md
7) specs/config_system_spec.md
8) specs/engine_logic_spec.md
9) specs/domain_model_spec.md
10) specs/ui_strategy.md
11) meta/gpt_memory/naming_conventions.md
12) meta/gpt_memory/open_questions.md
13) planning/roadmap.md
14) planning/session_log.md

## Rules
- Treat `develop` branch code as **conversation state**.
- Max 2 questions; propose defaults.
- No background work; deliver in-message.
- Prefer code/JSON + exact file paths & commands.
- Changes are proposed as diffs; never silently overwrite.

## First Deliverable
1) 14-line context index + repo snapshot (folders/projects).
2) Propose next slice (Config System or Engine Logic MVP) with exact file edits and tests.
