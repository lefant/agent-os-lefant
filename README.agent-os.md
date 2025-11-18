# Agent OS Integration via ClaudeContainer

This document describes how [Agent OS](https://buildermethods.com/agent-os) - a standardized workflow system for AI-assisted development - is integrated into projects using ClaudeContainer.

## Source

These files are generated from the base installation at:
```
~/git/lefant/agent-os-lefant
```

## Installation/Update

To install or update Agent OS for this project, run:
```bash
./claudecontainer/scripts/agent-os_project-install.sh
```

This script:
- Mounts the base installation into the devcontainer
- Runs `project-install.sh` to compile standards, commands, and workflows
- Generates files in this directory and `.claude/`

## Why These Files Are Tracked

While these files are generated (similar to lock files), they are tracked in git for:
1. **Team convenience** - Immediate availability without running install
2. **Git backup** - History of standard changes over time
3. **CI/CD compatibility** - Works without additional setup
4. **Visibility** - See what changed between agent-os updates

## Generated Project Files

Agent OS generates the following files in each project:

```
<project-root>/
├── agent-os/
│   ├── config.yml          # Project configuration (regenerated)
│   ├── standards/          # Coding standards (regenerated)
│   ├── commands/           # Agent-OS commands (regenerated)
│   ├── specs/              # Feature specs (preserved during updates)
│   └── product/            # Product docs (preserved during updates)
└── .claude/
    ├── commands/agent-os/  # Claude Code slash commands
    ├── agents/agent-os/    # Claude Code subagents
    └── skills/             # Claude Code skills (standards)
```

**Note:** The `specs/` and `product/` directories are preserved during updates, while all other files are regenerated from the base installation.

## Configuration

Configuration is managed in the base installation at:
```
~/git/lefant/agent-os-lefant/config.yml
```

Current settings:
- Profile: `default`
- Claude Code commands: `true`
- Use Claude Code subagents: `true`
- Standards as Claude Code Skills: `true`
- Agent OS commands: `true`

## Documentation

- [Agent OS Installation Guide](https://buildermethods.com/agent-os/installation)
- [Agent OS Configuration](https://buildermethods.com/agent-os/modes)
