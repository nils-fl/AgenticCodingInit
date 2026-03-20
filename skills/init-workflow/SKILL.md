Initialize the full agentic workflow in this repository (or the directory given in `$ARGUMENTS` if provided). This sets up the `.ai/` folder, `CLAUDE.md` with the 4-persona workflow, `ARCHITECTURE.md`, and fills in dev commands. Idempotent — skips anything that already exists.

!`find . -maxdepth 2 \( -name "package.json" -o -name "pyproject.toml" -o -name "Cargo.toml" -o -name "go.mod" -o -name "Makefile" -o -name "justfile" -o -name "Gemfile" -o -name "mix.exs" \) -not -path "*/node_modules/*" 2>/dev/null`

## Instructions

### 0. Parse arguments and determine the target directory
Parse `$ARGUMENTS` as follows:
- If `$ARGUMENTS` contains the flag `--mermaid`, set **mermaid-mode = ON** and remove that token from the argument string before further processing.
- After removing any flags, if the remaining string is non-empty, treat it as the target path. All file operations below are relative to that path.
- Otherwise default to the current working directory (`.`).

Examples:
- `/init-workflow` → target = `.`, mermaid-mode = OFF
- `/init-workflow ../my-repo` → target = `../my-repo`, mermaid-mode = OFF
- `/init-workflow --mermaid` → target = `.`, mermaid-mode = ON
- `/init-workflow ../my-repo --mermaid` → target = `../my-repo`, mermaid-mode = ON

### 1. Create `.ai/` structure
Create the following files **only if they do not already exist**. Report `[SKIP] Exists: <path>` for any that do.

**`.ai/plan.md`**
```
# Implementation Plan

## Goal

## Tasks

## Progress

## Notes
```

**`.ai/context.md`**
```
# Project Context

## Architecture Notes

## Conventions

## Commands

## Known Constraints
```

**`.ai/repo-map.md`**
```
# Repository Map

## Backend

## Frontend

## Database

## Tests

## Commands
<!-- Discover from project config files (package.json, Makefile, pyproject.toml, Cargo.toml, etc.) -->
- test:
- lint:
- typecheck:
```

Also create the directories `.ai/tasks/` and `.ai/tasks-done/` if they do not exist.

### 2. Create/update `CLAUDE.md`
Check whether `CLAUDE.md` exists and whether it already contains the marker `## Claude Code Workflow`.

- **If `CLAUDE.md` does not exist**, create it with the full starter template below.
- **If `CLAUDE.md` exists but does NOT contain `## Claude Code Workflow`**, append the workflow section to the end of the file.
- **If `CLAUDE.md` already contains `## Claude Code Workflow`**, report `[SKIP] Workflow already present in CLAUDE.md`.

**Full starter template (use when creating from scratch):**
```
# Project Instructions

Add project-specific coding conventions, architecture rules, and important commands here.

## Development Commands

Run tests:

Run linter:

Run type checks:

## Claude Code Workflow

You are orchestrating a small AI development team.

### Planner
- Analyze the repository and create an implementation plan.
- Write the plan to `.ai/plan.md`.
- Break work into task files in `.ai/tasks/`.
- **Crucial:** Name task files with a timestamp prefix format `YYYYMMDD-HHMM-` (e.g., `YYYYMMDD-HHMM-setup-db.md`) to avoid numbering collisions.
- Do not implement code during planning.

### Coder
- Implement exactly one task at a time.
- Modify only files required for the current task.
- Avoid re-scanning the entire repository unless necessary.

### Tester
- Run the relevant verification steps:
  - tests
  - lint
  - type checks
- Report failures clearly.

### Reviewer
- Review the diff and improve correctness and code quality.

### Workflow
1. Planner writes `.ai/plan.md`
2. Planner creates `.ai/tasks/YYYYMMDD-HHMM-*.md`
3. Coder implements ONE task
4. Tester verifies
5. Reviewer checks changes
6. Move completed tasks from `.ai/tasks/` to `.ai/tasks-done/`
7. Stop after each task

Never execute the entire feature in a single loop.

### Repository Context
- Use `.ai/repo-map.md` as the primary reference for project structure.
- Avoid scanning the entire repository unless needed.
- If new files or modules are added, update `.ai/repo-map.md`.
- Use `ARCHITECTURE.md` as the reference for architectural decisions and system design.
- When the architecture changes, update `ARCHITECTURE.md` accordingly.
- On first interaction with a new repo, discover development commands (test, lint, typecheck) from project config files and fill in the Development Commands section if empty.
```

**Workflow section only (use when appending to an existing file):**
```
## Claude Code Workflow

You are orchestrating a small AI development team.

### Planner
- Analyze the repository and create an implementation plan.
- Write the plan to `.ai/plan.md`.
- Break work into task files in `.ai/tasks/`.
- **Crucial:** Name task files with a timestamp prefix format `YYYYMMDD-HHMM-` (e.g., `YYYYMMDD-HHMM-setup-db.md`) to avoid numbering collisions.
- Do not implement code during planning.

### Coder
- Implement exactly one task at a time.
- Modify only files required for the current task.
- Avoid re-scanning the entire repository unless necessary.

### Tester
- Run the relevant verification steps:
  - tests
  - lint
  - type checks
- Report failures clearly.

### Reviewer
- Review the diff and improve correctness and code quality.

### Workflow
1. Planner writes `.ai/plan.md`
2. Planner creates `.ai/tasks/YYYYMMDD-HHMM-*.md`
3. Coder implements ONE task
4. Tester verifies
5. Reviewer checks changes
6. Move completed tasks from `.ai/tasks/` to `.ai/tasks-done/`
7. Stop after each task

Never execute the entire feature in a single loop.

### Repository Context
- Use `.ai/repo-map.md` as the primary reference for project structure.
- Avoid scanning the entire repository unless needed.
- If new files or modules are added, update `.ai/repo-map.md`.
- Use `ARCHITECTURE.md` as the reference for architectural decisions and system design.
- When the architecture changes, update `ARCHITECTURE.md` accordingly.
- On first interaction with a new repo, discover development commands (test, lint, typecheck) from project config files and fill in the Development Commands section if empty.
```

### 3. Create `ARCHITECTURE.md` if missing
If `ARCHITECTURE.md` does not exist, create it with the template below. Otherwise report `[SKIP] Exists: ARCHITECTURE.md`.

```
# Architecture

## Overview
<!-- High-level description of the application/repository.
     What does it do? What problem does it solve?
     What are the major components and how do they relate to each other? -->

## Details
<!-- Very technical, very detailed architectural documentation.

     Suggested topics to cover:
     - System components and module boundaries
     - Data flow and control flow
     - Key abstractions and design patterns
     - Storage and persistence layer
     - API surface and protocols
     - External dependencies and integrations
     - Deployment topology and infrastructure
     - Security model and authentication/authorization
     - Error handling and resilience patterns
     - Performance characteristics and scaling considerations
     - Important design decisions, trade-offs, and their rationale -->
```

### 3b. Create Mermaid diagram files (mermaid-mode only)
Skip this step entirely if mermaid-mode is OFF.

If mermaid-mode is ON, create the following files **only if they do not already exist**. Report `[SKIP] Exists: <path>` for any that do.

**`ARCHITECTURE_OVERVIEW.mmd`**
```
%%{init: {'theme': 'default'}}%%
graph TD
    %% High-level component diagram — edit to reflect your system
    Client["Client / Frontend"]
    Backend["Backend / API"]
    DB["Database"]

    Client -->|HTTP/WS| Backend
    Backend -->|query| DB
```

**`ARCHITECTURE_DETAILED.mmd`**
```
%%{init: {'theme': 'default'}}%%
graph TD
    %% Detailed architecture diagram — edit to reflect your system
    %% Suggested: show modules, data flows, external services, auth, etc.

    subgraph Frontend
        UI["UI Layer"]
    end

    subgraph Backend
        API["API Layer"]
        Service["Service Layer"]
        Repo["Repository Layer"]
    end

    subgraph Persistence
        DB["Database"]
        Cache["Cache"]
    end

    UI -->|REST/GraphQL| API
    API --> Service
    Service --> Repo
    Repo --> DB
    Service --> Cache
```

When mermaid-mode is ON, also inject the following line into **both** the full starter template and the append-only workflow section of CLAUDE.md (inside `### Repository Context`, after the `ARCHITECTURE.md` bullet):

```
- Use `ARCHITECTURE_OVERVIEW.mmd` and `ARCHITECTURE_DETAILED.mmd` as living Mermaid diagrams. When the architecture changes, update both diagrams to reflect the new structure.
```

### 4. Discover dev commands and fill in `CLAUDE.md`
Using the config files detected by the bang command above:

| Config File | Commands to discover |
|---|---|
| `package.json` | Read the `scripts` object; map test/lint/typecheck/format/build entries to the matching command fields |
| `pyproject.toml` | Check for `[tool.pytest]`, `[tool.ruff]`, `[tool.mypy]`, `[tool.black]` sections |
| `Cargo.toml` | `cargo test`, `cargo clippy`, `cargo check`, `cargo fmt --check` |
| `go.mod` + Makefile | `go test ./...`, `go vet ./...`; check Makefile for golangci-lint targets |
| `Makefile` / `justfile` | Parse for targets matching test/lint/check/typecheck/format |
| `Gemfile` | Check for rspec/rubocop gems |
| `mix.exs` | `mix test`, `mix credo`, `mix dialyzer` |

- Present findings to the user in a concise table before writing.
- In `CLAUDE.md`, update the `## Development Commands` section:
  - Replace only empty placeholder lines (e.g. `Run tests:`, `Run linter:`, `Run type checks:`)
  - Preserve any lines that already have a command filled in
  - If no config files were found, skip this step and note it in the summary.

### 5. Update `.gitignore`
For each of the following patterns, add it to `.gitignore` if not already present. If `.gitignore` does not exist, create it.

```
.ai/plan.md
.ai/tasks/
.ai/tasks-done/
.ai/context.md
```

Report `[SKIP] .gitignore already contains <pattern>` for patterns already present.

### 6. Report summary
After all steps complete, print a concise summary:

```
[DONE] Agentic workflow initialized.

Created:
  - <list of files created>

Skipped (already existed):
  - <list of files skipped>

Dev commands detected:
  - <table or "none found">

Next steps:
  1. Fill in CLAUDE.md with project-specific conventions
  2. Fill in .ai/repo-map.md with your codebase structure
  3. Fill in ARCHITECTURE.md with your system design
  [if mermaid-mode] 3b. Edit ARCHITECTURE_OVERVIEW.mmd and ARCHITECTURE_DETAILED.mmd to reflect your system
  4. Start Claude Code and use the Planner → Coder → Tester → Reviewer workflow
```
