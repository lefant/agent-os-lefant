# 3-Layer Context System

Source: `docs/agent-os/html/3-layer-context.html`

Agent OS splits all knowledge into three layers so agents receive the right guidance at the right moment.

## Layer 1 – Standards (“How we build”)
- Markdown files grouped by specialty (backend, frontend, database, testing, etc.).
- Live inside the base profile and are compiled into every project install.
- Applied either through explicit references or via Claude Code Skills (see [skills](skills.md)).
- Use profiles to maintain different standard sets per stack (Rails vs React vs mobile).

## Layer 2 – Product (“What & why”)
- Captures mission, target users, differentiators, roadmap, and tech stack decisions.
- Stored per project under `agent-os/product/` with canonical docs:
  - `mission.md`
  - `roadmap.md`
  - `tech-stack.md`
- Created/updated via the `plan-product` command before shaping specs.
- Ensures agents understand the business rationale before proposing solutions.

## Layer 3 – Specs (“What’s next”)
- Each spec documents the next feature in depth: requirements, visuals, references, tasks, verification criteria.
- Built through the `shape-spec` → `write-spec` → `create-tasks` phases.
- Includes research artifacts (Q&A, similar code references, visual assets) so implementation can proceed without re-prompting.

## How layers interplay during workflows
1. **Plan Product** – establishes Layer 2; standards (Layer 1) already defined globally.
2. **Shape/Write spec** – merges Layers 1 + 2 context into a concrete Layer 3 artifact.
3. **Implement/Orchestrate tasks** – Layer 1 standards guide code style; Layer 2/3 provide business + feature detail.
4. **Verification** – cross-checks implementation against specs (Layer 3) while ensuring standards (Layer 1) and roadmap (Layer 2) stay aligned.

## Practical tips for this repo
- Keep `agent-os/product/mission.md` fresh; outdated missions cause bad agent suggestions.
- Bundle visuals, mockups, and code references with each spec to improve Layer 3 fidelity (see [visuals](visuals.md)).
- Re-run `plan-product` when roadmap changes so tasks and verification reference the latest goals.
