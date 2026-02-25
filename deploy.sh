#!/bin/bash
# Deploy a briefing HTML to the GitHub Pages site
# Usage: bash deploy.sh /path/to/YYYY-MM-DD.html
set -e

HTML_FILE="$1"
if [ -z "$HTML_FILE" ] || [ ! -f "$HTML_FILE" ]; then
    echo "ERROR: Provide a valid HTML file path"
    echo "Usage: bash deploy.sh ~/Reports/briefings/2026-02-25.html"
    exit 1
fi

DATE=$(basename "$HTML_FILE" .html)
REPO_DIR="/tmp/daily-briefings"
REPO_URL="https://github.com/molt1504-clay/daily-briefings.git"

# Clone or pull
if [ -d "$REPO_DIR/.git" ]; then
    cd "$REPO_DIR"
    git pull --ff-only
else
    rm -rf "$REPO_DIR"
    git clone "$REPO_URL" "$REPO_DIR"
    cd "$REPO_DIR"
fi

# Configure git identity
git config user.email "molt1504@jaybrown.dev"
git config user.name "molt1504-clay"

# Copy briefing to archive
cp "$HTML_FILE" archive/

# Rebuild index + archive page
bash build.sh

# Commit and push
git add -A
if git diff --cached --quiet; then
    echo "No changes to deploy"
else
    git commit -m "Add briefing $DATE"
    git push
    echo "Deployed briefing $DATE to GitHub Pages"
fi
