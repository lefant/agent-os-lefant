---
name: Testing Test Quality
description: Ensure tests expose problems rather than hide them, making tests fail when APIs are broken instead of papering over bugs with workarounds. Use this skill when writing test assertions and expectations, reviewing test code for workarounds (WORKAROUND, HACK, TODO FIX comments), debugging failing or flaky tests, encountering broken APIs in tests, writing expect() statements, finding client-side filtering or transformation in tests (like .find() to locate "the right" result), reviewing test pull requests, refactoring existing tests, or deciding whether to use .skip() or .failing() for known issues. Apply when analyzing whether defensive coding in tests is hiding bugs, determining if test expectations match actual vs. desired behavior, or ensuring tests fail explicitly with clear error messages when implementation is broken.
---

# Testing Test Quality

## When to use this skill:

- Writing test assertions and expect() statements in any test file (.test.ts, .test.tsx)
- Reviewing test code for anti-patterns like WORKAROUND, HACK, TODO FIX comments
- Debugging failing tests to understand if failure exposes a real bug
- Encountering flaky tests that sometimes pass/fail inconsistently
- Finding client-side filtering or transformation of API responses in tests (e.g., results.find())
- Analyzing whether defensive coding in tests (try/catch, optional chaining) is hiding bugs
- Deciding whether to use .skip() or .failing() to mark tests with known issues
- Reviewing test pull requests for test quality issues
- Refactoring existing tests to improve their bug-detection capability
- Dealing with broken APIs or third-party services in tests
- Ensuring test expectations match actual behavior, not "worked around" behavior
- Writing clear test failure messages that expose the root cause
- Determining if a test should fail explicitly instead of passing with workarounds
- Removing workarounds when underlying bugs are fixed
- Creating or updating test review checklists

## Instructions

For details, refer to the information provided in this file:
[testing test quality](../../../agent-os/standards/testing/test-quality.md)
