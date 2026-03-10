# Agentic Coding Initializer

This repository provides a custom agentic workflow initializer for **Claude Code** and **Codex**. It sets up a structured environment for AI-driven development by creating a dedicated `.ai/` directory and initializing `CLAUDE.md` and `AGENTS.md` with best-practice workflows.

## Features

- **Standardized Structure**: Creates `.ai/tasks`, `.ai/tasks-done`, and helper files (`plan.md`, `context.md`, `repo-map.md`).
- **Workflow Enforcement**: Injects persona-based instructions for Planners, Coders, Testers, and Reviewers.
- **Timestamped Tasks**: Encourages `YYYYMMDD-HHMM-` prefixes for task files to prevent merge conflicts and maintain order.
- **Git Integration**: Automatically updates `.gitignore` to keep ephemeral AI state out of the repository if desired.

## Quick Start

Run the script in the root of your project:

```bash
# Initialize both Claude and Codex
bash agentic_init.sh

# Initialize only Claude
bash agentic_init.sh --claude

# Initialize only Codex
bash agentic_init.sh --codex

# Target a specific directory
bash agentic_init.sh /path/to/your/repo
bash agentic_init.sh --claude /path/to/your/repo
bash agentic_init.sh --codex /path/to/your/repo
```

## Workflow Overview

1. **Planner**: Analyzes requirements and breaks them down into task files in `.ai/tasks/`.
2. **Coder**: Implements ONE task at a time.
3. **Tester**: Verifies the implementation.
4. **Reviewer**: Performs a final check.
5. **Completion**: Tasks are moved to `.ai/tasks-done/`.

## File Structure

- `.ai/plan.md`: The overall roadmap for the current feature.
- `.ai/tasks/`: Active task files.
- `.ai/tasks-done/`: History of completed tasks.
- `.ai/repo-map.md`: High-level guide for the AI to understand the codebase structure without full scans.
- `CLAUDE.md` / `AGENTS.md`: Entry points for Claude Code and Codex instructions.

## Recommended Prompts

### For Planning
Use this prompt when you want the AI to analyze the task and prepare the implementation details:

```text
Based on my request create or update .ai/plan.md and create task files in .ai/tasks/. Do not implement anything yet. Stop after the plan and tasks are created.
Use a timestamp prefix "YYYYMMDD-HHMM-" to ensure unique filenames.
```

### For Implementation
Use this prompt when you are ready to start coding:

```text
Implement the next tasks from .ai/tasks/.
Only modify files required for the current task.
Complete one task, run the verification steps, then stop.
```
