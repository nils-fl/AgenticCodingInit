#!/usr/bin/env bash
set -euo pipefail

# Installs Claude Code skills from this repo to ~/.claude/skills/
# Run once per machine after cloning this repo.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/skills"
SKILLS_DEST="$HOME/.claude/skills"

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
echo "[DONE] Skills installed. Restart Claude Code to pick up new skills."
