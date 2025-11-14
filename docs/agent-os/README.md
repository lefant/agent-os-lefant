# Agent OS Configuration Docs

This folder contains a local, self-contained snapshot of the Agent OS public documentation that matters for configuring agents inside this repo.

- `html/` keeps the raw HTML downloaded from buildermethods.com so you can audit upstream changes.
- `summaries/` holds hand-written Markdown breakdowns of each topic tailored to the workflows in this repository.
- `../../scripts/update-agent-os-docs.sh` refreshes the HTML snapshots (see script section below).

| Topic | Summary | Source HTML |
| --- | --- | --- |
| Overview & positioning | [summaries/overview.md](summaries/overview.md) | [html/agent-os.html](html/agent-os.html) |
| Installation | [summaries/installation.md](summaries/installation.md) | [html/installation.html](html/installation.html) |
| Configuration options | [summaries/configuration.md](summaries/configuration.md) | [html/modes.html](html/modes.html) |
| 3-layer context | [summaries/3-layer-context.md](summaries/3-layer-context.md) | [html/3-layer-context.html](html/3-layer-context.html) |
| Standards | [summaries/standards.md](summaries/standards.md) | [html/standards.html](html/standards.html) |
| Claude Code Skills | [summaries/skills.md](summaries/skills.md) | [html/skills.html](html/skills.html) |
| Profiles | [summaries/profiles.md](summaries/profiles.md) | [html/profiles.html](html/profiles.html) |
| Verification | [summaries/verification.md](summaries/verification.md) | [html/verification.html](html/verification.html) |
| Visual workflows | [summaries/visuals.md](summaries/visuals.md) | [html/visuals.html](html/visuals.html) |
| Workflow internals | [summaries/workflows.md](summaries/workflows.md) | [html/workflows.html](html/workflows.html) |

## Updating the snapshots

Run:

```bash
scripts/update-agent-os-docs.sh
```

The script re-fetches every HTML page listed above and overwrites the copies in `docs/agent-os/html/`. Review the diffs, then adjust the Markdown summaries if upstream docs change.
