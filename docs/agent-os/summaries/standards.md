# Standards: Defining “How We Build”

Source: `docs/agent-os/html/standards.html`

## Storage & inheritance
- Keep canonical standards inside your base install under `~/agent-os/profiles/<profile>/standards/`.
- Default structure already wired to injection points: `backend/`, `frontend/`, `global/`, `testing/`.
- Avoid editing `default`; instead, create layered profiles (`general` → `react` → `client-x`) using `profile-config.yml` with `inherits_from`.
- Special file: `global/tech-stack.md` seeds `plan-product` with default technology choices.

## Customization workflow
1. Duplicate only the files you need to override into your custom profile; everything else inherits.
2. Use `create-profile.sh` to scaffold new profiles with inheritance + placeholders.
3. Keep standards modular (many small topic files) vs. monolithic docs—agents consume only what’s referenced.
4. Record the “why” and include concrete examples for each rule to reduce ambiguity.

## Claude Code Skills integration
- When `standards_as_claude_code_skills: true` and `claude_code_commands: true`, Agent OS converts every standard file into an autonomous Claude Skill.
- Benefits: fewer tokens, only relevant standards are pulled into context, cleaner prompts.
- Trade-offs: cannot explicitly force-read a standard; relies on Claude’s skill triggering.
- Use `/improve-skills` after changing standards to re-optimize descriptions.

## Injection basics (non-Skills mode)
- Workflow/command files use tags like `{{standards/global/*}}` or `{{standards/backend/database}}`.
- During project install these become `@agent-os/standards/...` references that AI tools can open.
- Mix multiple tags to assemble the correct bundle per agent (e.g., global + frontend/components + frontend/css).
- Search for `{{standards` inside a profile to audit every injection point before customizing.

## Best practices
- **Start minimal** – add standards only for patterns you repeatedly correct.
- **Be specific** – replace “write clean code” with rules + code snippets.
- **Name consistently** – descriptive filenames improve readability + referencing.
- **Avoid over-specifying** – focus on conventions that materially impact quality.
- **Run `/improve-skills`** after every major standards change when Claude Skills are enabled.
