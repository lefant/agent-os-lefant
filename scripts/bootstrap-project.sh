#!/usr/bin/env bash
# Bootstrap a new project to use claudecontainer shared configuration

set -e

CLAUDECONTAINER_REPO="${CLAUDECONTAINER_REPO:-git@github.com:lefant/claudecontainer.git}"

# 1. Check/create global config
if [ ! -f ~/.env.claudecontainer ]; then
    echo "Creating ~/.env.claudecontainer (global configuration)..."
    cat > ~/.env.claudecontainer <<EOF
# Global ClaudeContainer Configuration
CLAUDECONTAINER_PATH=./claudecontainer
TZ=Europe/Stockholm

# add your own below
CLAUDE_CODE_OAUTH_TOKEN=sk-ant-...
GH_TOKEN=github_pat_...
NTFY_URL=https://ntfy.sh/claude-...
NTFY_TOKEN=tk_...
EOF
    echo "✓ Created ~/.env.claudecontainer"
    echo "  You can customize this file for your system."
else
    echo "✓ Using existing ~/.env.claudecontainer"
fi
echo

# 2. Add claudecontainer as subtree
if [ ! -d claudecontainer ]; then
    echo "Adding claudecontainer via git subtree..."
    git subtree add --prefix claudecontainer "$CLAUDECONTAINER_REPO" master --squash
    echo "✓ Added claudecontainer"
else
    echo "✓ claudecontainer already exists"
fi
echo

# 3. Create compose.yaml
if [ ! -f compose.yaml ]; then
    echo "Creating compose.yaml..."
    cat > compose.yaml <<EOF
include:
  - ./claudecontainer/compose.shared.yaml
EOF
    echo "✓ Created compose.yaml"
fi

# 4. Create .devcontainer/devcontainer.json
mkdir -p .devcontainer
if [ ! -f .devcontainer/devcontainer.json ]; then
    echo "Creating .devcontainer/devcontainer.json..."
    cat > .devcontainer/devcontainer.json <<EOF
{
  "name": "devcontainer",
  "dockerComposeFile": ["../compose.yaml"],
  "service": "devcontainer",
  "runServices": ["devcontainer"],
  "workspaceFolder": "/workspace",
  "customizations": {
    "vscode": {
      "extensions": [
        "anthropic.claude-code"
      ]
    }
  }
}
EOF
    echo "✓ Created .devcontainer/devcontainer.json"
fi

# 5. Initialize claudecontainer-user-dot-claude
mkdir -p claudecontainer-user-dot-claude
echo '*' > claudecontainer-user-dot-claude/.gitignore
if [ ! -f claudecontainer-user-dot-claude/.claude.json ]; then
    echo "Initializing claudecontainer-user-dot-claude/.claude.json..."
    cp claudecontainer/dot-claude.json.template claudecontainer-user-dot-claude/.claude.json
    echo "✓ Initialized local Claude state"
fi

echo
echo "✅ Bootstrap complete!"
echo
echo "Next steps:"
echo "  1. Customize ~/.env.claudecontainer if needed"
echo "  2. Run: docker compose build devcontainer"
echo "  3. Run: docker compose run --rm claude"
echo "  4. Or open in VS Code and reopen in container"
