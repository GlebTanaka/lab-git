# Recovering Lost Work with Git Reflog

This directory contains exercises to help you understand and practice recovering "lost" work in Git using the `reflog` command.

## Overview

Git's reflog (reference log) is a mechanism that records updates to the tip of branches and other references in the local repository. It provides a safety net that allows you to recover commits that might seem lost due to operations like:

- Hard resets (`git reset --hard`)
- Amended commits (`git commit --amend`)
- Rebased branches
- Deleted branches
- Detached HEAD states

The reflog is local to your repository and is not pushed to remote repositories, making it a personal recovery tool.

## Understanding Git Reflog

The `git reflog` command shows a log of all the places where HEAD has pointed in your local repository:

```bash
git reflog
```

Each entry in the reflog includes:
- A short SHA-1 hash
- The reference position (HEAD@{n})
- The operation that moved HEAD (commit, reset, checkout, etc.)
- The commit message

For example:
```
1a2b3c4 HEAD@{0}: commit: Add new feature
5d6e7f8 HEAD@{1}: checkout: moving from main to feature-branch
9g0h1i2 HEAD@{2}: reset: moving to HEAD~1
...
```

## Exercises

### Exercise 1: Recovering from a Hard Reset

1. Create a series of commits
2. Perform a hard reset to an earlier commit
3. Use reflog to find and recover the "lost" commits

```bash
# Create a new file and make initial commit
echo "Initial content" > reflog-demo.txt
git add reflog-demo.txt
git commit -m "Initial commit"

# Make a second commit
echo "Second line of content" >> reflog-demo.txt
git add reflog-demo.txt
git commit -m "Add second line"

# Make a third commit
echo "Third line of content" >> reflog-demo.txt
git add reflog-demo.txt
git commit -m "Add third line"

# Check the log to see all three commits
git log --oneline

# Hard reset to the first commit (losing the second and third commits)
git reset --hard HEAD~2

# Check the log again - only the first commit should be visible
git log --oneline

# Use reflog to see all recent actions
git reflog

# Recover the latest state before the reset
git reset --hard HEAD@{1}  # Or use the specific SHA-1 from the reflog

# Verify that all three commits are restored
git log --oneline
cat reflog-demo.txt
```

### Exercise 2: Recovering a Deleted Branch

1. Create a new branch and make some commits
2. Switch back to main and delete the branch
3. Use reflog to find and recover the deleted branch

```bash
# Start from main branch
git checkout main

# Create a new branch
git checkout -b feature/important

# Make some commits on the new branch
echo "Important feature content" > important-feature.txt
git add important-feature.txt
git commit -m "Add important feature"

echo "More important content" >> important-feature.txt
git add important-feature.txt
git commit -m "Enhance important feature"

# Switch back to main
git checkout main

# Delete the feature branch (without merging)
git branch -D feature/important

# Try to checkout the branch (should fail)
git checkout feature/important

# Use reflog to find the last commit on the deleted branch
git reflog

# Create a new branch pointing to the lost commit
git checkout -b feature/recovered <SHA-1>  # Use the SHA-1 from the reflog

# Verify the recovery
git log --oneline
cat important-feature.txt
```

### Exercise 3: Recovering from a Bad Rebase

1. Create a branch with several commits
2. Perform a rebase that goes wrong
3. Use reflog to return to the pre-rebase state

```bash
# Start from main branch
git checkout main

# Create a new branch
git checkout -b feature/rebase-demo

# Make several commits
echo "First commit content" > rebase-demo.txt
git add rebase-demo.txt
git commit -m "First commit on rebase-demo"

echo "Second commit content" >> rebase-demo.txt
git add rebase-demo.txt
git commit -m "Second commit on rebase-demo"

echo "Third commit content" >> rebase-demo.txt
git add rebase-demo.txt
git commit -m "Third commit on rebase-demo"

# Save the current state for later comparison
git log --oneline > before-rebase.txt

# Attempt an interactive rebase (simulating a mistake)
git rebase -i HEAD~3

# After the rebase, save the new state
git log --oneline > after-rebase.txt

# Oops! We made a mistake in the rebase. Let's recover using reflog
git reflog

# Reset to the state before the rebase
git reset --hard HEAD@{N}  # Replace N with the appropriate number from reflog

# Verify we're back to the original state
git log --oneline
cat rebase-demo.txt
```

### Exercise 4: Recovering Lost Work in Detached HEAD State

1. Check out a specific commit (detached HEAD)
2. Make some changes and commits in the detached HEAD state
3. Accidentally checkout another branch without creating a branch for the detached HEAD work
4. Use reflog to recover the lost work

```bash
# Start from main branch
git checkout main

# Create some initial commits
echo "Initial content" > detached-head-demo.txt
git add detached-head-demo.txt
git commit -m "Initial commit for detached HEAD demo"

echo "Second line" >> detached-head-demo.txt
git add detached-head-demo.txt
git commit -m "Second commit for detached HEAD demo"

# Get the SHA-1 of the first commit
FIRST_COMMIT=$(git log --format="%H" | tail -1)

# Checkout the first commit (entering detached HEAD state)
git checkout $FIRST_COMMIT

# Make changes in the detached HEAD state
echo "Work done in detached HEAD state" > detached-head-work.txt
git add detached-head-work.txt
git commit -m "Add work in detached HEAD state"

echo "More work in detached HEAD" >> detached-head-work.txt
git add detached-head-work.txt
git commit -m "Add more work in detached HEAD state"

# Accidentally checkout main without saving the detached HEAD work
git checkout main

# The work done in detached HEAD state is now "lost"
# Let's find it in the reflog
git reflog

# Create a new branch pointing to the last commit in the detached HEAD state
git checkout -b recovered-detached-head <SHA-1>  # Use the SHA-1 from the reflog

# Verify the recovery
git log --oneline
cat detached-head-work.txt
```

### Exercise 5: Recovering from an Accidental Amend

1. Make a commit
2. Accidentally amend that commit with unrelated changes
3. Use reflog to recover the original commit

```bash
# Start from main branch
git checkout main

# Make a commit
echo "Original content" > amend-demo.txt
git add amend-demo.txt
git commit -m "Original commit"

# Save the commit hash for reference
ORIGINAL_COMMIT=$(git rev-parse HEAD)

# Accidentally amend the commit with unrelated changes
echo "Unrelated content" > unrelated.txt
git add unrelated.txt
git commit --amend -m "Amended commit with unrelated changes"

# Check the log - only the amended commit is visible
git log -1

# Use reflog to find the original commit
git reflog

# Create a new branch pointing to the original commit
git checkout -b recovered-original $ORIGINAL_COMMIT

# Verify the recovery
git log -1
ls -la
```

## Best Practices for Preventing Data Loss

1. **Create branches liberally**: Always work in a branch for new features or experiments
2. **Commit frequently**: Make small, frequent commits to create more recovery points
3. **Push to remote**: Regularly push your branches to a remote repository for backup
4. **Be cautious with destructive commands**: Be careful with commands like `reset --hard`, `rebase`, and `commit --amend`
5. **Check reflog before destructive operations**: Use `git reflog` to understand what you're about to change
6. **Set up Git aliases for common reflog operations**: Create shortcuts for recovery commands

## Advanced Reflog Usage

### Viewing Specific Reference Logs

You can view the reflog for specific references:

```bash
git reflog show main       # Show reflog for the main branch
git reflog show HEAD       # Show reflog for HEAD (default)
git reflog show feature    # Show reflog for the feature branch
```

### Reflog Expiration

Reflog entries don't last forever. By default:
- Reflog entries expire after 90 days
- Unreachable reflog entries expire after 30 days

You can change these defaults:

```bash
git config --global gc.reflogExpire "200 days"
git config --global gc.reflogExpireUnreachable "100 days"
```

### Creating a Branch from a Reflog Entry

```bash
git branch recovered-branch HEAD@{2}
```

## Conclusion

Git's reflog is a powerful safety net that can save you from many potentially disastrous situations. Understanding how to use reflog effectively gives you confidence to use Git's more advanced features without fear of losing work. Remember that reflog is a local recovery tool, so it's still important to push your important work to remote repositories for additional backup.