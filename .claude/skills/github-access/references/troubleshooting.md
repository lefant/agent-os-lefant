# GitHub API Authentication Troubleshooting

This guide helps you diagnose and fix authentication issues with GitHub's REST API.

## Quick Token Test

Before debugging API issues, verify your token is valid:

```bash
# Verify token works and check your identity
curl -s -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/user
```

**Expected response:** Your GitHub user information in JSON format.

If this fails, your token is not configured correctly.

## Common Authentication Errors

| Status Code | Error Message | Likely Cause | Solution |
|-------------|---------------|--------------|----------|
| 401 | Bad credentials | Token is invalid, expired, or malformed | Generate a new token or check `$GH_TOKEN` is set correctly |
| 403 | Forbidden | Token lacks required scopes/permissions | Recreate token with appropriate scopes (e.g., `repo`, `read:org`) |
| 404 | Not Found | Repository is private and token can't access it | Verify token has access to the repository |
| 404 | Not Found | Resource doesn't exist | Check OWNER/REPO/PR_NUMBER are correct |

## Authorization Header Format Issues

If you encounter authentication issues:

### 1. Try the Alternative Format

If `token` format fails, try `Bearer`:
```bash
-H "Authorization: Bearer $GH_TOKEN"
```

Both formats work with personal access tokens, but one may work better in certain configurations.

### 2. Verify Token Is Exported

```bash
echo $GH_TOKEN
```

If this is empty, you need to export your token:
```bash
export GH_TOKEN="your_token_here"
```

### 3. Check Token Scopes

Ensure your PAT has required scopes for the operations you're performing:

**Common scopes:**
- `repo` - Full control of private repositories
- `public_repo` - Access public repositories only
- `read:org` - Read org and team membership
- `workflow` - Update GitHub Actions workflows
- `write:discussion` - Write team discussions

**To check your token's scopes:**
Look at the `X-OAuth-Scopes` header in any API response:
```bash
curl -i -L \
  -H "Authorization: token $GH_TOKEN" \
  https://api.github.com/user | grep "X-OAuth-Scopes"
```

### 4. Test with a Simple Endpoint

Use the `/user` endpoint to verify basic authentication works before trying more complex operations.

## Token Issues

### Token Expired or Revoked

**Symptoms:**
- 401 Bad credentials
- Previously working token now fails

**Solution:**
1. Go to GitHub Settings → Developer settings → Personal access tokens
2. Check if your token is still listed and active
3. If expired or missing, generate a new token
4. Update your `$GH_TOKEN` environment variable

### Insufficient Permissions

**Symptoms:**
- 403 Forbidden on specific operations
- Can read but not write

**Solution:**
1. Check required scopes for the API endpoint you're using
2. Create a new token with additional scopes
3. Be careful not to grant excessive permissions

### Token for Wrong Account

**Symptoms:**
- 404 Not Found on repositories you know exist
- Can access some repos but not others

**Solution:**
1. Verify which account your token belongs to:
   ```bash
   curl -s -L \
     -H "Authorization: token $GH_TOKEN" \
     https://api.github.com/user | jq '.login'
   ```
2. Ensure you're using a token for the account that has access to the repository

## Network and Connection Issues

### SSL/TLS Issues

If you get SSL certificate errors:

```bash
# Temporarily bypass SSL verification (not recommended for production)
curl -k -L ...

# Better: Update your CA certificates
# On Ubuntu/Debian:
sudo apt-get update && sudo apt-get install ca-certificates

# On macOS:
brew install ca-certificates
```

### Proxy Issues

If you're behind a corporate proxy:

```bash
# Set proxy for curl
export http_proxy="http://proxy.example.com:8080"
export https_proxy="http://proxy.example.com:8080"

# Or use curl's proxy flag
curl -x http://proxy.example.com:8080 ...
```

### DNS Issues

If you get "Could not resolve host" errors:

```bash
# Test DNS resolution
nslookup api.github.com

# Try using a different DNS server
# Add to /etc/resolv.conf:
# nameserver 8.8.8.8
```

## Rate Limiting Issues

### Hitting Rate Limits

**Symptoms:**
- 403 Forbidden with message "API rate limit exceeded"
- `X-RateLimit-Remaining: 0` header

**Solution:**
1. Check your rate limit status:
   ```bash
   curl -s -L \
     -H "Authorization: token $GH_TOKEN" \
     https://api.github.com/rate_limit
   ```

2. Wait until the reset time (shown in response)

3. Use authenticated requests (5000/hour vs 60/hour)

4. Implement request throttling in scripts

5. Consider using conditional requests with ETags to avoid counting cached responses

### Secondary Rate Limits

GitHub also has secondary rate limits for creating content (issues, comments, etc.):

**Solution:**
- Add delays between requests (1-2 seconds)
- Don't make rapid-fire POST/PATCH/DELETE requests
- Use batch operations where available

## Token Best Practices

### Security

- **Never commit tokens** to version control
- **Never log tokens** in application logs
- **Use environment variables** for token storage
- **Rotate tokens regularly** - especially if exposed
- **Revoke immediately** if compromised
- **Use fine-grained tokens** when possible for better security

### Scoping

- **Minimal permissions** - only grant scopes you need
- **Separate tokens** - use different tokens for different purposes
- **Time-limited** - use expiration dates when creating tokens
- **Regular audits** - review and remove unused tokens

### Storage

- **Environment variables** - for local development
- **Secret managers** - for production (AWS Secrets Manager, HashiCorp Vault, etc.)
- **GitHub Actions secrets** - for CI/CD workflows
- **Never in code** - even in private repositories

## Debugging Tools

### Verbose Output

Use `-v` flag to see full request/response details:

```bash
curl -v -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/user
```

### Check Response Headers

Important headers to check:

```bash
curl -i -L \
  -H "Authorization: token $GH_TOKEN" \
  https://api.github.com/user | head -20
```

**Key headers:**
- `X-RateLimit-Limit` - Your rate limit
- `X-RateLimit-Remaining` - Requests remaining
- `X-RateLimit-Reset` - When limit resets (Unix timestamp)
- `X-OAuth-Scopes` - Scopes your token has
- `X-Accepted-OAuth-Scopes` - Scopes required for this endpoint

### Save Response for Analysis

```bash
# Save both headers and body
curl -i -L \
  -H "Authorization: token $GH_TOKEN" \
  https://api.github.com/user > response.txt

# Save just the body
curl -s -L \
  -H "Authorization: token $GH_TOKEN" \
  https://api.github.com/user > response.json
```

### Test with Different Tools

If curl isn't working, try:

**httpie:**
```bash
http https://api.github.com/user \
  "Authorization: token $GH_TOKEN" \
  "Accept: application/vnd.github+json"
```

**wget:**
```bash
wget --header="Authorization: token $GH_TOKEN" \
     --header="Accept: application/vnd.github+json" \
     https://api.github.com/user
```

## Getting Help

If you're still having issues:

1. **Check GitHub Status** - https://www.githubstatus.com/
2. **Review API docs** - https://docs.github.com/en/rest
3. **Search GitHub Community** - https://github.community/
4. **Contact GitHub Support** - For paid accounts

## Common Patterns for Debugging

### Step-by-Step Debugging Process

1. **Verify token exists:**
   ```bash
   echo $GH_TOKEN
   ```

2. **Test basic auth:**
   ```bash
   curl -s -H "Authorization: token $GH_TOKEN" https://api.github.com/user
   ```

3. **Check rate limits:**
   ```bash
   curl -s -H "Authorization: token $GH_TOKEN" https://api.github.com/rate_limit
   ```

4. **Try the failing request with verbose output:**
   ```bash
   curl -v -H "Authorization: token $GH_TOKEN" https://api.github.com/repos/OWNER/REPO
   ```

5. **Examine response headers:**
   ```bash
   curl -i -H "Authorization: token $GH_TOKEN" https://api.github.com/repos/OWNER/REPO | head -20
   ```

6. **Verify scopes:**
   ```bash
   curl -s -H "Authorization: token $GH_TOKEN" https://api.github.com/user | grep -i oauth
   ```

This systematic approach will help you identify where the issue lies.
