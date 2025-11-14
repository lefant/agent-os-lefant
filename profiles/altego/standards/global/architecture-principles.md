# Architecture Principles for Notion Paper Sync

## Overview

This document establishes the architectural principles and guidelines for the Notion Paper Sync backend, based on the research conducted on 2025-10-23. These principles aim to create a more modular, testable, and maintainable codebase.

## Core Principles

### 1. Library-First Architecture

Each backend capability should be implemented as a standalone library function that:
- Receives all required data as parameters (tokens, configurations, etc.)
- Has a clear top-level entry point with observability span
- Can be integration tested in isolation
- Can be called from a shallow server action wrapper
- Could be called from an API endpoint with the right data if needed

### 2. Single Responsibility Modules

Each library module should have one clear responsibility:
- **lib/workflow** - Orchestrates multi-step processes
- **lib/remarkable-fetch** - Fetches documents from reMarkable
- **lib/remarkable-render** - Converts .rm files to PDF
- **lib/extract** - Transcribes/extracts content (OpenAI API, no tools)
- **lib/process** - Processes content with tools (OpenAI API with Composio tools)

### 3. Consistent Module Pattern

All library modules should follow the same pattern:

```typescript
// lib/[module]/index.ts
export async function executeModule(
  data: ModuleInput,
  config: ModuleConfig,
  context?: ExecutionContext
): Promise<ModuleResult> {
  // Single entry point with observability
  return withObservability('module-name', async () => {
    // Module implementation
  });
}

// Standardized result envelope
interface ModuleResult {
  success: boolean;
  data?: ModuleOutput;
  error?: string;
  metadata?: ModuleMetadata;
}
```

### 4. Parameter-Based Authentication

Stack Auth user data should be:
- Retrieved once at the server action entry point
- Passed down as a parameter to library functions
- Never retrieved internally by library functions
- Extracted to just the needed data (userId, tokens) when possible

Example flow:
```typescript
// Server Action
const user = await getCachedUser();
const tokens = await extractTokens(user);
const result = await libraryFunction(data, tokens, config);

// Library Function
export async function libraryFunction(
  data: Data,
  tokens: Tokens,
  config: Config
): Promise<Result> {
  // Use provided tokens, don't fetch user
}
```

### 5. Testable in Isolation

Each module should be testable independently:
- No tight coupling between steps
- Clear input/output contracts
- Mockable dependencies
- Same code path for tests and production (just different inputs)

### 6. Composable Workflows

Workflows should compose individual modules without duplicating logic:

```typescript
// lib/workflows/remarkable-to-notion.ts
export async function extractRemarkableToNotion(
  itemHash: string,
  tokens: Tokens,
  config: WorkflowConfig
): Promise<WorkflowResult> {
  // Step 1: Fetch
  const fetchResult = await remarkableFetch(itemHash, tokens.remarkable);
  if (!fetchResult.success) return fetchResult;

  // Step 2: Render
  const renderResult = await remarkableRender(fetchResult.data);
  if (!renderResult.success) return renderResult;

  // Step 3: Extract
  const extractResult = await extract(renderResult.data);
  if (!extractResult.success) return extractResult;

  // Step 4: Process
  const processResult = await process(extractResult.data, tokens.notion);
  return processResult;
}
```

### 7. No Code Duplication

Shared logic should be extracted to shared modules:
- Root page discovery → `lib/notion-utils/root-page.ts`
- Connection management → `lib/composio-utils/connection.ts`
- Common patterns → `lib/shared/patterns.ts`

### 8. Clear Separation of Concerns

The extraction and processing steps should be clearly separated:

**Extract** (`lib/extract`):
- Input: Document (PDF, image, etc.)
- Processing: Transcription and content extraction
- Output: Structured content/text
- Tools: None (pure extraction)

**Process** (`lib/process`):
- Input: Structured content from extraction
- Processing: Apply tools and transformations
- Output: Created/updated Notion pages
- Tools: Composio/MCP tools

This separation allows:
- Testing extraction without tool execution
- Processing pre-extracted content
- Swapping extraction methods
- Reprocessing with different tools

### 9. Environment-Agnostic Libraries

Library functions should not directly access environment variables or global state:
- Configuration passed as parameters
- No direct `process.env` access in libraries
- No singleton clients in libraries
- Dependency injection for external services

### 10. Consistent Error Handling

All modules should follow the same error handling pattern:
- Return result envelopes, not throw exceptions
- Include error context in result
- Log errors with appropriate detail
- Preserve partial results when possible

## Implementation Guidelines

### Module Structure

```
lib/
├── workflows/          # Orchestration of multi-step processes
│   └── remarkable-to-notion.ts
├── remarkable-fetch/   # Fetch from reMarkable
│   ├── index.ts       # Main export
│   ├── types.ts       # TypeScript types
│   └── __tests__/     # Unit tests
├── remarkable-render/  # Convert .rm to PDF
│   ├── index.ts
│   ├── types.ts
│   └── __tests__/
├── extract/           # Content extraction (no tools)
│   ├── index.ts
│   ├── types.ts
│   └── __tests__/
├── process/           # Content processing (with tools)
│   ├── index.ts
│   ├── types.ts
│   └── __tests__/
└── shared/            # Shared utilities
    ├── notion-utils/
    │   └── root-page.ts
    └── patterns/
        └── result-envelope.ts
```

### Testing Strategy

1. **Unit Tests**: Test individual functions with mocked dependencies
2. **Integration Tests**: Test modules with real services but isolated scope
3. **E2E Tests**: Test complete workflows through server actions
4. **Same Code Path**: Tests use same functions as production, just different inputs

### Migration Path

To migrate existing code to these principles:

1. **Phase 1**: Extract duplicated logic to shared modules
2. **Phase 2**: Split mixed-concern modules into focused modules
3. **Phase 3**: Standardize module interfaces and patterns
4. **Phase 4**: Update tests to use production code paths
5. **Phase 5**: Remove test-specific code variants

## Benefits

Following these principles will result in:
- **Better Testing**: Each module can be tested in isolation
- **Easier Maintenance**: Clear responsibilities and boundaries
- **Improved Reusability**: Modules can be composed in different ways
- **Reduced Duplication**: Shared logic in one place
- **Cleaner Architecture**: Separation of concerns throughout
- **Parallel Development**: Teams can work on individual modules independently

## References

- [Research: Notion Paper Sync Backend Architecture](../research/2025-10-23-notion-paper-sync-backend-architecture.md)
- [Development Workflow](../../../DEVELOPMENT.md)
- [Testing Strategy](../../../TESTING.md)