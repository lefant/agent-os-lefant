#!/usr/bin/env bash
set -euo pipefail

# Update .claude from upstream git subtree
# This pulls the latest changes from the claudecontainer repository

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

cd "$REPO_ROOT"

echo "Updating .claude from upstream..."
echo "Repository: git@github.com:lefant/claudecontainer.git"
echo "Branch: master"
echo ""

git subtree pull --prefix .claude git@github.com:lefant/claudecontainer.git master --squash

echo ""
echo "✓ .claude updated successfully!"
echo ""
echo "Review the changes and rebuild if needed:"
echo "  docker compose build devcontainer"
