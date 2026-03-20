#!/usr/bin/env bash
set -euo pipefail

# Installs Claude Code skills from this repo.
# Usage:
#   bash install-skills.sh                      # user-level (~/.claude/skills/)
#   bash install-skills.sh --project            # project-level (./.claude/skills/)
#   bash install-skills.sh --project /path/dir  # project-level in specific repo

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/skills"

# Parse arguments
PROJECT_MODE=false
PROJECT_DIR="."

while [[ $# -gt 0 ]]; do
  case $1 in
    --project)
      PROJECT_MODE=true
      shift
      if [[ $# -gt 0 && "$1" != -* ]]; then
        PROJECT_DIR="$1"
        shift
      fi
      ;;
    *)
      echo "[ERROR] Unknown option: $1"
      echo "Usage: bash install-skills.sh [--project [DIR]]"
      exit 1
      ;;
  esac
done

if [[ "$PROJECT_MODE" == true ]]; then
  SKILLS_DEST="$(cd "$PROJECT_DIR" && pwd)/.claude/skills"
else
  SKILLS_DEST="$HOME/.claude/skills"
fi

if [ ! -d "$SKILLS_SRC" ]; then
  echo "[ERROR] Skills directory not found: $SKILLS_SRC"
  exit 1
fi

mkdir -p "$SKILLS_DEST"

for skill_dir in "$SKILLS_SRC"/*/; do
  skill_name="$(basename "$skill_dir")"
  dest="$SKILLS_DEST/$skill_name"
  mkdir -p "$dest"
  cp "$skill_dir/SKILL.md" "$dest/SKILL.md"
  echo "[OK] Installed $skill_name skill to $dest"
done

echo
echo "[DONE] Skills installed to: $SKILLS_DEST"
echo "       Restart Claude Code to pick up new skills."
