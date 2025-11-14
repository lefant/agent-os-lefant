# Agent Reference

See `README.md` for the broader repository overview.

## about agent-os
`docs/agent-os/README.md` anchors the local snapshot, links to the upstream repo, and spells out how our custom profiles, standards, and Skills integrate with this fork.

`docs/agent-os/summaries/overview.md` distills the spec-driven workflow and three-layer context so agents remember how Agent OS structures work.

`docs/agent-os/summaries/installation.md` describes the base and project installers plus common flag combinations for redeploying Agent OS into repos.

`docs/agent-os/summaries/configuration.md` documents every config toggle (Claude commands, subagents, prompts, Skills) and when to enable each mix.

`docs/agent-os/summaries/3-layer-context.md` explains how standards, product docs, and specs are staged across the workflow and when each layer is injected.

`docs/agent-os/summaries/standards.md` covers storage, inheritance, and modular structure for standards along with how they convert into Claude Skills.

`docs/agent-os/summaries/skills.md` focuses on Claude Code Skills behavior, the trade-offs versus explicit standard injection, and the `/improve-skills` workflow.

`docs/agent-os/summaries/profiles.md` details how the default, lefant, memory, and altego profiles inherit or override files and how to switch between them.

`docs/agent-os/summaries/verification.md` summarizes the final QA workflow, listing each check and where the generated reports live in specs.

`docs/agent-os/summaries/visuals.md` outlines how to collect, name, and reference design assets inside `agent-os/specs/*/planning/visuals/`.

`docs/agent-os/summaries/workflows.md` describes the modular workflow files, injection syntax, and conditional compilation tags applied during project install.

`docs/agent-os/summaries/github-access.md` captures the custom GitHub-access Skill we ship so Claude can read whitelisted repositories without manual paste.
