# Working with Git Stashes

This directory contains exercises to help you understand and practice using Git's stash feature.

## Overview

Git stash is a powerful feature that allows you to temporarily store uncommitted changes so you can work on something else, and then come back and reapply the changes later. This is particularly useful when you need to:

- Switch branches without committing current changes
- Pull in upstream changes without conflicts
- Set aside work-in-progress to focus on a more urgent task
- Experiment with changes without committing them

## Basic Stash Commands

- `git stash`: Save your changes to a stash and revert to the last commit
- `git stash list`: List all stashes
- `git stash apply`: Apply the most recent stash without removing it
- `git stash pop`: Apply the most recent stash and remove it from the stash list
- `git stash drop`: Remove the most recent stash
- `git stash clear`: Remove all stashes

## Exercises

### Exercise 1: Basic Stashing and Applying

1. Make some changes to a file
2. Stash the changes
3. Verify the working directory is clean
4. Apply the stashed changes

```bash
# Create a new file
echo "Initial content" > stash-demo.txt
git add stash-demo.txt
git commit -m "Add stash-demo.txt"

# Make some changes
echo "Work in progress" >> stash-demo.txt

# Stash the changes
git stash

# Verify the working directory is clean
git status
cat stash-demo.txt  # Should show only "Initial content"

# Apply the stashed changes
git stash apply

# Verify the changes are back
cat stash-demo.txt  # Should show both lines

# Clean up by dropping the stash
git stash drop
```

### Exercise 2: Working with Multiple Stashes

1. Create multiple stashes with different changes
2. List all stashes
3. Apply specific stashes

```bash
# Start with a clean working directory
git checkout main

# Create a new file
echo "Base content" > multi-stash.txt
git add multi-stash.txt
git commit -m "Add multi-stash.txt"

# Make first change
echo "First stashed change" >> multi-stash.txt
git stash save "First change to multi-stash.txt"

# Make second change
echo "Second stashed change" >> multi-stash.txt
git stash save "Second change to multi-stash.txt"

# Make third change
echo "Third stashed change" >> multi-stash.txt
git stash save "Third change to multi-stash.txt"

# List all stashes
git stash list

# Apply a specific stash (the second one)
git stash apply stash@{1}

# Verify the changes
cat multi-stash.txt  # Should show "Base content" and "Second stashed change"

# Apply another stash (the first one)
git stash apply stash@{2}

# Verify the changes (might have conflicts)
cat multi-stash.txt

# Clean up by clearing all stashes
git stash clear
```

### Exercise 3: Stashing Untracked Files

1. Create some tracked and untracked files
2. Stash all changes, including untracked files
3. Apply the stash

```bash
# Start with a clean working directory
git checkout main

# Create and commit a tracked file
echo "Tracked file content" > tracked.txt
git add tracked.txt
git commit -m "Add tracked.txt"

# Modify the tracked file
echo "Modified tracked content" >> tracked.txt

# Create an untracked file
echo "Untracked file content" > untracked.txt

# Verify status
git status  # Should show one modified file and one untracked file

# Stash all changes including untracked files
git stash -u  # or git stash --include-untracked

# Verify the working directory is clean
git status
ls -la  # untracked.txt should be gone

# Apply the stash
git stash pop

# Verify both changes are back
git status
cat tracked.txt
cat untracked.txt
```

### Exercise 4: Stashing with a Custom Message

1. Make some changes
2. Stash with a descriptive message
3. List stashes to see the custom message
4. Apply the stash

```bash
# Start with a clean working directory
git checkout main

# Create and commit a file
echo "Original content" > custom-message.txt
git add custom-message.txt
git commit -m "Add custom-message.txt"

# Make some changes
echo "Important changes that I'll need later" >> custom-message.txt

# Stash with a custom message
git stash save "Working on feature XYZ - important changes"

# List stashes to see the custom message
git stash list

# Apply the stash
git stash pop

# Verify the changes are back
cat custom-message.txt
```

### Exercise 5: Creating a Branch from a Stash

1. Make some changes
2. Stash the changes
3. Create a new branch and apply the stash in one command

```bash
# Start with a clean working directory
git checkout main

# Create and commit a file
echo "Starting point" > branch-from-stash.txt
git add branch-from-stash.txt
git commit -m "Add branch-from-stash.txt"

# Make some changes
echo "Changes that will go to a new branch" >> branch-from-stash.txt

# Stash the changes
git stash

# Create a new branch and apply the stash in one command
git stash branch feature/from-stash

# Verify you're on the new branch with the changes applied
git status
git branch  # Should show you're on feature/from-stash
cat branch-from-stash.txt  # Should include the stashed changes

# Note: The stash is automatically dropped when successfully applied to a new branch
git stash list  # Should be empty if the branch was created successfully
```

### Exercise 6: Partial Stashing

1. Make changes to multiple files
2. Stash only some of the changes
3. Verify that only selected changes were stashed

```bash
# Start with a clean working directory
git checkout main

# Create and commit multiple files
echo "File 1 content" > partial1.txt
echo "File 2 content" > partial2.txt
git add partial1.txt partial2.txt
git commit -m "Add files for partial stashing demo"

# Make changes to both files
echo "Changes to file 1" >> partial1.txt
echo "Changes to file 2" >> partial2.txt

# Stash only changes to partial1.txt
git stash push -p  # Interactive mode, select only changes to partial1.txt

# Verify that changes to partial2.txt are still in the working directory
git status  # Should show partial2.txt as modified
cat partial1.txt  # Should show original content
cat partial2.txt  # Should show modified content

# Apply the stash
git stash pop

# Verify all changes are back
cat partial1.txt
cat partial2.txt
```

### Exercise 7: Cleaning Up Stashes

1. Create multiple stashes
2. Remove specific stashes
3. Clear all remaining stashes

```bash
# Create multiple stashes
echo "Change 1" > cleanup-demo.txt
git add cleanup-demo.txt
git commit -m "Add cleanup-demo.txt"

echo "Stash 1" >> cleanup-demo.txt
git stash save "Stash 1"

echo "Stash 2" >> cleanup-demo.txt
git stash save "Stash 2"

echo "Stash 3" >> cleanup-demo.txt
git stash save "Stash 3"

# List all stashes
git stash list

# Remove a specific stash
git stash drop stash@{1}  # Removes the second stash (index 1)

# List stashes again to verify
git stash list

# Clear all remaining stashes
git stash clear

# Verify all stashes are gone
git stash list  # Should show nothing
```

## Best Practices for Working with Stashes

1. **Use descriptive stash messages**: Always use `git stash save "Your message"` to make it easier to identify stashes later
2. **Don't keep stashes for too long**: Stashes are meant to be temporary; commit or discard changes when possible
3. **Be careful with pop vs. apply**: Use `pop` when you want to apply and remove a stash, and `apply` when you want to apply a stash multiple times
4. **Stash untracked files when needed**: Use the `-u` or `--include-untracked` flag to include untracked files in your stash
5. **Create branches from complex stashes**: If a stash contains significant work, consider creating a branch from it using `git stash branch`
6. **Review stashes before applying**: Use `git stash show stash@{n}` to see what's in a stash before applying it
7. **Clean up your stash list**: Regularly remove stashes you no longer need

## Advanced Stash Usage

### Viewing Stash Contents

```bash
# Show summary of changes in the most recent stash
git stash show

# Show detailed diff of changes in the most recent stash
git stash show -p

# Show detailed diff of a specific stash
git stash show -p stash@{1}
```

### Applying Parts of a Stash

```bash
# Apply a single file from a stash
git checkout stash@{0} -- path/to/file

# Interactively apply parts of a stash
git checkout -p stash@{0}
```

### Creating a Stash Without Modifying the Working Directory

```bash
# Create a stash but keep the changes in the working directory
git stash create
git stash store -m "My message" <SHA-1>
```

## Conclusion

Git stash is an invaluable tool for managing work-in-progress without creating unnecessary commits. By mastering stashes, you can work more flexibly, switch contexts quickly, and keep your repository history clean. Remember that stashes are meant to be temporary storage—they're not a replacement for proper branching and committing practices.