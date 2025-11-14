# Workflows (Modular Instruction Blocks)

Source: `docs/agent-os/html/workflows.html`

## Definition
- Reusable markdown snippets living under `~/agent-os/profiles/<profile>/workflows/`.
- Injected into commands, custom subagents, and orchestration logic to guarantee every tool follows the same steps.
- Most users rely on the defaults; customize only when you understand the injection + compilation pipeline.

## Directory structure (default profile)
```
workflows/
├── planning/
│   ├── research-feature.md
│   └── plan-roadmap.md
├── specification/
│   ├── write-spec.md
│   └── analyze-requirements.md
├── implementation/
│   └── implement-tasks.md
└── verification/
    └── verify-implementation.md
```

## Injection syntax
- Workflows: `{{workflows/specification/write-spec}}` → replaced with file contents during project install.
- Standards (for comparison): `{{standards/global/*}}` → replaced with `@agent-os/...` references (or Skills if enabled).
- Wildcards `*` pull entire folders; omit to target a specific file (without `.md` extension).

## Conditional compilation tags
- `{{IF use_claude_code_subagents}} ... {{ENDIF}}` – includes blocks only when the flag is `true`.
- `{{UNLESS standards_as_claude_code_skills}} ... {{ENDUNLESS}}` – includes blocks when Skills are off.
- Keeps generated instructions aligned with active config toggles (see [configuration](configuration.md)).

## Customization playbook
1. **Audit existing injection points** – search for `{{workflows/` inside your profile to see where a workflow feeds commands.
2. **Override via inheritance** – copy an existing workflow into your custom profile path and edit; your version replaces the parent.
3. **Create new workflows** – drop markdown into `workflows/<category>/<name>.md` then reference via `{{workflows/...}}` or inside custom subagents.
4. **Test** – rerun `project-install.sh` (with `--dry-run` first if desired) to inspect compiled instructions.

## When to customize
- Need project-specific steps (deployments, audit trails, compliance checks).
- Want different phrasing or detail level for certain teams/agents.
- Desire unique workflows for orchestrated agents vs. manual commands.

## Tooling tips
- Use `grep -r "{{workflows/implementation/verify" ~/agent-os/profiles/<profile>` to check every consumer before editing verification steps.
- Pair workflow tweaks with standards + profile changes in the same branch to keep behaviors consistent.
