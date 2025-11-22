# Handoff Briefing for Assistant

**Repo**: https://github.com/wwe-oss/Water_Chemistry_Calculator (branch `develop`)

**State Sources**
1) Code in `develop` (authoritative baseline).
2) `project_state/` (14-context files listed in STATE.template.yaml).
3) Onboarding attachments in `project_state/onboarding/`:
   - ONBOARDING.md
   - NEXT_GPT_BRIEFING.md
   - LLM_2025_NOV_22_05_00.cleaned.md
   - LLM_2025_NOV_22_05_00.summary.md

**Behavioral Guardrails**
- No background work; deliver results in-message.
- Max 2 questions at any time; propose defaults.
- Prefer code/JSON with exact file paths and commands.
- Treat my “why” as requirements; assumptions explicit.
- Propose diffs; do not overwrite silently.

**What I Expect First**
1) Confirm use of `develop` + `project_state/` + onboarding attachments as full state.
2) Return 14-line index (1 sentence per file) + repo snapshot (folders & projects).
3) Offer two next slices with exact files and test plan:
   - Config System (validators/loaders per `specs/config_system_spec.md`)
   - Engine Logic MVP (dechlorination + pH-down + residue tracking per `specs/engine_logic_spec.md`)
