# Profiles

Source: `docs/agent-os/html/profiles.html`

Profiles bundle standards, workflows, agents, and commands so you can switch Agent OS behavior per tech stack or client.

## Anatomy
```
~/agent-os/profiles/<profile>/
├── standards/
├── workflows/
├── agents/
└── commands/
```
Each profile also has `profile-config.yml` to declare inheritance + exclusions.

## Default strategy
- Leave `default` untouched; treat it as upstream baseline.
- Create a `general` (or similarly named) profile that `inherits_from: default` and captures organization-wide norms.
- Layer specialized profiles on top (`rails`, `react`, `client-foo`) that inherit from `general`.

## Inheritance details
- `inherits_from: <parent>` pulls every file from the parent profile.
- Override behavior by copying only the files you want to change; everything else flows through.
- Use `exclude_inherited_files` to drop files you do not want from the parent.
- Setting `inherits_from: false` makes a fully standalone profile (rare).
- Common chain example: `rails-api → rails → general → default`.

## Creating & managing profiles
1. Run `~/agent-os/scripts/create-profile.sh` to scaffold directories + config.
2. Customize standards/workflows in the new profile; include only diffs vs parent.
3. Set the default in `~/agent-os/config.yml` (`default_profile: general`) to control what `project-install.sh` uses automatically.
4. Override per repo with `~/agent-os/scripts/project-install.sh --profile react-app`.

## Switching/updating in projects
- Re-run `project-install.sh --profile <new>` to switch an existing repo. The script detects prior installs and walks through update options.
- Use the same flow after editing base profiles so compiled instructions stay current.
- Keep profile changes under version control inside `~/agent-os/` (outside project repos) to make team distribution simpler.
