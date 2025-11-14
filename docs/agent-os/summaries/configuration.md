# Configuration Options (“Modes”)

Source: `docs/agent-os/html/modes.html`

Agent OS no longer uses rigid “modes.” Instead it exposes four booleans in `~/agent-os/config.yml` (overridable via installer flags) so you can mix and match behaviors across tools.

## Core toggles
| Setting | Default | What it controls | When to enable |
| --- | --- | --- | --- |
| `claude_code_commands` | `true` | Generates Claude Code slash commands (`/shape-spec`, `/create-tasks`, etc.). | Working primarily inside Claude Code. |
| `use_claude_code_subagents` | `true` | Lets slash commands delegate to specialized subagents for orchestration. | You want autonomous, multi-step execution and accept higher token usage. |
| `agent_os_commands` | `false` | Compiles prompt commands into `agent-os/commands/` for sequential use in Cursor, Codex, Gemini, Windsurf, etc. | You rely on non-Claude tools or want copy/paste prompts. |
| `standards_as_claude_code_skills` | `true` | Converts standards into Claude Code Skills instead of inline references. | You want Claude to auto-apply the right standards with better context efficiency. (Requires `claude_code_commands: true`.) |

## Common recipes
- **Claude Code w/ subagents (default)**  
  ```
  claude_code_commands: true
  use_claude_code_subagents: true
  standards_as_claude_code_skills: true
  agent_os_commands: false
  ```
- **Claude Code without delegation** – keep slash commands but run steps inline: same as above with `use_claude_code_subagents: false`.
- **Other IDE agents only** – disable Claude commands, enable prompt packs:  
  ```
  claude_code_commands: false
  use_claude_code_subagents: false
  standards_as_claude_code_skills: true
  agent_os_commands: true
  ```
- **Dual setup** – ship both Claude commands and portable prompts: set every flag to `true`.

## Operational guidance
1. Set defaults once in `~/agent-os/config.yml`; store team-specific combos under version control.
2. Override per-project during `project-install.sh` runs via flags as needed (see [installation](installation.md)).
3. Remember dependencies: subagents + Skills only matter when Claude commands are on.
4. Keep non-Claude tools in sync by committing the generated `agent-os/commands/` folder; tools reference prompts via `@agent-os/...`.

## Goals behind the toggles
- **Flexibility** – adapt to mixed stacks or multiple editors without editing workflows.
- **Tool agnosticism** – same spec + standards pipeline works for Claude, Cursor, Codex, etc.
- **Subagent control** – choose between transparency (no delegation) vs. autonomous orchestration.
- **Standards delivery** – pick between Claude Skills (intelligent, token-light) and explicit references (predictable, works everywhere).
