# Quality Assurance & Continuous Integration

## Overview

This document establishes the quality assurance and continuous integration principles for the Altego projects. These principles aim to ensure code quality, reliability, and maintainability through comprehensive automated testing, efficient CI/CD workflows, and clear testing conventions.

## Core Principles

### 1. Docker-First Testing

All tests should be executable via Docker Compose:

```bash
# Standard test execution pattern
docker compose exec app pnpm run test:unit           # Unit tests
docker compose exec app pnpm run test:integration    # Integration tests
docker compose exec app pnpm run test:run            # All tests once
docker compose exec app pnpm run test:coverage       # With coverage
```

**Why Docker is required**:
- Claude runs in a container without library dependencies installed
- Ensures consistent environment across development and CI
- No local dependency installation required
- Reproducible test runs
- Isolated test execution

**Note**: Direct execution (`pnpm test`) only works when dependencies are installed locally, which is typically not the case in Claude's container environment.

### 2. Parallel CI/CD Execution

CI workflows should maximize parallelization:

```
┌─────────────────┐     ┌──────────────┐
│  unit-tests     │     │ build-docker │
│  (runs first)   │     │  (parallel)  │
└────────┬────────┘     └──────┬───────┘
         │                     │
         v                     v
┌────────────────────┐  ┌──────────────┐
│ integration-basic  │  │ integration- │
│  (after unit)      │  │ docker       │
└────────────────────┘  └──────────────┘
```

**Key patterns**:
- Independent jobs run concurrently (saves 50% time)
- Dependent jobs wait for prerequisites
- Docker builds happen once and reused
- Coverage merging happens after all tests complete

### 3. Environment-Based Test Configuration

Test configuration should use environment variables, not config files:

**Required files**:
- `.env.local` - Application secrets (API keys, auth tokens)
- `.env.test.local` - Test configuration overrides

**Principle**: Integration tests automatically load both files, with test overrides taking precedence.

**Validation**: Run `pnpm run validate-test-setup` before integration tests to verify configuration.

### 4. Import Path Conventions

Code imports should follow consistent patterns based on test type:

**Integration Tests** (`__tests__/integration/`):
```typescript
// ✅ Always use @/ alias
import { someAction } from '@/app/actions/some-action'
import { someUtil } from '@/lib/utils/some-util'

// ❌ Never use relative imports
import { someAction } from '../../app/actions/some-action'
```

**Unit Tests** (co-located with code):
```typescript
// ✅ Use relative imports for siblings
import { encrypt } from '../encryption'

// ✅ Use @/ alias for cross-package imports
import { TokenType } from '@/lib/types/token'
```

**Rationale**: Path aliases make integration tests resilient to refactoring while keeping unit tests focused on their module.

### 5. Comprehensive Coverage Tracking

Coverage should be tracked at multiple levels:

**Per-job coverage**: Each test suite generates its own report
**Merged coverage**: Final unified report combining all test types
**Metrics tracked**: Lines, statements, functions, branches
**Artifact retention**: 30 days for merged reports, 7 days for individual jobs

**CI workflow**:
1. Each test job produces coverage artifact
2. Merge job downloads all artifacts
3. LCOV files combined into unified report
4. HTML report generated for browsing
5. Summary displayed in workflow output

### 6. Test Organization by Project

Vitest should use projects to separate test types:

```typescript
// vitest.config.ts
export default defineConfig({
  projects: [
    {
      name: 'unit:backend',
      environment: 'node',
      include: ['lib/**/*.test.*', 'app/actions/**/*.test.*'],
      exclude: ['__tests__/integration/**'],
    },
    {
      name: 'unit:frontend',
      environment: 'jsdom',
      include: ['components/**/*.test.*', 'hooks/**/*.test.*'],
      exclude: ['__tests__/integration/**'],
    },
    {
      name: 'integration',
      environment: 'node',
      include: ['__tests__/integration/**/*.test.*'],
      testTimeout: 300000, // 5 minutes
    },
  ],
});
```

**Benefits**:
- Separate execution of unit vs integration tests
- Different environments for frontend vs backend
- Different timeouts based on test type
- Clear test categorization

### 7. Conditional Test Execution

Tests should handle missing secrets gracefully:

**Always run**:
- Unit tests (no secrets required)
- Type checking
- Linting

**Conditional**:
- Integration tests (skip when secrets unavailable)
- E2E tests (skip on external PRs)
- Docker-dependent tests (skip when Docker unavailable)

**Implementation**:
```yaml
# GitHub Actions example
integration-tests:
  if: github.event.pull_request.head.repo.full_name == github.repository
  # or: if: github.event_name == 'workflow_dispatch'
```

### 8. Test Cleanup and Isolation

Integration tests should maintain clean state:

**Principles**:
- Track all created resources
- Clean up in `afterAll()` hooks
- Use conditional cleanup wrappers
- Bulk operations for efficiency
- Isolated test data per run

**Example**:
```typescript
const createdPageIds: string[] = [];

afterAll(async () => {
  await conditionalCleanup(async () => {
    if (createdPageIds.length > 0) {
      await archiveMultiplePages(composio, userId, createdPageIds);
    }
  });
});
```

### 9. Fail-Fast Prerequisites

Critical prerequisites should be validated before running expensive tests:

**Pattern**:
```typescript
describe('Prerequisites Validation', () => {
  it('should have required environment variables', () => {
    expect(config.composio.apiKey).toBeDefined();
    expect(config.composio.notionAuthConfigId).toBeDefined();
  });

  it('should have valid test user', async () => {
    const user = await getTestUser();
    expect(user).toBeDefined();
  });
});
```

**Benefits**:
- Fail fast on configuration issues
- Clear error messages
- Save CI time
- Better debugging experience

## Implementation Guidelines

### Test Command Structure

**Quick test commands**:
```bash
# Development (fast feedback)
pnpm run test:unit              # Unit tests only
pnpm run test:unit:watch        # Watch mode

# Pre-commit (comprehensive)
pnpm run test:run               # All tests once
pnpm run test:coverage          # With coverage

# CI (via Docker)
docker compose exec app pnpm run typecheck
docker compose exec app pnpm run test:unit
docker compose exec app pnpm run test:integration
```

### Project Structure

```
project/
├── __tests__/
│   ├── integration/           # Integration tests (use @/ imports)
│   │   ├── composio-connection.test.ts
│   │   ├── composio-notion-basic.test.ts
│   │   └── process-content.test.ts
│   └── unit/                  # Additional unit tests
│       └── frontend/
├── lib/
│   └── module/
│       ├── index.ts
│       ├── types.ts
│       └── __tests__/         # Co-located unit tests (relative imports)
│           └── module.test.ts
├── app/
│   └── actions/
│       ├── action.ts
│       └── __tests__/         # Co-located unit tests
│           └── action.test.ts
└── components/
    └── component/
        ├── component.tsx
        └── __tests__/         # Co-located unit tests
            └── component.test.tsx
```

### CI Workflow Pattern

**Unified CI workflow** (`ci.yml`):

```yaml
name: CI

on:
  pull_request:
  push:
    branches: [main, master]
  workflow_dispatch:

jobs:
  # Always run (parallel)
  unit-tests:
    runs-on: ubuntu-latest
    steps:
      - name: Type check
        run: pnpm run typecheck
      - name: Unit tests with coverage
        run: pnpm run test:unit -- --coverage
      - name: Upload coverage
        uses: actions/upload-artifact@v4
        with:
          name: coverage-unit-tests
          path: coverage/

  # Run in parallel with unit-tests
  build-docker:
    runs-on: ubuntu-latest
    steps:
      - name: Build Docker image
        run: docker compose build
      - name: Save image
        run: docker save -o image.tar app:latest
      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: docker-image
          path: image.tar
          retention-days: 1

  # Wait for unit-tests
  integration-basic:
    needs: [unit-tests]
    if: github.event.pull_request.head.repo.full_name == github.repository
    runs-on: ubuntu-latest
    steps:
      - name: Integration tests
        run: pnpm run test:integration
        env:
          COMPOSIO_API_KEY: ${{ secrets.COMPOSIO_API_KEY }}
          # ... other secrets

  # Wait for build-docker + unit-tests
  integration-docker:
    needs: [build-docker, unit-tests]
    runs-on: ubuntu-latest
    steps:
      - name: Load Docker image
        run: docker load -i image.tar
      - name: Start services
        run: docker compose up -d
      - name: Run Docker-dependent tests
        run: pnpm run test:integration remarkable-conversion

  # Merge all coverage (runs even if tests fail)
  merge-coverage:
    needs: [unit-tests, integration-basic, integration-docker]
    if: always()
    runs-on: ubuntu-latest
    steps:
      - name: Download all coverage artifacts
        uses: actions/download-artifact@v4
        with:
          pattern: coverage-*
          path: coverage/
      - name: Merge LCOV files
        run: cat coverage/*/lcov.info > merged-coverage.lcov
      - name: Generate HTML report
        run: genhtml merged-coverage.lcov -o coverage-html
      - name: Upload merged coverage
        uses: actions/upload-artifact@v4
        with:
          name: merged-coverage-report
          path: coverage-html/
          retention-days: 30
```

### Integration Test Layers

Organize integration tests by complexity:

**Layer 1: Connection Tests**
- Purpose: Verify authentication and connectivity
- Speed: Fast (< 10s)
- Run first: Fail fast on configuration issues

**Layer 2: Basic Operations**
- Purpose: Test simple operations
- Speed: Moderate (< 60s)
- Dependencies: Valid connection

**Layer 3: Workflow Integration**
- Purpose: Test complete workflows
- Speed: Moderate to slow (< 120s)
- Dependencies: Basic operations work

**Example**:
```bash
# Run in order of increasing complexity
pnpm test composio-connection.test.ts      # Layer 1
pnpm test composio-notion-basic.test.ts    # Layer 2
pnpm test process-content.test.ts          # Layer 3
```

### Testing Infrastructure Tools

**Vitest**: Unit and integration tests
- Fast execution
- Multiple projects support
- Watch mode for development
- Coverage tracking

**Playwright**: E2E browser tests
- Remote browser support
- Docker integration
- Screenshot capture
- Multiple browser support

**Docker Compose**: Test environment
- Consistent setup
- Service orchestration
- Network isolation
- Easy cleanup

## Best Practices

### DO

✅ **Run unit tests frequently** during development
✅ **Use Docker for integration tests** to ensure consistency
✅ **Validate test setup** before running integration tests
✅ **Clean up test resources** in afterAll hooks
✅ **Use @/ imports** in integration tests
✅ **Track coverage** for all test types
✅ **Fail fast** on prerequisite failures
✅ **Run tests in parallel** in CI
✅ **Use environment variables** for test configuration
✅ **Commit with passing tests** only

### DON'T

❌ **Don't skip unit tests** - they're fast and catch most bugs
❌ **Don't hardcode secrets** in test files
❌ **Don't use relative imports** in integration tests
❌ **Don't leave test data** in external services
❌ **Don't run integration tests** without validating setup
❌ **Don't mix test types** in the same file
❌ **Don't ignore test failures** in CI
❌ **Don't skip cleanup** in integration tests
❌ **Don't commit broken tests** with intention to fix later
❌ **Don't test implementation details** - test behavior

### Debugging Tests

**Local debugging**:
```bash
# Run single test file
pnpm test path/to/test.test.ts

# Run with debugging output
DEBUG=* pnpm test

# Run specific test by name
pnpm test -t "test name pattern"

# Run in UI mode
pnpm run test:ui
```

**CI debugging**:
- Download test artifacts from workflow run
- Check individual job logs
- Review coverage reports
- Examine environment variable availability

**Common issues**:
- Missing environment variables → run validate-test-setup
- Container connectivity → check docker compose ps
- Authentication failures → verify .env.test.local credentials
- Import resolution → check path alias configuration

## Testing Checklist

Before pushing code, ensure:

- [ ] Unit tests pass locally
- [ ] Type checking passes
- [ ] Integration tests pass (if modified integration code)
- [ ] New code has appropriate test coverage
- [ ] Tests follow import conventions
- [ ] Test cleanup is implemented
- [ ] Environment variables documented (if new ones added)
- [ ] CI workflow triggers defined correctly

Before merging PR, verify:

- [ ] All CI jobs pass
- [ ] Coverage reports look reasonable
- [ ] No test skips without justification
- [ ] Integration tests ran (not skipped due to missing secrets)
- [ ] Merged coverage artifact available
- [ ] No flaky tests introduced

## Benefits

Following these QA/CI principles results in:

- **Faster Feedback**: Unit tests catch issues in seconds
- **Higher Confidence**: Comprehensive coverage at all levels
- **Efficient CI**: Parallel execution saves 50% time
- **Consistent Environment**: Docker ensures reproducibility
- **Better Debugging**: Clear failure messages and artifacts
- **Maintainable Tests**: Clear organization and conventions
- **Reliable Deployments**: Only tested code reaches production
- **Cost Effective**: Optimized CI runs reduce compute costs

## References

- [Top-level Testing Infrastructure](../../../TESTING.md)
- [Notion Paper Sync Testing Guide](../../../notion-paper-sync/TESTING.md)
- [CI/CD Configuration](../../../ci-cd-config.md)
- [GitHub Actions Workflows](../../../.github/workflows/)
- [Test Setup Validation Script](../../../scripts/validate-test-setup.sh)
- [Docker Compose Configuration](../../../compose.yaml)
