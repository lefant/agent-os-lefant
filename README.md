## Agent OS config for lefant

### Repository source

Upstream Agent OS lives at <https://github.com/buildermethods/agent-os>. This repo holds profiles, standards, and Claude Skills documented below.

### Documentation snapshots

`docs/agent-os/` keeps our local mirror of buildermethods.com plus curated summaries. See `docs/agent-os/README.md` for the file layout and how to refresh HTML snapshots with `docs/agent-os/update-agent-os-docs.sh`.

### Local profiles

- **default** – Upstream baseline left untouched so we can pull updates cleanly.
- **lefant** – Inherits from `default`, drops unused backend migration/model standards, and adds global conventions for our services.
- **altego** – Inherits from `lefant` and overrides `profiles/altego/standards/global/tech-stack.md` to keep the Altego stack locked down.
- **memory** – Standalone profile (`inherits_from: false`) for Obsidian/PKM workflows so experiments stay isolated from product code.

Switch profiles per project with `~/agent-os/scripts/project-install.sh --profile <name>` once your base install contains the latest profile edits.

### Standards

Standards live under each profile’s `standards/` subtree. Keep files modular (global/backend/frontend/testing) so Agent OS can inject them selectively or convert them into Claude Code Skills. Today the customizations focus on Lefant/Altego global practices plus Altego’s `tech-stack.md`.

### Extra skills

We include an additional Claude Skill, `github-access`, captured in `docs/agent-os/summaries/github-access.md`. Bundle it alongside the standards Skills so Claude can pull GitHub issues/PRs from whitelisted repositories without manual copy/paste.

