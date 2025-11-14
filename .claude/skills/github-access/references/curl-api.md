# GitHub REST API - Curl Reference

This document provides comprehensive curl examples for GitHub's REST API.

## Authentication

### Standard Headers

All authenticated requests should use these headers:

```bash
-H "Accept: application/vnd.github+json" \
-H "Authorization: token $GH_TOKEN" \
-H "X-GitHub-Api-Version: 2022-11-28"
```

### Authorization Formats

**Recommended format for Personal Access Tokens:**
```bash
-H "Authorization: token $GH_TOKEN"
```

**Alternative OAuth 2.0 standard format (also supported):**
```bash
-H "Authorization: Bearer $GH_TOKEN"
```

Both formats work with GitHub PATs, but `token` is more explicit and traditionally more reliable.

### Test Authentication

```bash
# Verify your token and get your user info
curl -s -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/user
```

## Pull Requests

### List Pull Requests

```bash
# List all open PRs
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls

# List all PRs (open, closed, merged)
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/OWNER/REPO/pulls?state=all"

# List closed PRs
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/OWNER/REPO/pulls?state=closed"
```

### Get Pull Request Details

```bash
# Get a specific PR
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER
```

### Create Pull Request

```bash
# Create a new PR
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls \
  -d '{
    "title": "Amazing new feature",
    "body": "Please pull this in!",
    "head": "feature-branch",
    "base": "main"
  }'
```

### Update Pull Request

```bash
# Update PR title, body, or state
curl -L \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER \
  -d '{
    "title": "Updated title",
    "body": "Updated description",
    "state": "closed"
  }'
```

### Merge Pull Request

```bash
# Merge a PR
curl -L \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER/merge \
  -d '{
    "commit_title": "Merge PR title",
    "commit_message": "Additional merge message",
    "merge_method": "merge"
  }'
```

**Merge methods:** `merge`, `squash`, `rebase`

## Pull Request Comments and Reviews

### Understanding Comment Types

GitHub has four different comment/review endpoints:

1. **`/pulls/PR/comments`** - Inline review comments on code
2. **`/pulls/PR/reviews`** - Review summaries (APPROVED, etc.)
3. **`/pulls/PR/reviews/REVIEW_ID/comments`** - Comments from specific review
4. **`/issues/PR/comments`** - General conversation comments

### Get All Review Comments (Inline Code Comments)

```bash
# Get all inline comments on code in the PR
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER/comments
```

### Get PR Reviews

```bash
# Get all review submissions for a PR
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER/reviews
```

Response includes:
- Review ID
- Review state (APPROVED, CHANGES_REQUESTED, COMMENTED, etc.)
- Review body (summary comment)
- Reviewer information

### Get Single Review

```bash
# Get a specific review by ID
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER/reviews/REVIEW_ID
```

### Get Comments from Specific Review

```bash
# Get inline comments associated with a specific review
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER/reviews/REVIEW_ID/comments
```

**Note:** This is rarely needed. Usually `/pulls/PR/comments` gives you all inline comments.

### Get PR Conversation Comments

```bash
# Get general comments (not inline code comments)
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/issues/PR_NUMBER/comments
```

**Important:** Use `/issues/` endpoint (not `/pulls/`) for conversation comments.

### Create Review Comment (Inline on Code)

```bash
# Add an inline comment on specific line of code
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER/comments \
  -d '{
    "body": "Great refactoring!",
    "commit_id": "6dcb09b5b57875f334f61aebed695e2e4193db5e",
    "path": "file.js",
    "line": 42,
    "side": "RIGHT"
  }'
```

**Parameters:**
- `body` - Comment text (required)
- `commit_id` - SHA of commit being commented on (required)
- `path` - File path relative to repo root (required)
- `line` - Line number in diff (required)
- `side` - Which side of diff: `LEFT` (deletion) or `RIGHT` (addition)

### Create Review Comment on Multiple Lines

```bash
# Comment on a range of lines
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER/comments \
  -d '{
    "body": "These lines could be refactored",
    "commit_id": "6dcb09b5b57875f334f61aebed695e2e4193db5e",
    "path": "file.js",
    "start_line": 40,
    "line": 45,
    "side": "RIGHT"
  }'
```

### Create or Update a Review

```bash
# Create a new review (pending state)
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER/reviews \
  -d '{
    "body": "This is close to perfect!",
    "event": "COMMENT",
    "comments": [
      {
        "path": "file.js",
        "body": "Nice work here",
        "line": 42
      }
    ]
  }'
```

**Event types:**
- `APPROVE` - Approve the PR
- `REQUEST_CHANGES` - Request changes before merging
- `COMMENT` - General comment without approval/rejection

### Submit a Review

```bash
# Submit a pending review
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER/reviews/REVIEW_ID/events \
  -d '{
    "body": "Final review comment",
    "event": "APPROVE"
  }'
```

### Update Review Comment

```bash
# Edit an existing review comment
curl -L \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/comments/COMMENT_ID \
  -d '{
    "body": "Updated comment text"
  }'
```

### Delete Review Comment

```bash
# Delete a review comment
curl -L \
  -X DELETE \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/comments/COMMENT_ID
```

### Reply to Review Comment

```bash
# Reply to an existing review comment
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER/comments \
  -d '{
    "body": "Thanks for the feedback!",
    "in_reply_to": COMMENT_ID
  }'
```

### Dismiss Review

```bash
# Dismiss a PR review
curl -L \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER/reviews/REVIEW_ID/dismissals \
  -d '{
    "message": "Review is outdated after recent changes"
  }'
```

## Pull Request Files

### List Files in PR

```bash
# Get list of files changed in PR
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/pulls/PR_NUMBER/files
```

Response includes:
- Filename
- Status (added, removed, modified, renamed)
- Additions/deletions count
- Patch/diff content

## Issues

### List Issues

```bash
# List open issues
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/issues

# List all issues with filters
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/OWNER/REPO/issues?state=all&labels=bug,help+wanted&sort=created&direction=desc"
```

**Query parameters:**
- `state` - `open`, `closed`, `all`
- `labels` - Comma-separated label names
- `sort` - `created`, `updated`, `comments`
- `direction` - `asc`, `desc`
- `since` - ISO 8601 timestamp

### Get Issue

```bash
# Get specific issue
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/issues/ISSUE_NUMBER
```

### Create Issue

```bash
# Create a new issue
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/issues \
  -d '{
    "title": "Found a bug",
    "body": "## Description\n\nDetailed bug report here",
    "assignees": ["octocat"],
    "milestone": 1,
    "labels": ["bug", "high-priority"]
  }'
```

### Update Issue

```bash
# Update an issue
curl -L \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/issues/ISSUE_NUMBER \
  -d '{
    "title": "Updated title",
    "body": "Updated description",
    "state": "closed",
    "labels": ["bug", "resolved"]
  }'
```

### Lock Issue

```bash
# Lock issue conversation
curl -L \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/issues/ISSUE_NUMBER/lock \
  -d '{
    "lock_reason": "too heated"
  }'
```

**Lock reasons:** `off-topic`, `too heated`, `resolved`, `spam`

## Issue Comments

### List Issue Comments

```bash
# Get all comments on an issue
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/issues/ISSUE_NUMBER/comments
```

### Create Issue Comment

```bash
# Add a comment to an issue
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/issues/ISSUE_NUMBER/comments \
  -d '{
    "body": "This is a comment"
  }'
```

### Update Issue Comment

```bash
# Edit an issue comment
curl -L \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/issues/comments/COMMENT_ID \
  -d '{
    "body": "Updated comment text"
  }'
```

### Delete Issue Comment

```bash
# Delete an issue comment
curl -L \
  -X DELETE \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/issues/comments/COMMENT_ID
```

## Repositories

### Get Repository

```bash
# Get repository information
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO
```

### List User Repositories

```bash
# List repositories for authenticated user
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/user/repos

# List repositories for a specific user
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/users/USERNAME/repos
```

### List Organization Repositories

```bash
# List repositories in an organization
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/orgs/ORG/repos
```

### Create Repository

```bash
# Create a new repository
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/user/repos \
  -d '{
    "name": "Hello-World",
    "description": "This is your first repository",
    "homepage": "https://github.com",
    "private": false,
    "is_template": false
  }'
```

### Update Repository

```bash
# Update repository settings
curl -L \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO \
  -d '{
    "name": "New-Name",
    "description": "Updated description",
    "private": true
  }'
```

## Repository Contents

### Get Contents

```bash
# Get contents of a file or directory
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/contents/PATH

# Get contents from specific branch
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/OWNER/REPO/contents/PATH?ref=develop"
```

### Get README

```bash
# Get repository README
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/readme
```

### Create or Update File

```bash
# Create or update a file in the repository
curl -L \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/contents/PATH \
  -d '{
    "message": "Commit message",
    "content": "BASE64_ENCODED_CONTENT",
    "sha": "BLOB_SHA_IF_UPDATING"
  }'
```

**Note:** Content must be base64 encoded. Include `sha` only when updating existing file.

### Delete File

```bash
# Delete a file from the repository
curl -L \
  -X DELETE \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/contents/PATH \
  -d '{
    "message": "Delete file",
    "sha": "BLOB_SHA"
  }'
```

## Commits

### List Commits

```bash
# Get commit history
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/commits

# Get commits with filters
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/OWNER/REPO/commits?sha=develop&path=src/&since=2024-01-01T00:00:00Z"
```

**Query parameters:**
- `sha` - Branch/tag/commit to start from
- `path` - Only commits affecting this path
- `author` - GitHub username or email
- `since` / `until` - ISO 8601 timestamps

### Get Commit

```bash
# Get a specific commit
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/commits/COMMIT_SHA
```

### Compare Commits

```bash
# Compare two commits
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/compare/BASE...HEAD
```

## Branches

### List Branches

```bash
# Get all branches
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/branches
```

### Get Branch

```bash
# Get a specific branch
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/branches/BRANCH_NAME
```

## Tags

### List Tags

```bash
# Get all tags
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/tags
```

## Releases

### List Releases

```bash
# Get all releases
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/releases
```

### Get Latest Release

```bash
# Get the latest published release
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/releases/latest
```

### Get Release by Tag

```bash
# Get a release by tag name
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/releases/tags/TAG_NAME
```

### Create Release

```bash
# Create a new release
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/releases \
  -d '{
    "tag_name": "v1.0.0",
    "target_commitish": "main",
    "name": "Release v1.0.0",
    "body": "## Changes\n\n- Feature A\n- Fix B",
    "draft": false,
    "prerelease": false
  }'
```

## Search

### Search Repositories

```bash
# Search for repositories
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/search/repositories?q=language:javascript+stars:>1000&sort=stars&order=desc"
```

### Search Issues and PRs

```bash
# Search issues and pull requests
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/search/issues?q=repo:OWNER/REPO+is:open+label:bug&sort=created&order=desc"
```

### Search Code

```bash
# Search code in repositories
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/search/code?q=addClass+in:file+language:js+repo:OWNER/REPO"
```

### Search Users

```bash
# Search for users
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/search/users?q=tom+repos:>42+followers:>1000"
```

## Users

### Get Authenticated User

```bash
# Get your own user information
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/user
```

### Get User

```bash
# Get a specific user
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/users/USERNAME
```

## Organizations

### Get Organization

```bash
# Get organization information
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/orgs/ORG
```

### List Organization Members

```bash
# Get organization members
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/orgs/ORG/members
```

## Rate Limiting

### Check Rate Limit

```bash
# Get current rate limit status
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/rate_limit
```

Response includes:
- `limit` - Maximum requests per hour
- `remaining` - Requests remaining
- `reset` - Unix timestamp when limit resets
- Separate limits for `core`, `search`, `graphql`

## Pagination

Many endpoints return paginated results. Use link headers or query parameters:

```bash
# Use per_page and page parameters
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/OWNER/REPO/issues?per_page=100&page=2"
```

**Pagination parameters:**
- `per_page` - Items per page (max 100, default 30)
- `page` - Page number (starts at 1)

**Link header format:**
```
Link: <https://api.github.com/repos/OWNER/REPO/issues?page=2>; rel="next",
      <https://api.github.com/repos/OWNER/REPO/issues?page=10>; rel="last"
```

## Response Handling

### JSON Parsing with jq

```bash
# Pretty print response
curl -s ... | jq '.'

# Extract specific fields
curl -s ... | jq '.title, .state'

# Filter arrays
curl -s ... | jq '.[] | select(.state == "open")'

# Count items
curl -s ... | jq 'length'
```

### Handle Errors

```bash
# Check HTTP status code
curl -s -w "%{http_code}" -o /tmp/response.json ... && cat /tmp/response.json

# Include response headers
curl -i -L ...
```

### Common HTTP Status Codes

| Code | Meaning | Description |
|------|---------|-------------|
| 200 | OK | Request succeeded |
| 201 | Created | Resource created successfully |
| 204 | No Content | Success with no response body |
| 304 | Not Modified | Resource hasn't changed (caching) |
| 400 | Bad Request | Invalid request format |
| 401 | Unauthorized | Authentication required or failed |
| 403 | Forbidden | Authenticated but not authorized |
| 404 | Not Found | Resource doesn't exist |
| 422 | Unprocessable Entity | Validation failed |
| 500 | Internal Server Error | GitHub server error |

## Best Practices

1. **Always authenticate** - Use `-H "Authorization: token $GH_TOKEN"` for higher rate limits
2. **Use API version header** - Include `-H "X-GitHub-Api-Version: 2022-11-28"`
3. **Handle pagination** - Check for `Link` headers on list endpoints
4. **Respect rate limits** - Monitor with `/rate_limit` endpoint
5. **Use conditional requests** - Use `If-None-Match` with ETags for caching
6. **Parse with jq** - Use `jq` for robust JSON parsing
7. **Error handling** - Check HTTP status codes and error messages
8. **Use -L flag** - Follow redirects with `-L`
9. **Silent mode for scripts** - Use `-s` to suppress progress output

## Additional Resources

- [GitHub REST API Documentation](https://docs.github.com/en/rest)
- [GitHub API Best Practices](https://docs.github.com/en/rest/guides/best-practices-for-using-the-rest-api)
- [GitHub API Rate Limiting](https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting)
- [GitHub API Pagination](https://docs.github.com/en/rest/guides/using-pagination-in-the-rest-api)
