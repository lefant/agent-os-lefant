# Installation Guide (Operational Notes)

Source: `docs/agent-os/html/installation.html`

## Two-stage install
1. **Base install (once per workstation)**
   - Run `curl -sSL https://raw.githubusercontent.com/buildermethods/agent-os/main/scripts/base-install.sh | bash`.
   - Creates `~/agent-os` containing default profile, standards, workflows, agents, scripts.
   - Windows: run via WSL or Git Bash so the script has a POSIX shell.
   - Updating existing installs runs the same script; it offers backup + update prompts.
2. **Project install (per repository)**
   - `cd /path/to/project && ~/agent-os/scripts/project-install.sh`.
   - Pulls defaults from `~/agent-os/config.yml` then compiles the selected profile into the repo (`agent-os/`, `.claude/` when enabled).

## Pre-install customization
- Clone/edit standards before project installs so every repo inherits the right rules.
- Best practice: create a custom profile that `inherits_from: default` instead of editing `default` directly; keeps updates painless.
- If Claude Skills are enabled (`standards_as_claude_code_skills: true`), run `/improve-skills` after changing standards so descriptions stay optimized.

## What the project installer generates
- `agent-os/` – compiled standards + workflows tied to the active profile.
- `.claude/commands/` – only when `claude_code_commands: true`.
- `.claude/skills/` – when Claude Skills conversion is on.
- Uses `agent-os/config.yml` for spec + roadmap scaffolding, `agent-os/specs/...` for per-feature artifacts.

## Default config block (base install)
```yaml
defaults:
  profile: default
  claude_code_commands: true
  use_claude_code_subagents: true
  agent_os_commands: false
  standards_as_claude_code_skills: true
```

## Installer flags
| Flag | Purpose |
| --- | --- |
| `--profile <name>` | Compile from a different profile (e.g. `nextjs`, `rails-api`). |
| `--claude-code-commands true|false` | Emit Claude Code slash commands. |
| `--use-claude-code-subagents true|false` | Allow slash commands to spawn orchestrated subagents. |
| `--agent-os-commands true|false` | Generate generic prompt commands for other IDE agents. |
| `--standards-as-claude-code-skills true|false` | Convert standards into Claude Skills vs traditional injection. |
| `--dry-run` | Preview files without writing. |
| `--verbose` | Show detailed logging. |

## Example command patterns
- Alternate profile: `~/agent-os/scripts/project-install.sh --profile nextjs`
- Claude commands w/ subagents: `... --claude-code-commands true --use-claude-code-subagents true`
- Claude commands without delegation: `... --claude-code-commands true --use-claude-code-subagents false`
- Prompt-pack only (Cursor et al.): `... --agent-os-commands true`
- Force Skills generation: `... --claude-code-commands true --standards-as-claude-code-skills true`
- Safety check: `... --dry-run`

## Post-install checklist (per repo)
1. Verify `agent-os/config.yml` points at the right profile + defaults.
2. Keep `agent-os/specs/` under version control so spec + implementation history travel together.
3. Re-run the installer whenever the base profile updates; the script detects existing installs and guides through updates.
