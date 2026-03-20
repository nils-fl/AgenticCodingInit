# Agentic Coding Initializer

Give your AI coding assistant a structured workflow.

## The Problem

AI coding assistants without guardrails tend to:
- Try to implement everything at once instead of one task at a time
- Skip testing and review steps
- Lose context across sessions
- Diverge from architectural decisions made earlier in the project

## The Solution

A lightweight convention: **plan first, implement one task, test, review, stop.**

This repo initializes that convention in any project — a `.ai/` folder for task tracking, a `CLAUDE.md` / `AGENTS.md` with persona-based instructions, and an `ARCHITECTURE.md` template to keep design decisions explicit.

## How It Works

The workflow is built around four personas and seven steps:

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ Planner  │ -> │  Coder   │ -> │  Tester  │ -> │ Reviewer │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
```

| # | Step | Who | Output |
|---|------|-----|--------|
| 1 | Write implementation plan | Planner | `.ai/plan.md` |
| 2 | Create timestamped task files | Planner | `.ai/tasks/YYYYMMDD-HHMM-*.md` |
| 3 | Implement **one** task | Coder | code changes |
| 4 | Run tests, lint, type checks | Tester | pass/fail report |
| 5 | Review the diff | Reviewer | feedback |
| 6 | Move task to done | — | `.ai/tasks-done/` |
| 7 | **Stop** | — | — |

The AI never executes the entire feature in a single loop. Each task is a checkpoint.

## Quick Start

### Option A: Claude Code (recommended)

Install the `/init-workflow` skill once, then run it in any project:

```bash
# User-level install (available in all your projects):
bash install-skills.sh

# Or project-level (ships with the repo, for the whole team):
bash install-skills.sh --project
bash install-skills.sh --project /path/to/repo
```

Then inside Claude Code:

```
/init-workflow
/init-workflow /path/to/repo

# Also create Mermaid architecture diagrams:
/init-workflow --mermaid
/init-workflow /path/to/repo --mermaid
```

The skill sets up everything and discovers your dev commands automatically.

Pass `--mermaid` to also create `ARCHITECTURE_OVERVIEW.mmd` and `ARCHITECTURE_DETAILED.mmd` with starter templates. Claude will keep them updated alongside `ARCHITECTURE.md` as the codebase evolves.

#### Skill description

The first paragraph of `SKILL.md` is used as the description shown in Claude Code's `/skills` dialog. Edit it to customize how the skill appears.

#### Updating the skill

After pulling the latest version of this repo, re-run the same install command to copy the updated `SKILL.md` over the existing one:

```bash
# Re-run to update:
bash install-skills.sh          # user-level
bash install-skills.sh --project  # project-level
```

### Option B: Shell script

```bash
# Initialize both Claude and Codex
bash agentic_init.sh

# Claude only
bash agentic_init.sh --claude

# Codex only
bash agentic_init.sh --codex

# Target a specific directory
bash agentic_init.sh --claude /path/to/repo

# Include the /init-workflow skill in the target repo (Claude only)
bash agentic_init.sh --claude --with-skill /path/to/repo
```

Both paths are idempotent — re-running skips anything that already exists.

#### Optional: Zsh integration

```zsh
code_init_repo() {
  bash /path/to/agentic_init.sh "${1:-.}"
}
```

## What Gets Created

```
your-repo/
├── .ai/
│   ├── plan.md          # Current feature roadmap (gitignored)
│   ├── context.md       # Session notes and conventions (gitignored)
│   ├── repo-map.md      # Codebase structure for fast AI orientation
│   ├── tasks/           # Active task files (gitignored)
│   └── tasks-done/      # Completed task archive (gitignored)
├── ARCHITECTURE.md           # System design reference
├── ARCHITECTURE_OVERVIEW.mmd # High-level Mermaid diagram (--mermaid only)
├── ARCHITECTURE_DETAILED.mmd # Detailed Mermaid diagram (--mermaid only)
├── CLAUDE.md                 # Claude Code entry point (personas + workflow)
└── AGENTS.md                 # Codex entry point (personas + workflow)
```

`CLAUDE.md` and `AGENTS.md` get the 4-persona workflow injected. If they already exist, only the workflow section is appended.

## Recommended Prompts

### Planning

```text
Based on my request create or update .ai/plan.md and create task files in .ai/tasks/.
Do not implement anything yet. Stop after the plan and tasks are created.
Use a timestamp prefix "YYYYMMDD-HHMM-" to ensure unique filenames.
```

### Implementation

```text
Implement the next task from .ai/tasks/.
Only modify files required for the current task.
Complete one task, run the verification steps, then stop.
```

## Configuration

### `.gitignore` behavior

The script and skill add these patterns to `.gitignore` automatically:

```
.ai/plan.md
.ai/tasks/
.ai/tasks-done/
.ai/context.md
```

`repo-map.md` is intentionally **not** gitignored — it's a committed reference for the whole team.

### `--claude` vs `--codex`

- `--claude` creates `CLAUDE.md` with the Claude Code workflow.
- `--codex` creates `AGENTS.md` with the Codex workflow.
- Omitting both flags initializes **both** by default.
- `--with-skill` requires `--claude` (Codex has no skill system).
