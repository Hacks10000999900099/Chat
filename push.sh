#!/usr/bin/env bash
set -euo pipefail

# === CONFIG ===
REPO_URL="https://github.com/Hacks10000999900099/Chat.git"
BRANCH="main"
FORCE_PUSH=1   # set to 0 to disable --force pushes

# === FUNCTIONS ===
log() { printf "\033[1;32m==>\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
err() { printf "\033[1;31m[ERR]\033[0m %s\n" "$*" >&2; }

# === START ===
if [ ! -d .git ]; then
  log "No .git directory found. Initializing new Git repo..."
  git init
fi

if git remote | grep -q '^origin$'; then
  log "Updating existing 'origin' remote to $REPO_URL ..."
  git remote set-url origin "$REPO_URL"
else
  log "Adding 'origin' remote -> $REPO_URL ..."
  git remote add origin "$REPO_URL"
fi

log "Switching to branch '$BRANCH' (creating/resetting if needed)..."
git checkout -B "$BRANCH"

log "Staging all changes..."
git add -A

if git diff --cached --quiet; then
  warn "No changes to commit. (Working tree clean or nothing new staged.)"
else
  COMMIT_MSG="${*:-Auto commit $(date -u +"%Y-%m-%d %H:%M:%S UTC")}"
  log "Committing: $COMMIT_MSG"
  git commit -m "$COMMIT_MSG"
fi

log "Pushing to remote '$REPO_URL' on branch '$BRANCH'..."
if [ "$FORCE_PUSH" -eq 1 ]; then
  warn "Using --force (remote will be overwritten if different)!"
  git push -u origin "$BRANCH" --force
else
  git push -u origin "$BRANCH"
fi

log "Done! Repo synced to $REPO_URL ($BRANCH)."
