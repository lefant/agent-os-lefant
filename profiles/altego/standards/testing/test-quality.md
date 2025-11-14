# Test Quality Review

## Core Principle: Tests Must Expose Problems

Tests should **expose problems**, not hide them. If implementation is broken, tests MUST fail.

## Workaround Detection

When reviewing test code, flag these anti-patterns:

### Red Flags

- Comments containing: WORKAROUND, HACK, TODO FIX, FIXME
- Client-side filtering/transformation of API responses in tests
- `.find()` operations to locate "the right" result when expecting exactly one
- Defensive coding in tests (try/catch, optional chaining without purpose)

### Analysis Questions

For each flagged pattern, ask:

1. Is this compensating for a bug in the implementation?
2. Should the test fail instead of passing with a workaround?
3. Is there a ticket/issue tracking the root cause?
4. Should this test be marked `.skip()` or `.failing()` until fixed?

### Remediation

- If API is broken: Make test fail explicitly, add `.skip()`, file issue
- If API is correct: Fix the test expectations
- If unsure: Ask the user whether this is expected behavior

## Anti-Patterns

### NEVER: Paper Over Bugs in Tests

**Bad Example**:
```typescript
// WORKAROUND: Composio may return multiple documents despite the filter
const doc = results.find(d => d.id === expectedId);
expect(doc).toBeDefined(); // ✅ Passes, but hides the bug!
```

**Good Example**:
```typescript
const results = await queryByItemId(config, itemId);
expect(results.documents).toHaveLength(1); // ❌ Fails, exposing the bug!
expect(results.documents[0].id).toBe(expectedId);
```

### When API is Broken

1. Make the test fail with clear error message
2. Add `.skip()` or `.failing()` to mark as known issue
3. File bug report / create issue
4. Add comment linking to bug tracker
5. Remove skip when bug is fixed

### Never Do

- Add client-side workarounds to make broken APIs work in tests
- Use comments like "WORKAROUND", "HACK", "TODO FIX" without failing the test
- Filter/transform results to match what "should" happen vs. what actually happens

## Test Review Checklist

Before committing, review all modified test files:

- [ ] No "WORKAROUND" or "HACK" comments without corresponding `.skip()` or `.failing()`
- [ ] No client-side filtering to compensate for broken server behavior
- [ ] Each assertion tests actual behavior, not "worked around" behavior
- [ ] If API is broken, test fails with clear message (don't make it pass artificially)
- [ ] Comments explain WHY test exists, not HOW to make it pass
