# Verification

Source: `docs/agent-os/html/verification.html`

## Purpose
Automate the final “did we really finish?” checklist at the end of implementation/orchestration workflows so features ship with evidence.

## What gets checked
- **Task completion** – Ensures every task in `agent-os/specs/<spec>/tasks.md` is checked off.
- **Tests** – Confirms the suite tied to the spec passed (look for logged output + exit codes).
- **Standards alignment** – Agents confirm the code follows the active standards/skills bundle.
- **Roadmap sync** – Product roadmap (`agent-os/product/roadmap.md`) is updated to reflect delivered work.

## When it runs
- Automatically triggered at the end of both `implement-tasks` and `orchestrate-tasks`.
- Outputs a markdown report at `agent-os/specs/<spec>/verification/final-verification.md`.

## How to use in this repo
1. Keep specs self-contained so verification has traceable artifacts (requirements, tasks, visuals).
2. Treat the generated report as part of the PR evidence; reviewers can diff it alongside code.
3. If verification flags missing tasks/tests, either fix the implementation or intentionally document waivers inside the report.

## Extensions
- Pair with Playwright MCP (see [visuals](visuals.md)) for UI screenshot comparisons.
- Customize verification workflows in your profile if your team needs extra steps (e.g., security scans, performance tests).
