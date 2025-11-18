## Altego Library Documentation Reference

This document catalogs the libraries commonly used in altego projects with their Context7 mappings for documentation lookup via the Context7 MCP server and skill.

### Context7 Integration

Context7 is configured via:
- **Skill**: `context7-library-docs` (invoke with `Skill` tool)
- **MCP Server**: Provides `resolve-library-id` and `get-library-docs` tools

When working with unfamiliar library APIs or implementing features, use Context7 to fetch up-to-date, version-specific documentation for the libraries listed below.

---

## How to Use Context7

Use the `context7-library-docs` skill (invoke with `Skill` tool) to access library documentation:

1. **Resolve a library ID**:
   ```
   Tool: resolve-library-id
   Input: { "libraryName": "next.js" }
   Output: /vercel/next.js (with versions and metadata)
   ```

2. **Fetch documentation**:
   ```
   Tool: get-library-docs
   Input: {
     "context7CompatibleLibraryID": "/vercel/next.js",
     "topic": "server actions and data mutations",
     "tokens": 5000
   }
   ```

3. **Fetch specific version**:
   ```
   Tool: get-library-docs
   Input: {
     "context7CompatibleLibraryID": "/vercel/next.js/v15.5.3",
     "topic": "app router",
     "tokens": 4000
   }
   ```

---

## Frontend/TypeScript Libraries

| Library | Version | Context7 ID | Notes |
|---------|---------|-------------|-------|
| React | v19.1.0 | `/facebook/react` | Core UI library |
| Next.js | v15.5.3 | `/vercel/next.js` | Full-stack framework |
| TypeScript | v5.x | `/microsoft/TypeScript` | Type system |
| Stack Auth | v2.8.36 | `/stackframe/stack` | Authentication |
| Composio | v0.2.3 | `/composiohq/composio` or `/ComposioHQ/composio` | Tool integrations |
| Notion SDK | v5.0.0 | `/makenotion/notion-sdk-js` or `/notionhq/notion-sdk-js` | Notion API (see MCP below) |
| Notion MCP Server | - | `/makenotion/notion-mcp-server` | **Primary Notion interface** via Composio+MCP |
| OpenAI SDK | v5.20.2 | `/openai/openai-node` | ChatGPT API |
| Langfuse | v4.2.0 | `/langfuse/langfuse-js` or `/langfuse/langfuse` | LLM tracing |
| Zod | v3.23.8 | `/colinhacks/zod` | Schema validation |
| Upstash Redis | v1.35.4 | `/upstash/upstash-redis` | Redis client |
| Tailwind CSS | v4.x | `/tailwindlabs/tailwindcss` | Utility CSS |
| Radix UI | v1.x-2.x | `/radix-ui/primitives` | UI primitives |
| Lucide React | v0.543.0 | `/lucide-icons/lucide` | Icons |
| Vitest | v3.2.4 | `/vitest-dev/vitest` | Testing framework |
| React Testing Library | v16.3.0 | `/testing-library/react-testing-library` | Component testing |
| Playwright | v1.49.0 | `/microsoft/playwright` | E2E testing |

## Backend/Python Libraries

| Library | Version | Context7 ID | Notes |
|---------|---------|-------------|-------|
| FastAPI | v0.118.0 | `/fastapi/fastapi` or `/tiangolo/fastapi` | Web framework |
| Pydantic | v2.11.9 | `/pydantic/pydantic` | Data validation |
| Uvicorn | v0.37.0 | `/encode/uvicorn` | ASGI server |
| Pytest | v8.0.0+ | `/pytest-dev/pytest` | Testing framework |
| rmscene | v0.6.1 | `/ricklupton/rmscene` | reMarkable parsing |
| ReportLab | v4.4.4 | `/reportlab/reportlab` | PDF generation |

## Vendor/Custom Libraries

| Library | Version | Context7 ID | Notes |
|---------|---------|-------------|-------|
| rmapi-js | v8.4.0 | N/A | Vendored, use code directly |

---

## Library ID Patterns

Context7 library IDs typically follow these patterns:

1. **Organization/Project**: `/org/project`
   - Example: `/vercel/next.js`
   - Example: `/facebook/react`

2. **With Version**: `/org/project/version`
   - Example: `/vercel/next.js/v15.5.3`
   - Example: `/openai/openai-node/v5.20.2`

3. **Common Variations**:
   - GitHub org name may differ from npm package
   - Some use full org name: `/composiohq/composio`
   - Some use short name: `/vercel/next.js` (not `vercel/nextjs`)

## Troubleshooting

### If a library ID doesn't work:
1. Try resolving with `resolve-library-id` first
2. Check the GitHub repository organization and name
3. Try variations (e.g., with/without `.js`, `-js`, etc.)
4. For Python packages, check if PyPI name matches GitHub repo

### Common alternative patterns:
- `@scope/package` → `/scope/package` or `/scope-org/package`
- `package-js` → `/org/package` (drop `-js`)
- `package.js` → `/org/package` (keep `.js`)

---

## Maintenance

**When adopting a new library in altego projects:**
1. Add it to the appropriate section in this standard
2. Include typical version ranges used across projects
3. Determine the Context7 ID (use `resolve-library-id` if unsure)
4. Document its primary usage in the Notes column
5. Keep entries concise but informative

**When upgrading libraries across altego projects:**
1. Update version ranges in this reference
2. Verify Context7 has docs for the new version using `resolve-library-id`
3. Note any breaking changes or migration requirements

**When deprecating a library from altego projects:**
1. Remove its entry from this standard
2. Document the replacement library if applicable

---

**Last Updated**: 2025-11-18
**Maintained By**: Altego Development Team
