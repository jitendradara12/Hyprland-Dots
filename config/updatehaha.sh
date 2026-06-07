#!/usr/bin/env bash
set -euo pipefail

# Run from the root of your hyprdotfiles repo.
# This script updates a local branch 'jakoolit-configs' to the latest split of
# JaKooLit/Hyprland-Dots/config and merges it into the current branch (root).

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Working tree not clean. Commit or stash changes first."
  exit 1
fi

# Ensure remote exists
if ! git remote | grep -q '^jakoolit$'; then
  git remote add jakoolit https://github.com/LinuxBeginnings/Hyprland-Dots
fi
git fetch jakoolit

WT="../.jakoolit-wt"
# Recreate worktree fresh
if [ -d "$WT" ]; then
  git worktree remove --force "$WT"
fi
git worktree add -f "$WT" jakoolit/main

# Build split branch with only config/ at repo root
(
  cd "$WT"
  git branch -D configs-only 2>/dev/null || true
  git subtree split -P config -b configs-only
)

# Update or create local tracking branch
git fetch "$WT" configs-only:jakoolit-configs

# Try a regular merge; if this is the first time, allow unrelated histories
set +e
git merge --no-ff -m "Sync JaKooLit Hyprland-Dots/config into repo root" jakoolit-configs
status=$?
set -e

if [ $status -ne 0 ]; then
  echo "Retrying merge allowing unrelated histories (likely first import)..."
  git merge --allow-unrelated-histories --no-ff -m "Initial import: JaKooLit Hyprland-Dots/config into repo root" jakoolit-configs
fi

# Cleanup
git worktree remove "$WT" || true

echo "Merge complete. Resolve any conflicts, then:"
echo "  git add -A && git commit"
