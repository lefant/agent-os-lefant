# GitHub Access Skill

This skill provides guidance for accessing GitHub's REST API using curl commands with personal access tokens.

## Prerequisites

You must have a GitHub personal access token (PAT) set in the environment variable `GH_TOKEN`.

```bash
export GH_TOKEN="your_github_token_here"
```

## Authentication Format

**Use the `token` format for personal access tokens:**

```bash
-H "Authorization: token $GH_TOKEN"
```

**Note:** GitHub also supports the OAuth 2.0 standard `Bearer` format:
```bash
-H "Authorization: Bearer $GH_TOKEN"
```

Both formats work, but `token` is more explicit and has historically been more reliable for personal access tokens.

## Common Headers

All GitHub API requests should include these headers:

```bash
-H "Accept: application/vnd.github+json" \
-H "Authorization: token $GH_TOKEN" \
-H "X-GitHub-Api-Version: 2022-11-28"
```

## Working with Pull Requests

### Get Pull Request Details

```bash
# Get PR information
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER
```

### Understanding PR Comments Endpoints

GitHub has **four different endpoints** for PR-related comments. Understanding the distinction is crucial:

#### 1. Review Comments (Inline Code Comments)
These are comments on specific lines of code in the diff.

```bash
# Get all inline review comments for a PR
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER/comments
```

#### 2. PR Reviews (Review Summaries)
These are the overall review submissions (APPROVED, CHANGES_REQUESTED, COMMENTED) with optional summary text.

```bash
# Get all reviews for a PR
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER/reviews
```

#### 3. Comments from a Specific Review
Get inline comments associated with a specific review submission (rarely needed).

```bash
# Get comments from a specific review ID
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER/reviews/REVIEW_ID/comments
```

#### 4. Issue Comments (Conversation Comments)
These are general comments in the PR conversation (not attached to specific code lines).

```bash
# Get general PR conversation comments
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/issues/PR_NUMBER/comments
```

**Note:** Use `/issues/` endpoint (not `/pulls/`) for conversation comments.

### Create a Pull Request Review Comment

```bash
# Create an inline comment on a PR
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER/comments \
  -d '{
    "body": "Your comment text here",
    "commit_id": "COMMIT_SHA",
    "path": "path/to/file.js",
    "line": 42,
    "side": "RIGHT"
  }'
```

### Submit a Pull Request Review

```bash
# Submit a review (APPROVE, REQUEST_CHANGES, or COMMENT)
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER/reviews \
  -d '{
    "body": "Overall review summary",
    "event": "APPROVE",
    "comments": []
  }'
```

**Valid event values:** `APPROVE`, `REQUEST_CHANGES`, `COMMENT`

## Working with Issues

### List Repository Issues

```bash
# List open issues
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/issues

# List all issues (including closed)
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/OWNER/REPO/issues?state=all"
```

### Get Issue Details

```bash
# Get specific issue
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/issues/ISSUE_NUMBER
```

### Create an Issue

```bash
# Create a new issue
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/issues \
  -d '{
    "title": "Issue title",
    "body": "Issue description",
    "labels": ["bug", "enhancement"]
  }'
```

### Update an Issue

```bash
# Update an existing issue
curl -L \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/issues/ISSUE_NUMBER \
  -d '{
    "state": "closed",
    "body": "Updated description"
  }'
```

## Working with Repositories

### Get Repository Information

```bash
# Get repository details
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO
```

### List Repository Contents

```bash
# List files and directories
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/contents/PATH
```

### Get File Contents

```bash
# Get specific file
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/contents/path/to/file.txt
```

## Working with Commits

### List Commits

```bash
# Get commit history
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/commits
```

### Get Commit Details

```bash
# Get specific commit
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/commits/COMMIT_SHA
```

## Verify Your Token

Quick test to verify your token is configured correctly:

```bash
# Verify token works and check your identity
curl -s -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/user
```

**Expected response:** Your GitHub user information in JSON format.

**If you encounter authentication errors,** see the detailed [troubleshooting guide](references/troubleshooting.md) for error codes, token scoping issues, and debugging steps.

## Response Formats

All successful API responses return JSON. Use `jq` for parsing:

```bash
# Pretty print JSON response
curl -s -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/123 | jq '.'

# Extract specific fields
curl -s -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/123 | jq '.title, .state, .user.login'
```

## Pagination

Many endpoints return paginated results. Use `per_page` and `page` parameters:

```bash
# Get 100 items per page (max)
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/OWNER/REPO/issues?per_page=100&page=1"
```

Check the `Link` header in responses for pagination URLs.

## Rate Limiting

GitHub API has rate limits:
- **Authenticated requests:** 5,000 requests per hour
- **Unauthenticated requests:** 60 requests per hour

Check your rate limit status:

```bash
curl -s -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/rate_limit
```

## Additional Resources

### Local References
- [Comprehensive curl API Reference](references/curl-api.md) - Extensive examples for all GitHub API operations
- [Troubleshooting Guide](references/troubleshooting.md) - Detailed authentication debugging and error handling

### GitHub Documentation
- [GitHub REST API Documentation](https://docs.github.com/en/rest)
- [GitHub API Best Practices](https://docs.github.com/en/rest/guides/best-practices-for-using-the-rest-api)
- [Personal Access Token Creation](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
