
# Water Chemistry Calculator — Architecture Overview

Version: 1.0
Status: Canonical
Owner: Wayne + GPT (cross-session persistent specification)

---

# 1. Purpose

This document defines the **complete canonical architecture** for the Water Chemistry Calculator.

Its role:

- Provide stable architectural intent across all future GPT sessions.
- Act as the authoritative “north star” for design decisions.
- Ensure coherence between Domain, Engine, CLI, GUI, configs, and tests.
- Prevent drift, inconsistency, or unintentional re-architecting.
- Explicitly encode Wayne’s intent regarding flexibility and non-rigidity.

This file must remain consistent with:

- `domain_model_spec.md`
- `engine_logic_spec.md`
- `ui_strategy.md`
- `config_system_spec.md`
- `meta/gpt_memory/*`

---

# 2. High-Level Solution Structure

The solution contains **four primary application projects** and **two test assemblies**:
