#!/usr/bin/env bash
set -euo pipefail

# Run from the root of your Hyprland-dots repo.
# This script updates the local branch by fetching the upstream changes
# from JaKooLit (LinuxBeginnings/Hyprland-Dots) and merging them.

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Working tree not clean. Commit or stash changes first."
  exit 1
fi

# Ensure remote exists
if ! git remote | grep -q '^jakoolit$'; then
  echo "Adding upstream remote 'jakoolit'..."
  git remote add jakoolit https://github.com/LinuxBeginnings/Hyprland-Dots
fi

echo "Fetching latest changes (depth 20) from jakoolit..."
git fetch --depth 20 jakoolit

echo "Merging jakoolit/main into current branch..."
set +e
git merge --allow-unrelated-histories --no-ff -m "Merge upstream JaKooLit/Hyprland-Dots changes" jakoolit/main
status=$?
set -e

if [ $status -ne 0 ]; then
  if git status | grep -q "unmerged paths"; then
    echo "Merge conflicts occurred. Please resolve the conflicts in the files listed in 'git status' and commit:"
    echo "  git add -A && git commit"
  else
    echo "Merge failed with error (exit code $status)."
  fi
else
  echo "Successfully merged upstream changes!"
fi
