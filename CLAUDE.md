Claude, start with `AGENTS.md` whenever you open this repo.

It explains how Agent OS works and is configured here.

## Testing Anti-Patterns

### NEVER: Paper Over Bugs in Tests

Tests should **expose problems**, not hide them. If implementation is broken, tests MUST fail.

**Bad Example** (from PR #60):
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
