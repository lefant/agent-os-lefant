#!/usr/bin/env bash
set -euo pipefail

# Short description: Resolve Git merge conflicts automatically with Claude Code (claudecontainer)

# Check for unresolved conflicts first
if ! git diff --name-only --diff-filter=U | grep -q .; then
  echo "✅ No merge conflicts detected."
  exit 0
fi

echo "🤖 Claude Code: resolving merge conflicts..."

claudecontainer -p \
  --append-system-prompt "When resolving conflicts, preserve both logical changes. If intent conflicts, prefer the branch that keeps tests green. After edits, run tests if available; then git add only the files you changed and git commit -m 'chore: resolve merge conflicts with Claude Code'." \
  "Resolve all current Git merge conflicts in this repository. Explain what you changed in a short summary at the end."

echo
echo "✅ Claude Code merge resolution complete."

# Optional: show latest commit summary
git --no-pager log -1 --stat
