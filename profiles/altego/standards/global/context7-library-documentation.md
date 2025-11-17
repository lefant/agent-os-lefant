## Library Documentation Standard

This project maintains a comprehensive `LIBRARIES.md` file in the repository root that catalogs all major libraries used in the project.

### Purpose

The LIBRARIES.md file serves two key purposes:
1. **Quick reference** - Provides a centralized catalog of all major dependencies organized by category
2. **Context7 integration** - Enables AI assistants to efficiently fetch up-to-date, version-specific documentation using the Context7 MCP server

### Structure

The LIBRARIES.md file must include:

1. **Header section** explaining how to use Context7 for documentation lookup
2. **Core libraries organized by category** with the following information for each library:
   - Library name and version number
   - Context7 ID (e.g., `/facebook/react`, `/vercel/next.js`)
   - Usage description (what the library is used for in this project)
   - Key topics to reference when looking up documentation

3. **Workflow examples** showing common documentation lookup patterns
4. **Maintenance notes** reminding developers to keep the file in sync with package.json/requirements.txt

### Categories

Libraries should be organized into logical categories based on the project's tech stack. Common categories include:

- **Frontend Framework & Core** - React, Next.js, TypeScript, etc.
- **Authentication & Integration** - Auth libraries, API integrations
- **AI & Observability** - OpenAI SDK, Langfuse, monitoring tools
- **Data & State Management** - Validation libraries, databases, caching
- **Styling & UI Components** - CSS frameworks, component libraries, icons
- **Testing** - Test frameworks, assertion libraries, E2E tools
- **Backend** - API frameworks, servers, database ORMs (if applicable)
- **Specialized Libraries** - Domain-specific tools unique to the project

### Maintenance Requirements

**When adding a new dependency:**
1. Add it to the appropriate category in LIBRARIES.md
2. Include the version number from package.json or requirements.txt
3. Determine the Context7 ID (usually `/org/repo-name`)
4. Document its primary usage and key topics
5. Keep entries concise but informative

**When updating a dependency:**
1. Update the version number in LIBRARIES.md
2. Review the usage and key topics to ensure they're still accurate

**When removing a dependency:**
1. Remove its entry from LIBRARIES.md
2. Ensure no workflow examples reference the removed library

### Context7 Usage Guidance

The `context7-library-docs` skill (invoke with `Skill` tool) provides access to the Context7 MCP server for fetching library documentation. When working with unfamiliar library APIs or implementing features using project dependencies:

1. Use the skill to access Context7 tools for documentation lookup
2. Refer to LIBRARIES.md for the correct Context7 ID
3. Fetch documentation for the specific topic or feature you need
4. Consult version-specific docs to ensure compatibility

### Example Entry Format

```markdown
#### Library Name (vX.Y.Z)
- **Context7 ID**: `/org/repo-name`
- **Usage**: Brief description of how we use this library
- **Key topics**: topic1, topic2, topic3, important features
- **Note**: (Optional) Any project-specific usage patterns or important details
```

### Best Practices

- **Be specific about usage** - Don't just copy the library's tagline; explain how THIS project uses it
- **Update proactively** - Keep LIBRARIES.md in sync with dependency changes
- **Include project-specific patterns** - If the project uses a library in a non-standard way, document it
- **Verify Context7 IDs** - Test that the Context7 ID works before committing
- **Keep it scannable** - Use clear headers and consistent formatting for easy navigation
- **Document integration patterns** - Include workflow examples for complex multi-library integrations (e.g., Composio + Notion MCP)
