#!/bin/bash

# This script installs the sample Git hooks into your repository

# Check if we're in a Git repository
if [ ! -d .git ]; then
  echo "Error: This script must be run from the root of a Git repository."
  exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Copy the sample hooks to the .git/hooks directory
echo "Installing Git hooks..."

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Copy each hook and make it executable
cp "$SCRIPT_DIR/hooks/pre-commit-lint" .git/hooks/pre-commit
cp "$SCRIPT_DIR/hooks/commit-msg-issue-ref" .git/hooks/commit-msg
cp "$SCRIPT_DIR/hooks/pre-push-security" .git/hooks/pre-push

# Make the hooks executable
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/commit-msg
chmod +x .git/hooks/pre-push

echo "Git hooks installed successfully!"
echo "The following hooks are now active:"
echo "- pre-commit: Checks for missing semicolons in JavaScript files"
echo "- commit-msg: Checks for issue references in commit messages"
echo "- pre-push: Checks for sensitive information before pushing"