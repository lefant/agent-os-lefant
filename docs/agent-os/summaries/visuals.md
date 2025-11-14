# Visuals & Design Guidance

Source: `docs/agent-os/html/visuals.html`

## Why visuals matter
- Reduce ambiguity for UI tasks by giving agents concrete mockups, wireframes, or screenshots.
- Help specs capture both behavior and visual expectations, ensuring implementation + verification can compare against the same assets.

## Where visuals live
- During `shape-spec`, Agent OS asks for visual assets.
- Store files under `agent-os/specs/<spec>/planning/visuals/`.
- Supported formats: PNG, JPG/JPEG, PDF. Detection is automatic—no manual references required.

## Naming & fidelity guidelines
- Favor descriptive names: `user-profile-page.png`, `checkout-mobile-320px.jpg`, `error-state-wireframe.png`.
- Encode state, viewport, or fidelity into the filename when helpful.
- Acknowledge fidelity: include `lofi`, `wireframe`, `sketch`, or `rough` in filenames for low-fidelity assets; everything else assumes high fidelity by default.

## Lifecycle touchpoints
1. **Research (`shape-spec`)** – Agent OS scans the visuals folder, asks clarifying questions, and links visuals to requirements.
2. **Specification (`write-spec`)** – Visuals referenced inside the spec so every requirement maps to imagery.
3. **Implementation (`implement-tasks` / `orchestrate-tasks`)** – Agents inspect visuals to match layout, spacing, and styling choices.
4. **Verification** – Final checks compare implementation screenshots (optionally via Playwright) with the original assets.

## Playwright integration
- Playwright MCP lets agents open browsers, capture screenshots, and compare results against stored visuals.
- Optional but recommended for reliable UI verification; install tools from the Playwright MCP repo and grant access to relevant subagents.

## Practical tips
- Commit visuals alongside specs so diffs capture design intent changes.
- Keep a consistent resolution + device naming scheme to avoid confusion (e.g., `desktop-1440px`, `mobile-375px`).
- When designs evolve, update both the asset and the spec references so verification does not fail against old mocks.
