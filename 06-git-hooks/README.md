# Using Git Hooks

This directory contains exercises to help you understand and practice using Git hooks for automation and enforcing policies.

## Overview

Git hooks are scripts that Git executes before or after events such as commit, push, and receive. They allow you to customize Git's internal behavior and trigger customizable actions at key points in the development lifecycle.

Hooks can be used for:
- Enforcing coding standards
- Running tests before commits
- Validating commit messages
- Notifying team members of changes
- Deploying code automatically
- And much more

## Types of Git Hooks

Git hooks are divided into client-side and server-side hooks:

### Client-Side Hooks

- **pre-commit**: Runs before a commit is created, can be used to inspect the snapshot
- **prepare-commit-msg**: Runs before the commit message editor is fired up
- **commit-msg**: Used to validate commit messages
- **post-commit**: Runs after a commit is completed
- **pre-rebase**: Runs before you rebase anything
- **post-checkout**: Runs after a successful checkout
- **post-merge**: Runs after a successful merge
- **pre-push**: Runs during git push, before any objects are transferred

### Server-Side Hooks

- **pre-receive**: Runs when the server receives a push
- **update**: Similar to pre-receive but runs once for each branch
- **post-receive**: Runs after a successful push

## How Git Hooks Work

1. Git hooks are stored in the `.git/hooks` directory of your repository
2. By default, this directory contains sample hooks with a `.sample` extension
3. To activate a hook, remove the `.sample` extension and make the file executable
4. Hooks can be written in any language (bash, python, ruby, etc.) as long as they are executable

## Exercises

### Exercise 1: Setting Up a Basic pre-commit Hook

1. Create a simple pre-commit hook that checks for debugging statements
2. Test the hook by attempting to commit code with debugging statements

```bash
# Create a new repository for testing hooks
mkdir hook-test
cd hook-test
git init

# Create the pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

# Check for debugging statements
if git diff --cached | grep -E 'console\.log|debugger|print\(' > /dev/null; then
  echo "ERROR: Attempt to commit debugging statements detected."
  echo "Please remove debugging statements before committing."
  exit 1
fi

echo "No debugging statements found. Proceeding with commit."
exit 0
EOF

# Make the hook executable
chmod +x .git/hooks/pre-commit

# Create a file with debugging statements
cat > debug-test.js << 'EOF'
function main() {
  console.log("This is a debugging statement");
  return "Hello World";
}
EOF

# Try to commit the file (should fail)
git add debug-test.js
git commit -m "Add debug-test.js"

# Fix the file by removing debugging statements
cat > debug-test.js << 'EOF'
function main() {
  return "Hello World";
}
EOF

# Try to commit again (should succeed)
git add debug-test.js
git commit -m "Add debug-test.js without debugging statements"
```

### Exercise 2: Creating a commit-msg Hook to Enforce Commit Message Format

1. Create a commit-msg hook that enforces a specific commit message format
2. Test the hook with various commit messages

```bash
# Create the commit-msg hook
cat > .git/hooks/commit-msg << 'EOF'
#!/bin/bash

# Get the commit message (first argument is the file containing the message)
commit_msg_file=$1
commit_msg=$(cat "$commit_msg_file")

# Define the required format (e.g., "type: message")
# Types can be: feat, fix, docs, style, refactor, test, chore
required_pattern="^(feat|fix|docs|style|refactor|test|chore)(\([a-z0-9-]+\))?: .+"

if ! [[ "$commit_msg" =~ $required_pattern ]]; then
  echo "ERROR: Invalid commit message format."
  echo "Commit message must match pattern: type: message"
  echo "Where type is one of: feat, fix, docs, style, refactor, test, chore"
  echo "Example: feat: add new feature"
  exit 1
fi

echo "Commit message format is valid."
exit 0
EOF

# Make the hook executable
chmod +x .git/hooks/commit-msg

# Create a test file
echo "Test content" > commit-msg-test.txt

# Try to commit with an invalid message (should fail)
git add commit-msg-test.txt
git commit -m "Add test file"

# Try to commit with a valid message (should succeed)
git add commit-msg-test.txt
git commit -m "feat: add test file for commit message validation"
```

### Exercise 3: Using a pre-push Hook to Run Tests

1. Create a pre-push hook that runs tests before pushing
2. Test the hook by attempting to push with failing and passing tests

```bash
# Create a simple test script
cat > test.sh << 'EOF'
#!/bin/bash

# This is a mock test script
# In a real project, this would run your actual test suite

if [ -f "test-should-fail" ]; then
  echo "Tests failed!"
  exit 1
else
  echo "All tests passed!"
  exit 0
fi
EOF

chmod +x test.sh

# Create the pre-push hook
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash

echo "Running tests before push..."
./test.sh

if [ $? -ne 0 ]; then
  echo "ERROR: Tests failed. Push aborted."
  exit 1
fi

echo "Tests passed. Proceeding with push."
exit 0
EOF

chmod +x .git/hooks/pre-push

# Create a file and commit it
echo "Some content" > pre-push-test.txt
git add pre-push-test.txt
git commit -m "feat: add pre-push test file"

# Create a file to make tests fail
touch test-should-fail

# Try to push (should fail)
# Note: In a real scenario, you would have a remote repository set up
echo "Simulating push (would fail due to failing tests)"

# Remove the file to make tests pass
rm test-should-fail

# Try to push again (should succeed)
echo "Simulating push (would succeed as tests now pass)"
```

### Exercise 4: Post-commit Hook for Notifications

1. Create a post-commit hook that sends a notification after each commit
2. Test the hook by making a commit

```bash
# Create the post-commit hook
cat > .git/hooks/post-commit << 'EOF'
#!/bin/bash

# Get the last commit message
commit_msg=$(git log -1 --pretty=%B)
author=$(git log -1 --pretty=%an)
date=$(git log -1 --pretty=%ad)

# In a real scenario, you might send an email or Slack notification
# For this exercise, we'll just display a message
echo "NOTIFICATION: New commit by $author on $date"
echo "Commit message: $commit_msg"
echo "This would typically be sent via email or chat notification."

# Log to a file for demonstration
echo "[$(date)] New commit: $commit_msg" >> commit-log.txt

exit 0
EOF

chmod +x .git/hooks/post-commit

# Make a commit to trigger the hook
echo "Testing post-commit hook" > post-commit-test.txt
git add post-commit-test.txt
git commit -m "feat: add post-commit test file"

# Check the log file
cat commit-log.txt
```

### Exercise 5: Sharing Hooks with Your Team

Git hooks are not shared when a repository is cloned because they're stored in the `.git` directory, which isn't part of the tracked content. Here's how to share hooks with your team:

1. Create a directory in your project to store hook templates
2. Create a script to install the hooks
3. Add instructions for team members to run the script

```bash
# Create a hooks directory in the project
mkdir -p hooks-template

# Move our hooks to the template directory
cp .git/hooks/pre-commit hooks-template/
cp .git/hooks/commit-msg hooks-template/
cp .git/hooks/pre-push hooks-template/
cp .git/hooks/post-commit hooks-template/

# Create an installation script
cat > install-hooks.sh << 'EOF'
#!/bin/bash

# Copy hooks from template directory to .git/hooks
cp hooks-template/* .git/hooks/

# Make hooks executable
chmod +x .git/hooks/*

echo "Git hooks installed successfully!"
EOF

chmod +x install-hooks.sh

# Add instructions to README
cat > README.md << 'EOF'
# Hook Test Project

This project uses Git hooks to enforce coding standards and run tests.

## Setup

After cloning the repository, run the following command to install the Git hooks:

```bash
./install-hooks.sh
```

## Available Hooks

- pre-commit: Prevents committing debugging statements
- commit-msg: Enforces commit message format
- pre-push: Runs tests before pushing
- post-commit: Sends notifications after commits
EOF

# Commit the hook templates and installation script
git add hooks-template/ install-hooks.sh README.md
git commit -m "feat: add shareable Git hooks"
```

## Sample Hooks

This directory includes several sample hooks that you can use as starting points for your own projects:

### 1. pre-commit Hook for Code Linting

```bash
#!/bin/bash
# File: hooks/pre-commit-lint

# Run linter on staged files
files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.js$')
if [ -n "$files" ]; then
  echo "Running linter on JavaScript files..."
  # Replace with your actual linting command
  # eslint $files
  
  # For demonstration, we'll just check for semicolons
  for file in $files; do
    if grep -l "[^;]$" "$file"; then
      echo "ERROR: Missing semicolons in $file"
      exit 1
    fi
  done
fi

exit 0
```

### 2. commit-msg Hook for Issue References

```bash
#!/bin/bash
# File: hooks/commit-msg-issue-ref

commit_msg_file=$1
commit_msg=$(cat "$commit_msg_file")

# Check if commit message references an issue number
issue_pattern="(#[0-9]+)"

if ! [[ "$commit_msg" =~ $issue_pattern ]]; then
  echo "WARNING: Commit message does not reference an issue number."
  echo "Consider adding a reference like #123 to link this commit to an issue."
  
  # Uncomment to make this a hard requirement
  # exit 1
fi

exit 0
```

### 3. pre-push Hook for Security Checks

```bash
#!/bin/bash
# File: hooks/pre-push-security

echo "Running security checks before push..."

# Check for sensitive information in staged files
sensitive_patterns=(
  "password\s*=\s*['\"][^'\"]+['\"]"
  "api[_-]?key\s*=\s*['\"][^'\"]+['\"]"
  "secret\s*=\s*['\"][^'\"]+['\"]"
  "BEGIN (RSA|DSA|EC|OPENSSH) PRIVATE KEY"
)

for pattern in "${sensitive_patterns[@]}"; do
  if git grep -E "$pattern" $(git diff --cached --name-only); then
    echo "ERROR: Potential sensitive information detected."
    echo "Please remove sensitive data before pushing."
    exit 1
  fi
done

echo "No sensitive information detected."
exit 0
```

## Best Practices for Git Hooks

1. **Keep hooks simple and focused**: Each hook should do one thing well
2. **Make hooks fail fast**: Detect issues early to save time
3. **Provide clear error messages**: Help developers understand why a hook failed
4. **Make hooks skippable in emergencies**: Allow bypassing hooks with environment variables
5. **Test hooks thoroughly**: Ensure hooks work correctly before sharing
6. **Document your hooks**: Make sure team members understand what each hook does
7. **Version control your hooks**: Store hook templates in your repository
8. **Consider performance**: Slow hooks can frustrate developers

## Conclusion

Git hooks are a powerful way to automate tasks, enforce standards, and improve workflow. By implementing appropriate hooks, you can catch issues early, maintain code quality, and streamline your development process. Remember that hooks should help your team, not hinder them—make sure they add value and don't become a source of frustration.