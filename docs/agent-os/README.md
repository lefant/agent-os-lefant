# Agent OS Docs Snapshot

This folder stores the local documentation mirror (HTML + summaries). For general repository guidance, see the top-level `README.md`.

## Snapshots & summaries
- `html/` stores verbatim exports from <https://buildermethods.com/agent-os> so we can diff upstream changes offline.
- `summaries/` holds our curated Markdown explanations for each topic, plus local-only additions such as the GitHub access Skill.
- `update-agent-os-docs.sh` (in this directory) re-fetches every HTML page listed below.

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
| GitHub access Skill | [summaries/github-access.md](summaries/github-access.md) | local-only |
| Whole-site markdown snapshot | [summaries/llms.md](summaries/llms.md) | local export |

## Updating the snapshots

Run:

```bash
docs/agent-os/update-agent-os-docs.sh
```

The script re-fetches every HTML page listed above and overwrites the copies in `docs/agent-os/html/`. Review the diffs, then adjust the Markdown summaries if upstream docs change.
