# Context7 MCP Setup Guide

This guide helps you configure the Context7 MCP server for use with the `context7-library-docs` skill.

## Quick Setup

### 1. Get a Context7 API Key (Optional but Recommended)

While Context7 works without an API key (with lower rate limits), it's recommended to get a free API key for better performance.

**Get your API key**: https://context7.com/dashboard

The API key will start with `ctx7sk_`

### 2. Configure Context7 MCP

Choose one of these configuration methods based on your environment:

#### Option A: Remote HTTP Server (Recommended)

This connects to Context7's hosted MCP server:

```bash
claude mcp add --transport http context7 https://mcp.context7.com/mcp \
  --header "CONTEXT7_API_KEY: ctx7sk_your_api_key_here"
```

**Benefits:**
- No local installation needed
- Always up-to-date
- Centralized for team use

#### Option B: Local stdio Server

This runs Context7 locally using npx:

```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp \
  --api-key ctx7sk_your_api_key_here
```

**Benefits:**
- Full control over the MCP server
- Works offline (after initial package download)
- No external service dependency

#### Option C: Using Environment Variables

Set the API key as an environment variable:

```bash
# Add to your ~/.bashrc, ~/.zshrc, or ~/.profile
export CONTEXT7_API_KEY="ctx7sk_your_api_key_here"
```

Then configure without the explicit key:

```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp
```

### 3. Verify Configuration

Check that Context7 is properly configured:

```bash
claude mcp list
```

You should see `context7` in the output, something like:

```
context7
  Description: Model Context Protocol server for Context7 library documentation
  Transport: http
  Status: active
```

### 4. Test the Connection

Try using Context7 to resolve a library:

In a Claude Code session, you can test with:
```
Please use Context7 to resolve the library ID for "next.js"
```

Expected response should include:
```
- Title: Next.js
- Context7-compatible library ID: /vercel/next.js
- Description: The React Framework for Production
- Versions: v15.0.0, v14.3.0, etc.
```

## Configuration Files

### Claude Code CLI (~/.claude/settings.json)

After running `claude mcp add`, your configuration will be stored in:
```
~/.claude/settings.json
```

Example configuration:
```json
{
  "mcpServers": {
    "context7": {
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "ctx7sk_your_api_key_here"
      }
    }
  }
}
```

Or for local setup:
```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp", "--api-key", "ctx7sk_your_api_key_here"]
    }
  }
}
```

## Proxy Configuration (Corporate Environments)

If you're behind a corporate proxy:

### For Remote HTTP Server

Set proxy environment variables before adding Context7:

```bash
export HTTPS_PROXY=http://proxy.company.com:8080
export HTTP_PROXY=http://proxy.company.com:8080

claude mcp add --transport http context7 https://mcp.context7.com/mcp \
  --header "CONTEXT7_API_KEY: ctx7sk_your_api_key_here"
```

### For Local Server

Add proxy to environment variables:

```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp \
  --api-key ctx7sk_your_api_key_here \
  --env HTTPS_PROXY=http://proxy.company.com:8080
```

## Docker Environment

If running Claude Code in Docker (like this project):

### Add to docker-compose.yaml

```yaml
services:
  app:
    environment:
      - CONTEXT7_API_KEY=${CONTEXT7_API_KEY}
    # ... rest of config
```

### Add to .env file

```bash
CONTEXT7_API_KEY=ctx7sk_your_api_key_here
```

### Configure MCP

Then configure normally:

```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp
```

The environment variable will be picked up automatically.

## Troubleshooting

### "MCP server not found"

**Cause**: Context7 not configured in Claude Code

**Solution**: Run the setup command:
```bash
claude mcp add --transport http context7 https://mcp.context7.com/mcp \
  --header "CONTEXT7_API_KEY: ctx7sk_your_api_key_here"
```

### "Rate limited due to too many requests"

**Cause**: Using Context7 without an API key or exceeded rate limits

**Solutions**:
1. Get a free API key from https://context7.com/dashboard
2. Configure it in your MCP setup
3. Wait a few minutes for rate limits to reset

### "Unauthorized. Please check your API key"

**Cause**: Invalid or expired API key

**Solutions**:
1. Verify your API key starts with `ctx7sk_`
2. Check for typos in the key
3. Generate a new key at https://context7.com/dashboard
4. Reconfigure MCP with the new key

### "Connection failed" or "Network error"

**Cause**: Network issues or proxy blocking

**Solutions**:
1. Check internet connection
2. Verify proxy settings (if in corporate environment)
3. Try switching between remote and local MCP server
4. Check firewall rules

### "Tool not available: resolve-library-id"

**Cause**: MCP server not properly connected

**Solutions**:
1. Verify configuration: `claude mcp list`
2. Restart Claude Code
3. Check MCP server logs
4. Reconfigure the MCP connection

## Advanced Configuration

### Custom Token Limits

You can set default token limits when fetching documentation:

When using the skill, specify tokens in the request:
```
get-library-docs with 8000 tokens for comprehensive documentation
get-library-docs with 2000 tokens for quick reference
```

### Version Pinning

To always use a specific library version:

1. Note the version from `resolve-library-id`
2. Use the versioned ID in `get-library-docs`:
   ```
   /vercel/next.js/v15.5.3
   ```

### Multiple API Keys (Team Setup)

For team environments, each developer can use their own API key:

```bash
# Developer 1
export CONTEXT7_API_KEY="ctx7sk_dev1_key"

# Developer 2
export CONTEXT7_API_KEY="ctx7sk_dev2_key"
```

This allows individual rate limit tracking and usage analytics.

## Rate Limits

### Without API Key
- 10 requests per hour per IP
- Suitable for light usage and testing

### With Free API Key
- 100 requests per hour
- Suitable for individual development

### With Paid API Key
- Higher limits based on plan
- Suitable for team and production use
- See https://context7.com/pricing

## Security Notes

### API Key Security

**DO:**
- Store API keys in environment variables
- Add `.env` to `.gitignore`
- Use different keys for different environments
- Rotate keys periodically

**DON'T:**
- Commit API keys to version control
- Share API keys in public channels
- Use production keys in development
- Hard-code keys in scripts

### Example .gitignore

```gitignore
# Environment variables
.env
.env.local
.env.*.local

# Claude Code settings (if contains keys)
.claude/settings.json
```

## Getting Help

### Context7 Documentation
- Main site: https://context7.com
- Documentation: https://context7.com/docs
- API reference: https://context7.com/docs/api

### Claude Code Documentation
- MCP Guide: https://docs.claude.com/en/docs/claude-code/mcp
- Skills Guide: https://docs.claude.com/en/docs/claude-code/skills

### Support Channels
- Context7 GitHub: https://github.com/upstash/context7
- Claude Code GitHub: https://github.com/anthropics/claude-code

## Next Steps

After completing setup:

1. ✅ Verify Context7 is configured (`claude mcp list`)
2. ✅ Test with a simple library resolution
3. ✅ Review the [SKILL.md](./SKILL.md) for usage patterns
4. ✅ Check [LIBRARY_REFERENCE.md](./LIBRARY_REFERENCE.md) for library IDs
5. ✅ Start using Context7 in your development workflow!

---

**Setup complete?** Start using the skill by working with any library in [LIBRARY_REFERENCE.md](./LIBRARY_REFERENCE.md)!
