#!/usr/bin/env bash

if [ -z "${BASH_VERSION:-}" ]; then
  exec bash "$0" "$@"
fi

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"
claude_dir="${repo_root}"

agents_dir="${claude_dir}/agents"
commands_dir="${claude_dir}/commands"

base_url="https://raw.githubusercontent.com/humanlayer/humanlayer/refs/heads/main/.claude"

fetch_to_file() {
  local source_path="$1"
  local destination_path="$2"

  echo "Syncing ${source_path} -> ${destination_path}"
  local tmp_file
  tmp_file="$(mktemp)"
  trap 'rm -f "${tmp_file}"' EXIT

  if ! curl -fsSL "${base_url}/${source_path}" -o "${tmp_file}"; then
    echo "Failed to fetch ${source_path}" >&2
    exit 1
  fi

  mv "${tmp_file}" "${destination_path}"
  trap - EXIT
  rm -f "${tmp_file}"
}

# Expected upstream files
agent_files=(
  "codebase-analyzer.md"
  "codebase-locator.md"
  "codebase-pattern-finder.md"
  "thoughts-analyzer.md"
  "thoughts-locator.md"
  "web-search-researcher.md"
)

command_mappings=(
  "create_plan.md:commands/create_plan_nt.md"
  "implement_plan.md:commands/implement_plan.md"
  "research_codebase.md:commands/research_codebase_nt.md"
)

sync_agents() {
  if ! [ -d "${agents_dir}" ]; then
    echo "Agents directory not found: ${agents_dir}" >&2
    exit 1
  fi

  for filename in "${agent_files[@]}"; do
    fetch_to_file "agents/${filename}" "${agents_dir}/rpi/${filename}"
  done
}

sync_commands() {
  if ! [ -d "${commands_dir}" ]; then
    echo "Commands directory not found: ${commands_dir}" >&2
    exit 1
  fi

  for entry in "${command_mappings[@]}"; do
    local dest source
    dest="${entry%%:*}"
    source="${entry#*:}"
    fetch_to_file "${source}" "${commands_dir}/rpi/${dest}"
  done
}

sync_agents
sync_commands
