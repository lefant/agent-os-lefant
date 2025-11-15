# Agent OS - Spec-Driven Agentic Development System

## Introduction

Agent OS is an open-source system designed to transform AI coding agents from confused interns into productive developers through structured, spec-driven workflows. Created by Brian Casel at Builder Methods, this system provides a comprehensive framework for capturing coding standards, tech stack preferences, and project-specific requirements that enable AI agents like Claude Code, Cursor, and Windsurf to generate high-quality code on the first attempt. The system operates on a fundamental principle: AI agents work better with detailed specifications and structured guidance rather than vague instructions.

The architecture consists of modular profiles containing agent definitions, command workflows, coding standards, and implementation workflows that can be installed into any project regardless of language or framework. Agent OS supports both single-agent and multi-agent orchestration modes, allowing developers to choose between simple implementation workflows or complex multi-agent coordination with specialized subagents for planning, specification writing, verification, and implementation. The system includes six development phases—product planning, spec shaping, spec writing, task creation, task implementation, and task orchestration—providing a complete lifecycle from product concept to deployed features.

---

## Base Installation

### Install Agent OS to Home Directory

```bash
# One-line installation - installs to ~/agent-os/
curl -sSL https://raw.githubusercontent.com/buildermethods/agent-os/main/scripts/base-install.sh | bash
```

**What it does:**
- Downloads latest version from GitHub repository
- Installs to `~/agent-os/` directory
- Creates `~/agent-os/config.yml` with default settings
- Downloads profiles, scripts, and workflows
- Excludes `.git`, `.github`, and `old-versions` directories

**Update existing installation:**

```bash
# Interactively choose update type
curl -sSL https://raw.githubusercontent.com/buildermethods/agent-os/main/scripts/base-install.sh | bash

# Options presented:
# 1. Full update (all files)
# 2. Update profiles only
# 3. Update scripts only
# 4. Update config.yml only
# 5. Fresh reinstall (deletes ~/agent-os first)
```

**Dry-run mode:**

```bash
# Preview changes without applying them
curl -sSL https://raw.githubusercontent.com/buildermethods/agent-os/main/scripts/base-install.sh | bash -s -- --dry-run
```

---

## Project Installation

### Install Agent OS into a Project

```bash
# Navigate to your project
cd /path/to/my-project

# Install with default settings from ~/agent-os/config.yml
~/agent-os/scripts/project-install.sh

# Example output:
# === Installing Agent OS ===
#
# Profile: default
# Claude Code commands: true
# Claude Code subagents: true
# Agent OS commands: false
# Standards as Skills: false
#
# ✓ Created agent-os/config.yml
# ✓ Installed 14 standards files
# ✓ Installed 7 commands in .claude/commands/agent-os/
# ✓ Installed 8 agents in .claude/agents/agent-os/
#
# Installation complete!
```

**Project structure created:**

```
my-project/
├── agent-os/
│   ├── config.yml              # Project-specific configuration
│   ├── standards/              # Coding standards (14 files)
│   │   ├── global/
│   │   ├── backend/
│   │   ├── frontend/
│   │   └── testing/
│   ├── product/                # Created by /plan-product command
│   │   ├── mission.md
│   │   ├── roadmap.md
│   │   └── tech-stack.md
│   └── specs/                  # Created by /write-spec command
│       └── feature-name/
│           ├── spec.md
│           └── tasks.md
├── .claude/
│   ├── commands/
│   │   └── agent-os/          # 7 command workflows
│   │       ├── plan-product.md
│   │       ├── shape-spec.md
│   │       ├── write-spec.md
│   │       ├── create-tasks.md
│   │       ├── implement-tasks.md
│   │       ├── orchestrate-tasks.md
│   │       └── improve-skills.md
│   └── agents/
│       └── agent-os/          # 8 specialized agents
│           ├── implementer.md
│           ├── implementation-verifier.md
│           ├── product-planner.md
│           ├── spec-initializer.md
│           ├── spec-shaper.md
│           ├── spec-verifier.md
│           ├── spec-writer.md
│           └── tasks-list-creator.md
└── [your project code...]
```

---

## Configuration System

### Base Configuration File

```yaml
# ~/agent-os/config.yml
version: 2.1.1
base_install: true

# Do you use Claude Code?
# Installs commands in .claude/commands/agent-os/ folder
claude_code_commands: true

# Do you use other coding tools (Cursor, Windsurf)?
# Installs commands in agent-os/commands/ folder
agent_os_commands: false

# Should Claude Code use subagents?
# Enables multi-agent delegation with specialized agents
# Requires claude_code_commands: true
use_claude_code_subagents: true

# Should standards be provided as Claude Code Skills?
# true: Uses Skills feature for standards
# false: Injects standards as file references in prompts
standards_as_claude_code_skills: false

# Default profile to use
profile: default
```

**Override defaults during installation:**

```bash
# Install with custom profile
~/agent-os/scripts/project-install.sh --profile rails

# Disable subagents for single-agent mode
~/agent-os/scripts/project-install.sh --use-claude-code-subagents false

# Install for Cursor/Windsurf (not Claude Code)
~/agent-os/scripts/project-install.sh \
  --claude-code-commands false \
  --agent-os-commands true

# Use Claude Code Skills for standards
~/agent-os/scripts/project-install.sh --standards-as-claude-code-skills true

# Combine multiple options
~/agent-os/scripts/project-install.sh \
  --profile nextjs \
  --use-claude-code-subagents true \
  --standards-as-claude-code-skills false \
  --dry-run
```

---

## Project Update

### Update Existing Project Installation

```bash
cd /path/to/my-project

# Running project-install.sh automatically detects existing installation
# and delegates to project-update.sh
~/agent-os/scripts/project-install.sh

# Example interactive flow:
#
# === Agent OS Update ===
#
# Current version: 2.0.5
# New version: 2.1.1
#
# This will:
# ✓ Preserve agent-os/specs/ and agent-os/product/
# ✓ Update standards, commands, and agents
# ✓ Update configuration to v2.1.1
#
# Proceed with update? (yes/no): yes
#
# ✓ Updated 14 standards files
# ✓ Updated 7 commands
# ✓ Updated 8 agents
# ✓ Updated config.yml
#
# Update complete!
```

**Update with overwrite options:**

```bash
# Overwrite all existing files during update
~/agent-os/scripts/project-install.sh --overwrite-all

# Overwrite only standards files
~/agent-os/scripts/project-install.sh --overwrite-standards

# Overwrite only commands
~/agent-os/scripts/project-install.sh --overwrite-commands

# Overwrite only agents
~/agent-os/scripts/project-install.sh --overwrite-agents

# Preview update without applying
~/agent-os/scripts/project-install.sh --dry-run --verbose
```

**Full reinstallation:**

```bash
# Delete and reinstall Agent OS in project
~/agent-os/scripts/project-install.sh --re-install

# Dry-run reinstall to preview
~/agent-os/scripts/project-install.sh --re-install --dry-run
```

---

## Development Workflow Commands

### Phase 1: Plan Product

```bash
# In Claude Code chat, run:
/plan-product

# Agent prompts for:
# - Product vision and purpose
# - Target users and problems solved
# - Key features list
# - Tech stack choices

# Creates three files:
# ✅ agent-os/product/mission.md
# ✅ agent-os/product/roadmap.md
# ✅ agent-os/product/tech-stack.md

# Example mission.md structure:
## Product Vision
[Concise description of product purpose]

## Target Users
[User personas and their problems]

## Core Features
- Feature 1: [description]
- Feature 2: [description]

## Success Metrics
[How success is measured]
```

---

### Phase 2: Shape Spec

```bash
# Research and refine a feature specification
/shape-spec

# Agent asks:
# - Feature name
# - Feature description or requirements
# - Any research needed (APIs, libraries, patterns)

# Workflow:
# 1. spec-shaper agent researches the feature
# 2. Gathers information from docs, examples, best practices
# 3. Creates agent-os/specs/[feature-name]/shaped-spec.md
# 4. Presents findings and recommendations

# Example shaped-spec.md:
## Feature: User Authentication

### Research Findings
- Recommended: NextAuth.js v5 for Next.js projects
- Database: Prisma adapter for session storage
- Providers: Google OAuth, GitHub OAuth

### Architecture Recommendations
[Detailed recommendations based on research]

### Implementation Considerations
[Gotchas, edge cases, security considerations]

### Next Steps
Ready to write full specification
```

---

### Phase 3: Write Spec

```bash
# Create detailed feature specification
/write-spec [feature-name]

# Example:
/write-spec user-authentication

# Agent workflow:
# 1. spec-initializer creates spec.md template in agent-os/specs/user-authentication/
# 2. spec-writer populates detailed specification
# 3. spec-verifier checks completeness
# 4. Final spec.md includes:

## Feature: User Authentication

### Overview
[Comprehensive feature description]

### User Stories
- As a [user type], I want [action] so that [benefit]

### Technical Requirements
#### Frontend
- Login form with email/password validation
- Social auth buttons (Google, GitHub)
- Session persistence with cookies

#### Backend
- NextAuth.js configuration
- Prisma schema for users and sessions
- OAuth provider setup

#### Database
[Schema definitions]

### API Endpoints
POST /api/auth/signin
POST /api/auth/signout
GET /api/auth/session

### Security Considerations
[Authentication flow, token handling, CSRF protection]

### Testing Requirements
[Unit tests, integration tests, E2E tests]

### Acceptance Criteria
✓ User can sign in with email/password
✓ User can sign in with Google OAuth
✓ User can sign out
✓ Session persists across page refreshes
```

---

### Phase 4: Create Tasks

```bash
# Break specification into actionable tasks
/create-tasks [feature-name]

# Example:
/create-tasks user-authentication

# Agent workflow:
# 1. Reads agent-os/specs/user-authentication/spec.md
# 2. tasks-list-creator breaks down into ordered tasks
# 3. Creates agent-os/specs/user-authentication/tasks.md

# Example tasks.md:
## Implementation Tasks for User Authentication

### 1. Database Setup
- [ ] 1.1 Create Prisma schema for User model
- [ ] 1.2 Create Prisma schema for Session model
- [ ] 1.3 Create migration files
- [ ] 1.4 Run migrations

### 2. Backend Implementation
- [ ] 2.1 Install NextAuth.js dependencies
- [ ] 2.2 Create auth configuration file
- [ ] 2.3 Configure Google OAuth provider
- [ ] 2.4 Configure GitHub OAuth provider
- [ ] 2.5 Set up Prisma adapter

### 3. Frontend Implementation
- [ ] 3.1 Create login form component
- [ ] 3.2 Create OAuth button components
- [ ] 3.3 Add session provider to app
- [ ] 3.4 Create protected route wrapper

### 4. Testing
- [ ] 4.1 Unit tests for auth utilities
- [ ] 4.2 Integration tests for auth endpoints
- [ ] 4.3 E2E tests for login flow

### 5. Documentation
- [ ] 5.1 Document environment variables
- [ ] 5.2 Document OAuth setup process
```

---

### Phase 5: Implement Tasks

```bash
# Simple single-agent implementation
/implement-tasks [feature-name]

# Example:
/implement-tasks user-authentication

# Agent workflow:
# 1. Reads spec.md and tasks.md
# 2. implementer agent executes each task sequentially
# 3. implementation-verifier checks each completed task
# 4. Updates tasks.md marking completed items

# During implementation:
✓ 1.1 Create Prisma schema for User model
  Created prisma/schema.prisma with User model

✓ 1.2 Create Prisma schema for Session model
  Added Session model to schema.prisma

⧗ 1.3 Create migration files
  Running: npx prisma migrate dev --name add-auth

# After completion:
All tasks completed! Summary:
✅ 15 tasks completed
✅ All tests passing
✅ No errors or warnings
```

---

### Phase 6: Orchestrate Tasks

```bash
# Advanced multi-agent orchestration for complex features
/orchestrate-tasks [feature-name]

# Example:
/orchestrate-tasks user-authentication

# Agent workflow:
# 1. Main orchestrator reviews spec.md and tasks.md
# 2. Delegates tasks to specialized implementer agents
# 3. Coordinates dependencies between tasks
# 4. Runs verifiers to check completed work
# 5. Handles errors and retries

# Advanced orchestration features:
# - Parallel task execution where possible
# - Dependency-aware task ordering
# - Automatic error recovery
# - Cross-task validation
# - Progress reporting

# Example output:
Starting orchestration for user-authentication

Phase 1: Database Setup (4 tasks)
  ⧗ Delegating to database-implementer...
  ✓ 1.1-1.4 completed in 2m 15s

Phase 2: Backend Implementation (5 tasks)
  ⧗ Delegating to backend-implementer...
  ✓ 2.1-2.5 completed in 4m 30s

Phase 3: Frontend Implementation (4 tasks)
  ⧗ Delegating to frontend-implementer...
  ✓ 3.1-3.4 completed in 3m 45s

Phase 4: Testing (3 tasks)
  ⧗ Delegating to test-implementer...
  ⚠️  4.2 failed - integration test error
  ⧗ Retrying with error context...
  ✓ 4.2 completed on retry
  ✓ 4.1-4.3 completed in 5m 20s

Phase 5: Documentation (2 tasks)
  ⧗ Delegating to docs-implementer...
  ✓ 5.1-5.2 completed in 1m 10s

Orchestration complete!
✅ Total time: 16m 60s
✅ 18 tasks completed
✅ 1 retry successful
```

---

## Custom Profile Creation

### Create New Profile

```bash
# Interactive profile creation
~/agent-os/scripts/create-profile.sh

# Interactive prompts:
# Enter profile name: rails-api
#
# Choose option:
# 1. Create from scratch
# 2. Inherit from existing profile
# 3. Copy from existing profile
#
# Selection: 2
#
# Choose base profile:
# 1. default
#
# Selection: 1
#
# ✓ Created profiles/rails-api/
# ✓ Created profile-config.yml
#
# Profile created at: ~/agent-os/profiles/rails-api/

# Profile structure:
profiles/rails-api/
├── profile-config.yml
├── agents/              # Add custom agents here
├── commands/            # Add custom commands here
├── standards/           # Add custom standards here
│   ├── backend/
│   │   └── rails-conventions.md
│   └── testing/
│       └── rspec-patterns.md
└── workflows/           # Add custom workflows here
```

**Profile inheritance configuration:**

```yaml
# profiles/rails-api/profile-config.yml
name: rails-api
description: Ruby on Rails API-only applications

# Inherit from default profile
inherits: default

# Exclude inherited files (override with custom versions)
exclude:
  - standards/backend/api.md           # Use custom Rails API standards
  - standards/backend/database.md      # Use custom ActiveRecord standards
  - agents/implementer.md              # Use custom Rails-aware implementer
```

**Use custom profile:**

```bash
cd /path/to/rails-project

# Install with custom profile
~/agent-os/scripts/project-install.sh --profile rails-api

# Updates base config default:
nano ~/agent-os/config.yml
# Change: profile: default
# To:     profile: rails-api
```

---

## Template Compilation System

### Workflow References

```markdown
# In agent or command file:

{{workflows/implementation/implement-tasks}}

# Expands to the entire content of:
# profiles/default/workflows/implementation/implement-tasks.md

# Nested references work recursively:
{{workflows/shared/verify-implementation}}
# If that file contains: {{workflows/shared/run-tests}}
# Both are expanded during compilation
```

**Example usage in agent definition:**

```markdown
---
name: implementer
description: Implements tasks from specification
tools: Write, Edit, Read, Bash
---

You are a full-stack developer implementing tasks.

{{workflows/implementation/implement-tasks}}

## Guidelines
[Additional agent-specific guidelines]
```

---

### Standards References

```markdown
# Reference all standards:
{{standards/*}}

# Expands to list of all standards files:
- agent-os/standards/global/coding-style.md
- agent-os/standards/global/conventions.md
- agent-os/standards/global/commenting.md
- agent-os/standards/global/error-handling.md
- agent-os/standards/global/validation.md
- agent-os/standards/backend/api.md
- agent-os/standards/backend/database.md
- agent-os/standards/backend/authentication.md
- agent-os/standards/backend/testing.md
- agent-os/standards/frontend/components.md
- agent-os/standards/frontend/state-management.md
- agent-os/standards/frontend/styling.md
- agent-os/standards/frontend/routing.md
- agent-os/standards/testing/unit-tests.md

# Reference specific standard:
{{standards/backend/api.md}}

# Reference standards by directory:
{{standards/global/*}}
{{standards/backend/*}}
```

---

### Conditional Compilation

```markdown
# Include content only if flag is enabled:
{{IF use_claude_code_subagents}}
Delegate this task to the **implementer** subagent.
{{ENDIF use_claude_code_subagents}}

# Include content only if flag is disabled:
{{UNLESS standards_as_claude_code_skills}}
Read the following standards files:
{{standards/*}}
{{ENDUNLESS standards_as_claude_code_skills}}

# Nested conditionals:
{{IF claude_code_commands}}
Install Claude Code commands.

{{IF use_claude_code_subagents}}
Also install agent definitions for delegation.
{{ENDIF use_claude_code_subagents}}
{{ENDIF claude_code_commands}}
```

**Available conditional flags:**

```bash
# These match config.yml options:
- claude_code_commands
- agent_os_commands
- use_claude_code_subagents
- standards_as_claude_code_skills
```

---

### Phase Tag Embedding

```markdown
# In single-agent command files (when subagents disabled):

{{PHASE 1: agent-os/commands/write-spec/1-initialize-spec.md}}
{{PHASE 2: agent-os/commands/write-spec/2-write-specification.md}}
{{PHASE 3: agent-os/commands/write-spec/3-verify-specification.md}}

# Compiles to:

# Phase 1: Initialize Spec
[Entire content of 1-initialize-spec.md]

# Phase 2: Write Specification
[Entire content of 2-write-specification.md]

# Phase 3: Verify Specification
[Entire content of 3-verify-specification.md]
```

**Example compiled output:**

```markdown
## Write Specification Process

# Phase 1: Initialize Spec

Create the specification directory and template file.

1. Create directory: agent-os/specs/[feature-name]/
2. Create file: agent-os/specs/[feature-name]/spec.md
3. Add template sections:
   - Overview
   - User Stories
   - Technical Requirements
   [...]

# Phase 2: Write Specification

Populate the specification with detailed information.

1. Write comprehensive overview
2. Define user stories with acceptance criteria
3. Document technical requirements by layer
[...]
```

---

## Common Functions API

### YAML Parsing Functions

```bash
# Source common functions library
source ~/agent-os/scripts/common-functions.sh

# Get simple key-value from YAML
get_yaml_value "config.yml" "version" "default-value"
# Returns: 2.1.1

# Get array items from YAML
get_yaml_array "profile-config.yml" "exclude"
# Returns (one per line):
# standards/backend/api.md
# agents/implementer.md

# Example usage in script:
VERSION=$(get_yaml_value "$BASE_DIR/config.yml" "version" "unknown")
echo "Version: $VERSION"

PROFILE=$(get_yaml_value "$BASE_DIR/config.yml" "profile" "default")
echo "Using profile: $PROFILE"

# Read boolean flag
USE_SUBAGENTS=$(get_yaml_value "$BASE_DIR/config.yml" "use_claude_code_subagents" "true")
if [[ "$USE_SUBAGENTS" == "true" ]]; then
    echo "Subagents enabled"
fi
```

---

### Output Functions

```bash
# Print colored status messages
print_status "Installing Agent OS..."
# Output: [blue] Installing Agent OS...

print_success "Installation complete!"
# Output: [green] ✓ Installation complete!

print_warning "Configuration not found"
# Output: [yellow] ⚠️  Configuration not found

print_error "Failed to download file"
# Output: [red] ✗ Failed to download file

print_verbose "Detailed debugging info"
# Output: [VERBOSE] Detailed debugging info
# (only shows when VERBOSE=true)

# Print section headers
print_section "Configuration"
# Output:
#
# [blue] === Configuration ===
#

# Example script usage:
print_section "Installation"
print_status "Downloading files..."

if download_files; then
    print_success "Files downloaded"
else
    print_error "Download failed"
    exit 1
fi
```

---

### File Operation Functions

```bash
# Copy file with dry-run support
copy_file_if_needed "source.txt" "dest.txt" "false"
# Parameters: source, destination, overwrite
# Respects DRY_RUN global variable

# Write file with dry-run support
write_file "path/to/file.txt" "content here"
# Respects DRY_RUN global variable

# Example in project installation:
STANDARDS_SOURCE="$BASE_DIR/profiles/$PROFILE/standards"
STANDARDS_DEST="$PROJECT_DIR/agent-os/standards"

print_status "Installing standards..."
copy_recursive "$STANDARDS_SOURCE" "$STANDARDS_DEST"

if [[ "$DRY_RUN" == "true" ]]; then
    print_warning "DRY RUN - no files actually copied"
else
    print_success "Standards installed"
fi
```

---

### Profile Management Functions

```bash
# Get profile file with inheritance
get_profile_file "$PROFILE" "agents/implementer.md"
# Returns: Path to file (checks profile, then inherited profiles)

# Get all profile files with exclusions
get_profile_files "$PROFILE" "standards" "md"
# Returns: All .md files in standards/, respecting exclusions

# Example usage:
PROFILE="rails-api"

# Get implementer agent (may come from inherited profile)
AGENT_FILE=$(get_profile_file "$PROFILE" "agents/implementer.md")
if [[ -n "$AGENT_FILE" ]]; then
    echo "Found agent at: $AGENT_FILE"
    copy_file_if_needed "$AGENT_FILE" ".claude/agents/implementer.md" "false"
fi

# Get all standards files (excluding overridden ones)
while IFS= read -r standard_file; do
    echo "Processing: $standard_file"
    # Install to project...
done < <(get_profile_files "$PROFILE" "standards" "md")
```

---

### Template Processing Functions

```bash
# Process conditional tags in file
process_conditionals "input.md" "output.md"
# Evaluates {{IF}}/{{UNLESS}} based on config flags

# Process workflow references
process_workflows "input.md" "output.md" "$PROFILE"
# Expands {{workflows/path}} references

# Process standards references
process_standards "input.md" "output.md" "$PROFILE"
# Expands {{standards/*}} references

# Process PHASE tags
process_phase_tags "input.md" "output.md" "$PROFILE"
# Embeds {{PHASE N: path}} content

# Full compilation (all processing steps):
compile_agent "$PROFILE" "agents/implementer.md" "output/implementer.md"
compile_command "$PROFILE" "commands/write-spec/write-spec.md" "output/write-spec.md"

# Example compilation script:
SOURCE_FILE="$BASE_DIR/profiles/$PROFILE/agents/spec-writer.md"
DEST_FILE="$PROJECT_DIR/.claude/agents/agent-os/spec-writer.md"

print_status "Compiling spec-writer agent..."
compile_agent "$PROFILE" "agents/spec-writer.md" "$DEST_FILE"

if [[ $? -eq 0 ]]; then
    print_success "Agent compiled successfully"
else
    print_error "Compilation failed"
    exit 1
fi
```

---

### Installation Functions

```bash
# Install standards to project
install_standards "$PROFILE" "$PROJECT_DIR" "false"
# Parameters: profile, project_dir, overwrite

# Install Claude Code commands with delegation
install_claude_code_commands_with_delegation "$PROFILE" "$PROJECT_DIR"
# Creates multi-agent commands that delegate to subagents

# Install Claude Code commands without delegation
install_claude_code_commands_without_delegation "$PROFILE" "$PROJECT_DIR"
# Creates single-agent commands with embedded phases

# Install agent definitions
install_claude_code_agents "$PROFILE" "$PROJECT_DIR"
# Copies agents to .claude/agents/agent-os/

# Install agent-os commands folder
install_agent_os_commands "$PROFILE" "$PROJECT_DIR"
# For Cursor, Windsurf, etc.

# Install Claude Code Skills
install_claude_code_skills "$PROFILE" "$PROJECT_DIR"
# Converts standards to Skills format

# Example installation script:
PROFILE=$(get_yaml_value "$BASE_DIR/config.yml" "profile" "default")
PROJECT_DIR=$(pwd)

print_section "Installing Agent OS"

install_standards "$PROFILE" "$PROJECT_DIR" "$OVERWRITE_STANDARDS"
install_claude_code_commands_with_delegation "$PROFILE" "$PROJECT_DIR"
install_claude_code_agents "$PROFILE" "$PROJECT_DIR"

print_success "Installation complete!"
```

---

## Agent Definitions

### Product Planner Agent

```markdown
---
name: product-planner
description: Establishes product mission, roadmap, and tech stack
tools: Write, Read, Bash, WebFetch
---

# Product Planning Process

1. **Gather Information**
   - Product vision and purpose
   - Target users and problems solved
   - Key features list
   - Tech stack preferences

2. **Create Mission Document**
   - Concise product vision
   - Target user personas
   - Core feature set
   - Success metrics
   - Save to: agent-os/product/mission.md

3. **Create Roadmap**
   - Phase 1: MVP features
   - Phase 2: Enhancement features
   - Phase 3: Advanced features
   - Timeline estimates
   - Save to: agent-os/product/roadmap.md

4. **Document Tech Stack**
   - Frontend framework and libraries
   - Backend framework and runtime
   - Database and ORM
   - Authentication and authorization
   - Testing frameworks
   - Deployment platform
   - Save to: agent-os/product/tech-stack.md
```

---

### Spec Shaper Agent

```markdown
---
name: spec-shaper
description: Researches and refines feature specifications
tools: Read, WebFetch, Bash
---

# Specification Shaping Process

1. **Research Phase**
   - Search documentation for best practices
   - Find example implementations
   - Identify recommended libraries/tools
   - Discover potential gotchas

2. **Analysis Phase**
   - Evaluate architecture options
   - Consider scalability implications
   - Assess security requirements
   - Identify testing needs

3. **Recommendations**
   - Recommend specific tools/libraries with versions
   - Suggest architecture patterns
   - Highlight edge cases to handle
   - Provide code examples from research

4. **Output**
   - Create: agent-os/specs/[feature]/shaped-spec.md
   - Include all research findings
   - Provide clear next steps for spec-writer
```

---

### Spec Writer Agent

```markdown
---
name: spec-writer
description: Creates detailed, comprehensive specifications
tools: Write, Read, Bash
---

# Specification Writing Process

1. **Initialize Structure**
   - Create agent-os/specs/[feature]/spec.md
   - Add standard sections:
     - Overview
     - User Stories
     - Technical Requirements (Frontend/Backend/Database)
     - API Endpoints
     - Security Considerations
     - Testing Requirements
     - Acceptance Criteria

2. **Populate Details**
   - Write comprehensive overview
   - Define user stories with acceptance criteria
   - Document technical requirements by layer
   - Specify exact API endpoints with examples
   - Detail security measures
   - List all test scenarios

3. **Apply Standards**
   - Ensure alignment with tech stack
   - Follow coding conventions from standards
   - Use project-specific patterns
   - Reference: agent-os/standards/*

4. **Verification**
   - Spec is complete and unambiguous
   - All requirements are testable
   - No conflicting requirements
   - Ready for implementation
```

---

### Tasks List Creator Agent

```markdown
---
name: tasks-list-creator
description: Breaks specifications into actionable tasks
tools: Write, Read
---

# Task Creation Process

1. **Read Specification**
   - Load agent-os/specs/[feature]/spec.md
   - Identify all requirements
   - Note dependencies between requirements

2. **Break Down into Tasks**
   - Group related work into phases
   - Create granular, actionable tasks
   - Order by dependencies
   - Estimate complexity

3. **Task Structure**
   - Phase name
   - Numbered tasks with checkboxes
   - Sub-tasks where needed
   - Dependencies noted

4. **Output Format**
   ## Implementation Tasks for [Feature]

   ### 1. [Phase Name]
   - [ ] 1.1 [Task description]
   - [ ] 1.2 [Task description]

   ### 2. [Phase Name]
   - [ ] 2.1 [Task description]
     - [ ] 2.1.1 [Sub-task]
     - [ ] 2.1.2 [Sub-task]

5. **Save**
   - Create: agent-os/specs/[feature]/tasks.md
```

---

### Implementer Agent

```markdown
---
name: implementer
description: Full-stack developer implementing tasks
tools: Write, Edit, Read, Bash, Grep, Glob
---

# Implementation Process

1. **Read Requirements**
   - Load spec.md
   - Load tasks.md
   - Identify current task

2. **Implement Task**
   - Write/modify code files
   - Follow coding standards
   - Apply best practices
   - Handle error cases

3. **Test Implementation**
   - Run relevant tests
   - Verify functionality works
   - Check for regressions
   - Fix any issues

4. **Update Progress**
   - Mark task as completed in tasks.md
   - Note any implementation decisions
   - Document any deviations from spec

5. **Move to Next Task**
   - Repeat until all tasks completed
```

---

### Implementation Verifier Agent

```markdown
---
name: implementation-verifier
description: Verifies implementations meet requirements
tools: Read, Bash, Grep
---

# Verification Process

1. **Review Implementation**
   - Check implemented code
   - Compare against spec requirements
   - Verify all acceptance criteria met

2. **Run Tests**
   - Execute unit tests
   - Execute integration tests
   - Execute E2E tests if applicable
   - Verify all tests pass

3. **Check Standards Compliance**
   - Verify coding style followed
   - Check error handling present
   - Ensure proper commenting
   - Validate security measures

4. **Report Findings**
   - List completed requirements
   - Note any issues found
   - Suggest fixes if needed
   - Approve or request changes
```

---

## Claude Code Skills Integration

### Enable Skills for Standards

```bash
# Install with Skills enabled
cd /path/to/project
~/agent-os/scripts/project-install.sh --standards-as-claude-code-skills true

# Creates:
.claude/skills/
├── coding-style/
│   └── SKILL.md
├── conventions/
│   └── SKILL.md
├── commenting/
│   └── SKILL.md
├── error-handling/
│   └── SKILL.md
├── validation/
│   └── SKILL.md
├── api-standards/
│   └── SKILL.md
├── database-standards/
│   └── SKILL.md
└── [... all standards as individual skills]

# Each SKILL.md contains:
---
name: coding-style
description: Read this skill to understand the coding style standards for this project
priority: 5
---

[Content from agent-os/standards/global/coding-style.md]
```

**Benefits of Skills mode:**

```bash
# Traditional mode (standards_as_claude_code_skills: false):
# - Agent reads 14 standards files on every command
# - Standards embedded in command prompts
# - Higher token usage per request

# Skills mode (standards_as_claude_code_skills: true):
# - Claude Code loads skills on-demand
# - Agent requests specific skills when needed
# - Lower token usage
# - More scalable for large standard sets
```

**Improve skills descriptions:**

```bash
# In Claude Code chat:
/improve-skills

# Agent workflow:
# 1. Reads all SKILL.md files
# 2. Analyzes description quality
# 3. Suggests improvements for clarity
# 4. Offers to update descriptions
# 5. Tests improved descriptions

# Example improvements:
# Before: "Read this skill for API standards"
# After: "Provides RESTful API design patterns, endpoint naming conventions,
#         error response formats, and authentication requirements"
```

---

## Advanced Use Cases

### Multi-Repository Setup

```bash
# Install Agent OS base once
curl -sSL https://raw.githubusercontent.com/buildermethods/agent-os/main/scripts/base-install.sh | bash

# Configure default profile and settings
nano ~/agent-os/config.yml

# Install into multiple projects
cd ~/projects/frontend-app
~/agent-os/scripts/project-install.sh --profile nextjs

cd ~/projects/backend-api
~/agent-os/scripts/project-install.sh --profile rails-api

cd ~/projects/mobile-app
~/agent-os/scripts/project-install.sh --profile react-native

# All projects share base Agent OS installation
# Each uses appropriate profile
# Update base once to update all projects
```

---

### Profile Inheritance Example

```bash
# Create specialized profile inheriting from default
~/agent-os/scripts/create-profile.sh

# Profile name: nextjs-saas
# Inherits: default
# Created: ~/agent-os/profiles/nextjs-saas/

# Add custom standards:
nano ~/agent-os/profiles/nextjs-saas/standards/frontend/nextjs-patterns.md

# Content:
# Next.js SaaS Application Patterns
#
# ## App Router Structure
# - Use app/ directory for routes
# - Server Components by default
# - Client Components only when needed
# [...]

# Configure exclusions:
nano ~/agent-os/profiles/nextjs-saas/profile-config.yml

# Add:
exclude:
  - standards/frontend/components.md   # Override with nextjs-specific

# Create override:
nano ~/agent-os/profiles/nextjs-saas/standards/frontend/components.md

# Content:
# Next.js Component Patterns
# [Next.js specific component guidelines]

# Use profile:
cd ~/projects/my-saas
~/agent-os/scripts/project-install.sh --profile nextjs-saas

# Result:
# - Inherits all default standards except components.md
# - Uses custom nextjs-patterns.md
# - Uses custom components.md override
# - Inherits all default agents, commands, workflows
```

---

### Hybrid Mode (Multiple Tool Support)

```bash
# Install for both Claude Code AND Cursor/Windsurf
cd /path/to/project

~/agent-os/scripts/project-install.sh \
  --claude-code-commands true \
  --agent-os-commands true

# Creates both:
# - .claude/commands/agent-os/  (for Claude Code)
# - agent-os/commands/          (for Cursor/Windsurf)

# Team members can use different tools
# All share same standards and specifications
```

---

### Version Pinning for Stability

```yaml
# Pin project to specific Agent OS version
# Edit project's agent-os/config.yml:

version: 2.1.1
version_pinned: true

# When running update:
~/agent-os/scripts/project-install.sh

# Output:
# ⚠️  Project pinned to version 2.1.1
# ⚠️  Base installation is version 2.1.2
# ⚠️  Remove 'version_pinned: true' to update
#
# No changes made.

# To update:
nano agent-os/config.yml
# Remove: version_pinned: true

~/agent-os/scripts/project-install.sh
# Now updates to latest version
```

---

## Summary

Agent OS provides a comprehensive, production-ready system for spec-driven agentic development that works across any programming language, framework, or AI coding tool. The six-phase development workflow—from product planning through specification writing to orchestrated implementation—ensures AI agents have the detailed context and structured guidance needed to produce high-quality, maintainable code. The system eliminates the common problem of AI agents generating incorrect or inconsistent code by providing explicit coding standards, tech stack documentation, and proven implementation patterns before any code is written.

The modular architecture with profile inheritance, template compilation, and conditional features allows teams to customize Agent OS for their specific needs while maintaining a consistent foundation. Whether working on a solo project with single-agent workflows or coordinating complex features with multi-agent orchestration, Agent OS scales from simple bug fixes to full-stack feature implementations. The installation system with dry-run modes, comprehensive update mechanisms, and support for multiple AI coding tools (Claude Code, Cursor, Windsurf) makes it practical to adopt incrementally and adapt to evolving team practices. By transforming vague feature requests into detailed specifications with actionable tasks, Agent OS fundamentally changes how developers interact with AI coding agents—shifting from prompt engineering to systematic specification, resulting in faster development cycles and higher code quality.
