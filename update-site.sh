#!/bin/bash
# update-site.sh
# One-command workflow to rebuild and publish your Quarto site to GitHub Pages.
#
# Location: this script lives in /Users/hayatahmadzai/Desktop/academic-website/
# (the same folder as _quarto.yml, index.qmd, bio.qmd, etc.)
#
# Usage:
#   ./update-site.sh                  -> uses a default commit message
#   ./update-site.sh "fixed cv typo"  -> uses your custom commit message
#
# What it does, in order:
#   1. Moves into the project folder automatically (so it works even if you
#      accidentally run it from somewhere else, like your home folder)
#   2. Pulls any remote changes first (avoids conflicts if you ever edit from elsewhere)
#   3. Renders the Quarto site (.qmd -> .html, regenerates sitemap.xml/robots.txt)
#   4. Stages, commits, and pushes the rendered output to the master branch

set -e  # stop immediately if any step fails, instead of pushing a half-broken build

PROJECT_DIR="/Users/hayatahmadzai/Desktop/academic-website"

echo "==> Moving into project folder: $PROJECT_DIR"
cd "$PROJECT_DIR"

# Safety check: make sure this really is the right folder before doing anything
if [ ! -f "_quarto.yml" ]; then
  echo "ERROR: _quarto.yml not found in $PROJECT_DIR"
  echo "This doesn't look like the right folder. Stopping before doing anything."
  exit 1
fi

echo "==> Pulling latest changes from GitHub..."
git pull origin master

echo "==> Rendering site with Quarto..."
quarto render

echo "==> Staging changes..."
git add .

# Use the first argument as the commit message if provided, otherwise a default
COMMIT_MSG="${1:-Update site}"

# Only commit if there's actually something to commit
if git diff --cached --quiet; then
  echo "==> No changes to commit. Site is already up to date."
else
  echo "==> Committing: $COMMIT_MSG"
  git commit -m "$COMMIT_MSG"

  echo "==> Pushing to GitHub (master branch)..."
  git push origin master

  echo ""
  echo "Done! Changes are pushed."
  echo "Give it 30-60 seconds, then check: https://ahmadzaihayat.github.io/"
fi
