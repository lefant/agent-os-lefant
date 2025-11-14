# Claude Code Skills Integration

Source: `docs/agent-os/html/skills.html`

## Purpose
Convert every standard into an intelligent Claude Code Skill so Claude can auto-apply the right rules without loading dozens of markdown files into context.

## Prerequisites
- `claude_code_commands: true`
- `standards_as_claude_code_skills: true` (default in Agent OS 2.1+)
- Confirm in `~/agent-os/config.yml` defaults or override via installer flags.

## How it works
1. During project installation, standards are compiled into `.claude/skills/*.md`.
2. Command + workflow files omit explicit `@agent-os/standards/...` references.
3. Claude evaluates each Skill’s description to decide when to activate it.
4. Skills live alongside slash commands, so this path is Claude-only (Cursor, Codex, etc. still rely on explicit references).

## Skills vs. injected standards
| Approach | Pros | Cons |
| --- | --- | --- |
| Claude Skills | Lower token usage, only relevant rules load, cleaner instructions. | Cannot force-read specific files; depends on Claude’s judgment; Claude Code only. |
| Injected standards | Guaranteed that referenced files are read; works in every tool. | Higher token costs; noisy prompts; less selective. |

## Improving Skills (`/improve-skills`)
- Run after the first install, after adding new standards, or whenever Skills fail to trigger.
- Command analyzes each Skill, rewrites descriptions, adds metadata, and increases “triggerability.”
- Safe to re-run; edits `.claude/skills/` in-place, so commit changes you want to keep.

## Trigger behavior
- No explicit invocation syntax; Claude activates Skills based on:
  - Description keywords + metadata
  - Task context (e.g., file types, commands asked)
  - Patterns detected in prompts/requests
- If a Skill isn’t firing, either strengthen the description manually or re-run `/improve-skills`.

## Operational tips
- Keep standards tightly scoped so each Skill maps to a single concern.
- Mention frameworks, languages, and “should/should not” cues inside the Skill description to raise relevance.
- For mixed-tool environments, consider dual setup: leave Skills on for Claude but also keep `agent_os_commands: true` so other tools still access traditional references.
