---
name: Testing Quality Assurance CI
description: Implement Docker-first testing strategies, parallel CI/CD workflows, and comprehensive test infrastructure. Use this skill when setting up or configuring test infrastructure, writing integration tests in __tests__/integration/, configuring CI/CD workflows (.github/workflows/), setting up Docker Compose for testing, organizing test projects in Vitest configuration, implementing test cleanup and isolation patterns, configuring environment-based test setup (.env.test.local), managing test coverage tracking and reporting, creating GitHub Actions jobs for parallel test execution, validating test prerequisites, or working with test commands (test:unit, test:integration, test:coverage). Apply when structuring test directories, configuring import paths for tests (use @/ alias in integration tests), or ensuring consistent test execution across local development and CI environments.
---

# Testing Quality Assurance CI

## When to use this skill:

- Setting up or modifying test infrastructure and configuration files (vitest.config.ts, tsconfig.test.json)
- Writing integration tests in `__tests__/integration/` directory
- Configuring CI/CD workflows in `.github/workflows/` (GitHub Actions)
- Setting up Docker Compose for testing environments (compose.yaml, docker-compose files)
- Creating or modifying test commands in package.json scripts
- Organizing test projects and environments in Vitest configuration
- Implementing test cleanup hooks (afterAll, beforeAll) for integration tests
- Configuring environment-based test setup (.env.test.local, .env.local)
- Setting up test coverage tracking, merging, and artifact management
- Creating parallel CI job execution strategies
- Validating test prerequisites and fail-fast checks
- Structuring test directories and file organization
- Configuring import path aliases for tests (especially @/ imports in integration tests)
- Running tests via Docker Compose (docker compose exec app pnpm test)
- Debugging test failures in CI pipelines
- Setting up conditional test execution (skip when secrets unavailable)
- Implementing test artifact retention and download strategies

## Instructions

For details, refer to the information provided in this file:
[testing quality assurance ci](../../../agent-os/standards/testing/quality-assurance-ci.md)
