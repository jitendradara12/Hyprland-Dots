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

echo "Fetching latest changes from jakoolit..."
git fetch --prune jakoolit

# A shallow clone has no common ancestor with upstream, so git treats every
# file as added on both sides. Deepen until a real merge base exists.
if ! git merge-base HEAD jakoolit/development >/dev/null 2>&1 \
  && [ "$(git rev-parse --is-shallow-repository)" = "true" ]; then
  echo "No common history with jakoolit/development; deepening..."
  git fetch --deepen=500 jakoolit
fi

if ! base=$(git merge-base HEAD jakoolit/development); then
  echo "Still no common ancestor with jakoolit/development."
  echo "Refusing to merge unrelated histories. Run: git fetch --unshallow jakoolit"
  exit 1
fi

echo "Merging jakoolit/development (base ${base:0:12}) into current branch..."
set +e
git merge --no-ff -m "Merge upstream JaKooLit/Hyprland-Dots changes" jakoolit/development
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
