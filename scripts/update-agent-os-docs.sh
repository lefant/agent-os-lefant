#!/usr/bin/env bash
set -euo pipefail

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required to fetch Agent OS docs." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
HTML_DIR="${REPO_ROOT}/docs/agent-os/html"

mkdir -p "${HTML_DIR}"

declare -a PAGES=(
  "agent-os|https://buildermethods.com/agent-os"
  "installation|https://buildermethods.com/agent-os/installation"
  "modes|https://buildermethods.com/agent-os/modes"
  "3-layer-context|https://buildermethods.com/agent-os/3-layer-context"
  "standards|https://buildermethods.com/agent-os/standards"
  "skills|https://buildermethods.com/agent-os/skills"
  "profiles|https://buildermethods.com/agent-os/profiles"
  "verification|https://buildermethods.com/agent-os/verification"
  "visuals|https://buildermethods.com/agent-os/visuals"
  "workflows|https://buildermethods.com/agent-os/workflows"
)

for entry in "${PAGES[@]}"; do
  IFS="|" read -r slug url <<<"${entry}"
  outfile="${HTML_DIR}/${slug}.html"
  echo "Fetching ${url}"
  curl -fsSL "${url}" -o "${outfile}"
  echo "  -> ${outfile}"
done

echo "Done. Review differences under docs/agent-os/html/ and update summaries if content changed."
