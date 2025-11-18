#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Get current directory from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')

# Get session ID to ensure we're tracking the correct session
session_id=$(echo "$input" | jq -r '.session_id // ""')

# Get git repo name and branch
repo_branch=""
if [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
    remote_url=$(git -C "$cwd" config --get remote.origin.url 2>/dev/null || echo "")

    if [ -n "$remote_url" ]; then
        # Extract repo name from URL (e.g., "owner/repo" from git@github.com:owner/repo.git)
        repo_name=$(echo "$remote_url" | sed 's/\.git$//' | sed 's/.*[\/:]\([^/]*\/[^/]*\)$/\1/')
    else
        # Fallback to directory basename
        repo_name=$(basename "$cwd")
    fi

    if [ -n "$branch" ]; then
        repo_branch="${repo_name}@${branch}"
    else
        repo_branch="${repo_name}"
    fi
fi

# Get token usage - first check if it's provided directly in JSON
token_used=$(echo "$input" | jq -r '.token_usage.used // empty')
token_total=$(echo "$input" | jq -r '.token_usage.total // empty')

if [ -n "$token_used" ] && [ -n "$token_total" ]; then
    # Token usage provided directly in JSON
    used_k=$((token_used / 1000))
    total_k=$((token_total / 1000))
    percentage=$((token_used * 100 / token_total))
    token_info="${used_k}k/${total_k}k tokens (${percentage}%)"
else
    # Fallback: get token usage from the transcript
    transcript_path=$(echo "$input" | jq -r '.transcript_path // ""')

    if [ -z "$transcript_path" ]; then
        token_info="[no transcript_path]"
    elif [ ! -f "$transcript_path" ]; then
        token_info="[transcript not found: $(basename "$transcript_path")]"
    else
        # Verify this transcript belongs to our session if session_id is available
        original_transcript="$transcript_path"
        if [ -n "$session_id" ]; then
            # Check if transcript path contains our session ID
            if [[ "$transcript_path" != *"$session_id"* ]]; then
                # Try to find the correct transcript file for this session
                transcript_dir=$(dirname "$transcript_path")
                session_transcript="${transcript_dir}/${session_id}.jsonl"
                if [ -f "$session_transcript" ]; then
                    transcript_path="$session_transcript"
                else
                    token_info="[session transcript not found: ${session_id}]"
                fi
            fi
        fi

        if [ -z "$token_info" ]; then
            # Extract the most recent token usage from transcript
            # Looking for pattern like "Token usage: 3734/200000"
            token_line=$(grep -o "Token usage: [0-9]*/[0-9]*" "$transcript_path" | tail -1)

            if [ -n "$token_line" ]; then
                # Extract used and total tokens
                used=$(echo "$token_line" | sed 's/Token usage: \([0-9]*\)\/[0-9]*/\1/')
                total=$(echo "$token_line" | sed 's/Token usage: [0-9]*\/\([0-9]*\)/\1/')

                # Convert to k format
                used_k=$((used / 1000))
                total_k=$((total / 1000))

                # Calculate percentage
                percentage=$((used * 100 / total))

                token_info="${used_k}k/${total_k}k tokens (${percentage}%)"
            else
                token_info="[no token usage in transcript]"
            fi
        fi
    fi
fi

# Build output string: repo@branch  •  directory  •  token stats
if [ -n "$repo_branch" ]; then
    echo "${repo_branch}  •  ${cwd}  •  ${token_info}"
else
    echo "${cwd}  •  ${token_info}"
fi
