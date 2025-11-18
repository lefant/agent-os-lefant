# ClaudeContainer

Shared Docker, devcontainer, and Claude Code configuration for consistent development environments across projects. For a broader introduction, check out the [Advanced Context Engineering for Coding Agents talk](https://www.youtube.com/watch?v=IS_y40zY-hc) and the companion [ACE Framework for Coding Agents guide](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents/blob/main/ace-fca.md). Command catalog lives in the [HumanLayer Claude commands reference](https://github.com/humanlayer/humanlayer/tree/main/.claude).

## RPI Workflow

This configuration uses the **RPI** (Research, Plan, Implement) workflow for structured development:

- **Research** (`/research_codebase`): Explore and document the current state
- **Plan** (`/create_plan`): Design the implementation strategy
- **Implement** (`/implement_plan`): Execute the plan with verification

Agents and commands are organized under `.claude/agents/rpi/` and `.claude/commands/rpi/` to make this workflow explicit.

## Quick Start

### For New Projects

Add this repository as a git subtree:

```bash
git subtree add --prefix .claude git@github.com:lefant/claudecontainer.git master --squash
```

Or use the bootstrap script:

```bash
./.claude/claudecontainer/scripts/bootstrap-project.sh
```

### Global Configuration

Create `~/.env.claudecontainer` with your settings:

```bash
CLAUDECONTAINER_PATH=./.claude
TZ=Europe/Stockholm
```

The bootstrap script creates this automatically if it doesn't exist.

## Structure

1. **`.claude/`** - This repo as git subtree
   - Shared configuration (agents, commands, settings.json)
   - Infrastructure in `claudecontainer/` subdirectory
2. **`compose.yaml`** - Minimal project compose file:
   ```yaml
   name: your-project

   env_file:
     - ~/.env.claudecontainer

   include:
     - ./.claude/claudecontainer/compose.shared.yaml
   ```
3. **`claudecontainer-user-dot-claude/`** - User home .claude directory (gitignored)
4. **`.devcontainer/devcontainer.json`** - VS Code integration

## Updating

Pull latest changes from this repo:
```bash
git subtree pull --prefix .claude git@github.com:lefant/claudecontainer.git master --squash
```

Push changes back (if you're a contributor):
```bash
git subtree push --prefix .claude git@github.com:lefant/claudecontainer.git master
```

## Usage

```bash
# Build the devcontainer
docker compose build devcontainer

# Run Claude Code
docker compose run --rm claude

# Or open in VS Code
code .
# Then: Dev Containers: Reopen in Container
```
