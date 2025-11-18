# Context7 Library Documentation Skill

This skill provides intelligent access to up-to-date documentation for all major libraries used in the Altego repository through the Context7 MCP server.

## Purpose

Instead of relying on potentially outdated training data, this skill ensures that when working with any major library in this repository, you can fetch current, version-specific documentation, API references, and code examples directly from the source.

## Files

- **SKILL.md** - Main skill definition with comprehensive instructions for using Context7 with project libraries
- **LIBRARY_REFERENCE.md** - Quick reference table of all libraries and their Context7 IDs
- **README.md** - This file

## Covered Libraries

### Frontend/TypeScript
- React, Next.js, TypeScript
- Stack Auth, Composio, Notion SDK, **Notion MCP Server**, OpenAI SDK
- Langfuse (tracing), Zod (validation), Upstash Redis
- Tailwind CSS, Radix UI, Lucide icons
- Vitest, React Testing Library, Playwright

**Note**: This project uses Notion primarily through Composio and the Notion MCP Server, not direct SDK calls.

### Backend/Python
- FastAPI, Pydantic, Uvicorn
- Pytest
- rmscene, ReportLab

### Vendor/Custom
- rmapi-js (local vendored library)

## Setup Requirements

This skill requires the Context7 MCP server to be configured in your Claude Code environment.

### Check if Context7 is configured

```bash
claude mcp list
```

If you see `context7` in the list, you're all set!

### If not configured, add Context7 MCP

**Option 1: Remote server (recommended)**
```bash
claude mcp add --transport http context7 https://mcp.context7.com/mcp \
  --header "CONTEXT7_API_KEY: ctx7sk_your_api_key"
```

**Option 2: Local server**
```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp \
  --api-key ctx7sk_your_api_key
```

**Get a free API key**: https://context7.com/dashboard

### Environment Variable Setup (optional)

You can also set the API key as an environment variable:

```bash
export CONTEXT7_API_KEY="ctx7sk_your_api_key"
```

Then configure without the explicit key:

```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp
```

## Usage

Once the skill is active, it will automatically guide you to use Context7 when working with any of the listed libraries.

### Typical workflow:

1. **Planning a feature** → Skill reminds you to fetch docs for relevant libraries
2. **Implementing code** → Skill helps you resolve library IDs and fetch specific documentation
3. **Debugging errors** → Skill guides you to fetch error-specific documentation
4. **Code review** → Skill helps verify patterns match current best practices

### Manual usage:

You can also invoke the skill manually when needed:

```
Use the context7-library-docs skill when working with [library name]
```

## Quick Examples

### Example 1: Working with Next.js Server Actions

The skill will guide you to:
1. Resolve the Next.js library ID: `/vercel/next.js`
2. Fetch docs with topic: "server actions and mutations"
3. Review current patterns and implement correctly

### Example 2: Configuring FastAPI Middleware

The skill will guide you to:
1. Resolve the FastAPI library ID: `/tiangolo/fastapi`
2. Fetch docs with topic: "middleware and CORS configuration"
3. Apply official patterns to your implementation

### Example 3: Using Zod with Forms

The skill will guide you to:
1. Resolve the Zod library ID: `/colinhacks/zod`
2. Fetch docs with topic: "schema validation and type inference"
3. Create type-safe form schemas

## Benefits

- **Always up-to-date**: Get current documentation, not outdated training data
- **Version-specific**: Fetch docs for the exact version you're using
- **Error prevention**: Follow current best practices and avoid deprecated patterns
- **Faster development**: Get accurate API references and code examples quickly
- **Better debugging**: Access error-specific documentation and migration guides

## Maintenance

When updating library versions in `package.json` or `requirements.txt`:

1. Update the version in `LIBRARY_REFERENCE.md`
2. Verify Context7 has docs for the new version
3. Check for breaking changes
4. Update code if needed

## Troubleshooting

### "Library ID not found"
- Try alternative names (e.g., "next" vs "next.js")
- Use `resolve-library-id` tool to search
- Check GitHub org/repo name structure

### "Documentation too broad"
- Make the topic more specific
- Include exact API or feature name
- Mention your use case in the topic

### "Version mismatch"
- Request specific version: `/org/lib/v1.2.3`
- Check if patterns apply to your version
- Review migration guides for breaking changes

## Related Documentation

- [Context7 MCP Documentation](https://context7.com/docs)
- [MCP Protocol Specification](https://modelcontextprotocol.io/)
- [Claude Code MCP Guide](https://docs.claude.com/en/docs/claude-code/mcp)

## Last Updated

**Date**: 2025-11-15
**Version**: 1.0.0

---

For detailed usage instructions, see [SKILL.md](./SKILL.md)
For quick library ID lookup, see [LIBRARY_REFERENCE.md](./LIBRARY_REFERENCE.md)
