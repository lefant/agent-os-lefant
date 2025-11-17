#!/usr/bin/env bash
# Run Agent OS project installation with custom agent-os base directory
#
# This script runs the agent-os project-install.sh script inside the devcontainer
# with a custom mount point for the agent-os base installation.
#
# Default agent-os location: ~/git/lefant/agent-os-lefant
# Override with: AGENT_OS_BASE=/path/to/agent-os ./agent-os_project-install.sh

set -e

# Configuration
AGENT_OS_BASE="${AGENT_OS_BASE:-$HOME/git/lefant/agent-os-lefant}"
CONTAINER_MOUNT="/home/node/agent-os"

# Validate agent-os base directory exists
if [ ! -d "$AGENT_OS_BASE" ]; then
    echo "Error: Agent OS base directory not found: $AGENT_OS_BASE"
    echo ""
    echo "Please ensure the directory exists or set AGENT_OS_BASE environment variable:"
    echo "  AGENT_OS_BASE=/path/to/agent-os $0"
    exit 1
fi

# Check for required files
if [ ! -f "$AGENT_OS_BASE/scripts/project-install.sh" ]; then
    echo "Error: project-install.sh not found in $AGENT_OS_BASE/scripts/"
    echo "Please ensure $AGENT_OS_BASE contains a valid agent-os installation"
    exit 1
fi

echo "=== Agent OS Project Installation ==="
echo ""
echo "Agent OS base: $AGENT_OS_BASE"
echo "Container mount: $CONTAINER_MOUNT"
echo "Working directory: /workspace"
echo ""

# Run project-install.sh in devcontainer with agent-os mounted
docker compose run --rm \
    -v "$AGENT_OS_BASE:$CONTAINER_MOUNT" \
    -w /workspace \
    devcontainer \
    "$CONTAINER_MOUNT/scripts/project-install.sh" "$@"

echo ""
echo "✅ Agent OS project installation complete!"
echo ""
echo "Generated files:"
echo "  - /workspace/agent-os/          (standards and workflows)"
echo "  - /workspace/.claude/commands/agent-os/  (Claude Code commands)"
echo "  - /workspace/.claude/agents/agent-os/    (Claude Code subagents)"
echo ""
echo "Next steps:"
echo "  1. Review generated files"
echo "  2. Run /improve-skills in Claude Code (if using skills)"
echo "  3. Commit agent-os/ and .claude/ directories if desired"
