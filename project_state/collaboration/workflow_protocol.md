
# Collaboration Workflow Protocol

Version: 1.1
Status: Canonical & Complete

This protocol defines exactly how Wayne and GPT collaborate across sessions and across instances (new chats, new models, resumed sessions).
It is the authoritative continuity contract for the Water Chemistry Calculator project.

---

# 1. Purpose of This Protocol

This document exists to eliminate:

- Drift
- Repetition
- Loss of context
- Conflicting assumptions
- GPT deviation from Wayne’s intent
- Overwriting or re-inventing completed work
- Session resets that destroy project continuity

It defines *how* development proceeds, *how* new GPT sessions restore state, and *how* decisions persist across time.

---

# 2. Collaboration Principles

## 2.1 Wayne’s Intent Comes First

GPT must preserve Wayne’s intent above all else:

- Freedom of architectural evolution
- No rigidity
- No locking Wayne into constraints
- No assumption of “only one right way”
- GPT adapts to Wayne, not vice versa

## 2.2 Repo = The Single Source of Truth

The repository provides:

- Permanent context
- Existing code
- Completed work
- Naming conventions
- Architectural conventions
- GPT persistent “external memory”

GPT must always reference the repo before generating new work.

GPT must **NEVER** assume a file is missing, outdated, or wrong without confirming against the repo.

---

# 3. File Output Rules

When GPT outputs a file:

1. Output **only the file content**, nothing else
2. Include the **full relative path** on a line by itself
3. Then a fenced code block with the content
4. No explanations, no commentary

Example:

```
src/WaterChem.Engine/Services/WaterBalanceService.cs
```

```csharp
// code…
```

No additional text is permitted unless Wayne explicitly requests it.

---

# 4. Session Continuity & Recovery

Because GPT sessions do not retain long-term memory, every new session must:

## 4.1 Load These Files First

These must be loaded, in this order:

1. `/project_state/collaboration/wayne_gpt_contract.md`
2. `/project_state/collaboration/workflow_protocol.md` (this file)
3. `/project_state/specs/architecture_overview.md`
4. `/project_state/specs/domain_model_spec.md`
5. `/project_state/specs/engine_logic_spec.md`
6. `/project_state/specs/config_system_spec.md`
7. `/project_state/specs/ui_strategy.md`
8. `/project_state/planning/roadmap.md`
9. `/project_state/planning/session_log.md`
10. `/project_state/meta/gpt_memory/*`

This restores the full context without using canvas memory.
Canvas is treated as **temporary working space only**.

## 4.2 Confirm Project State

Before acting, GPT must:

- Ask Wayne to confirm the current task
- Load the relevant file(s)
- Reconstruct context from the repo only

No assumptions are allowed.

---

# 5. Drift Detection & Correction

If GPT detects ANY of the following:

- Conflicting instructions
- File content mismatch
- Naming inconsistencies
- Architecture deviation
- Loss of intent
- “I think we were doing X” without ground truth

GPT must:

1. **STOP**
2. State the precise detected drift
3. Identify the contradicting source(s)
4. Request Wayne’s confirmation
5. Apply the correction
6. Resume ONLY after alignment

---

# 6. Work Cycle Per File (Critical)

For all tasks involving files:

1. Wayne provides the file (via repo or upload)
2. GPT merges missing content
3. GPT outputs **only** the merged file
4. Wayne pastes it back into the repo
5. This process repeats file-by-file

GPT must never:

- Invent missing content without basis
- Add new sections unless required to restore continuity
- Change tone, naming, or meaning
- Regenerate the entire file if only a section needs updating

---

# 7. No Canvas Overload

Canvas is used **only** for:

- Roadmaps
- Plans
- Summaries
- Multi-step workflows

Canvas is **never** used for:

- Code
- Specs
- Large documents
- Detailed state storage
- Anything intended for long-term persistence

All persistent context must reside **in the repo**.

---

# 8. Development Pipeline

1. Wayne triggers a task
2. GPT loads all relevant repo files
3. GPT requests any missing ones
4. GPT produces the output following File Output Rules
5. Wayne integrates into repo
6. GPT updates roadmap if needed
7. Next task begins

Only one file is processed at a time.
No multitasking.
No jump-ahead reasoning.

---

# 9. When GPT Must Decline

GPT must refuse to proceed when:

- A requested file isn’t available
- Context is incomplete
- The task contradicts repo specifications
- Wayne’s instructions conflict internally
- A file appears to be outdated but not verified

GPT must stop and request clarification.

---

# 10. Guarantee of Non-Failure

This protocol binds all future GPT sessions:

- If context is heavy → GPT relies on repo
- If instructions are unclear → GPT asks
- If drift appears → GPT corrects
- If repo differs → GPT assumes repo is correct

This prevents catastrophic failure of long-running work.

---

# 11. End of Workflow Protocol

This file is canonical.
It must never be changed except by explicit request from Wayne.
