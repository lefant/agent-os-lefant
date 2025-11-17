# Context7 Library Reference

Quick reference table for all libraries used in this repository with their Context7 IDs.

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

## Usage Examples

### Resolve a library ID
```
Tool: resolve-library-id
Input: { "libraryName": "next.js" }
Output: /vercel/next.js (with versions and metadata)
```

### Fetch documentation
```
Tool: get-library-docs
Input: {
  "context7CompatibleLibraryID": "/vercel/next.js",
  "topic": "server actions and data mutations",
  "tokens": 5000
}
```

### Fetch specific version
```
Tool: get-library-docs
Input: {
  "context7CompatibleLibraryID": "/vercel/next.js/v15.5.3",
  "topic": "app router",
  "tokens": 4000
}
```

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

## Update Checklist

When updating library versions in package.json or requirements.txt:

1. Update version in this reference table
2. Verify Context7 has docs for the new version:
   ```
   resolve-library-id("<library-name>")
   ```
3. Check for breaking changes in new version docs
4. Update code if needed based on migration guides
5. Test with the new version

## Last Updated

**Date**: 2025-11-15
**By**: Claude Code

---

For detailed usage instructions, see the main [SKILL.md](./SKILL.md) file.
