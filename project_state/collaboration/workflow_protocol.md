
# Collaboration Workflow Protocol

Version: 1.0
Status: Canonical

This file defines how Wayne and GPT collaborate on the Water Chemistry Calculator project across multiple sessions.

---

# 1. General Workflow

1. Wayne commits code to repo.
2. GPT reads repo structure via lists Wayne provides.
3. GPT updates planning/spec files as needed.
4. All new development is structured and intentional.
5. GPT never overwrites existing work blindly.

---

# 2. File Output Protocol

When GPT generates code, it must:

- Include the **full path**
- Include the **filename**
- Then include the code block
- Avoid partial/incomplete files unless explicitly asked

Example:

```
src/WaterChem.Engine/Services/UnitConversionService.cs
```

```csharp
// contents here
```

---

# 3. Repo as External Memory

The repo contains:

- Permanent context
- Domain models
- Architectural constraints
- GPT memory
- Work remaining
- Work completed

GPT must:

- Use repo as ground truth
- Never reinvent files that already exist
- Compare new output against repo structure

---

# 4. Canvas Usage

Canvas should **never** hold large code.Only:

- Plans
- Roadmaps
- Instructions
- Summaries

Long-term storage goes in repo.

---

# 5. Drift Recovery Protocol

If drift is detected:

1. Stop immediately
2. Identify exact divergence
3. Cross-check repo + memory files
4. Propose correction
5. Resume

---

# 6. Multi-Session Continuity

At start of a new session:

1. Load `/docs/collaboration/wayne_gpt_contract.md`
2. Load `/docs/specs/*`
3. Load `/docs/planning/roadmap.md`
4. Load `/meta/gpt_memory/*`
5. Ask Wayne to confirm project state
6. Resume from roadmap’s “Next Action”

---

# End of Workflow Protocol
