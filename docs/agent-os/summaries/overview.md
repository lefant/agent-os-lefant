# Agent OS Overview

## What it is
- Spec-driven operating system for AI coding agents; replaces ad-hoc prompting with executable standards + workflows.
- Ships with end-to-end workflow covering six phases: plan product, shape spec, write spec, create tasks, implement tasks, orchestrate tasks.
- Tool-agnostic: works with Claude Code (native commands + optional subagents) or any IDE/agent via sequential prompts.

## Why it matters for this repo
- Establishes shared vocabulary (standards, product context, specs) that every contributor and agent instance should load before touching code.
- Provides a consistent location (`agent-os/`) for specs, standards, visuals, and task definitions used by local automations.
- Built to keep teams from re-prompting the same expectations—essential for multi-contributor repositories like this one.

## Key concepts to internalize
1. **3-layer context** – Standards (how), Product (why), Specs (what’s next). Each layer is injected at different workflow steps.
2. **Workflows** – Modular instruction blocks; same steps drive both Claude commands and non-Claude prompts.
3. **Multi-tool support** – Claude Code gets slash-command interface; other tools reuse the command markdown directly.

## Getting started quickly
1. Run the base install script to copy Agent OS into `~/agent-os`.
2. Customize or extend the default profile before installing into projects (standards, workflows, agents).
3. Run the project installer inside each repo to compile standards/workflows + optionally Claude command files.
4. Follow the six-phase workflow per feature to keep specs, tasks, and verification synchronized.

## References
- Full marketing page: `docs/agent-os/html/agent-os.html`
- Connects directly to summaries: [3-layer context](3-layer-context.md), [workflows](workflows.md), [standards](standards.md).
