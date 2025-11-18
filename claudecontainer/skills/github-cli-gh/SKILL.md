---
name: Github CLI `gh`
description: You can use the github cli tool `gh` to access info about issues, pull request comments and test suite runs
---

here are some example commands

gh auth status

/get-pr-comments <owner> <repo> <pr_number>
Please run the following commands:
1. gh pr view <pr_number> --json number,headRepository,headRefName,baseRefName
2. gh api repos/<owner>/<repo>/issues/<pr_number>/comments --paginate
3. gh api repos/<owner>/<repo>/pulls/<pr_number>/comments --paginate
4. Format the output: for each thread show file:path#line + comment body + replies.
Output only the structured comments, no extra explanation.
