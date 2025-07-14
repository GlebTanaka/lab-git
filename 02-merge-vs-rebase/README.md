# Merge vs Rebase

This directory contains exercises to help you understand and practice the differences between Git's merge and rebase operations.

## Overview

Git provides two main ways to integrate changes from one branch into another: merging and rebasing. Both accomplish the same goal but in different ways, with different results in the commit history.

## Merge vs Rebase: Key Differences

### Merge

- Creates a new "merge commit" that ties together the histories of both branches
- Preserves the complete history and chronological order
- Non-destructive operation (doesn't change existing commits)
- Results in a non-linear history with explicit merge points

### Rebase

- Moves or "replays" commits from one branch onto another
- Creates a linear, cleaner history
- Rewrites commit history (destructive operation)
- Makes it look as if you created your branch from the latest commit

## Visual Comparison

### Before Merge/Rebase

```
          A---B---C (feature)
         /
    D---E---F---G (main)
```

### After Merge

```
          A---B---C (feature)
         /         \
    D---E---F---G---H (main)
```

### After Rebase

```
                  A'--B'--C' (feature)
                 /
    D---E---F---G (main)
```

## Exercises

### Exercise 1: Basic Merge

1. Create a new branch from main
2. Make some changes in both branches
3. Merge the feature branch back to main

```bash
# Create a new file in main branch
echo "This is the main branch file" > main-file.txt
git add main-file.txt
git commit -m "Add main-file.txt"

# Create and switch to a feature branch
git checkout -b feature/merge-example

# Create a new file in the feature branch
echo "This is the feature branch file" > feature-file.txt
git add feature-file.txt
git commit -m "Add feature-file.txt"

# Switch back to main and make a change
git checkout main
echo "New line in main" >> main-file.txt
git add main-file.txt
git commit -m "Update main-file.txt in main branch"

# Merge the feature branch into main
git merge feature/merge-example

# Examine the commit history
git log --graph --oneline --all
```

### Exercise 2: Basic Rebase

1. Create a new branch from main
2. Make some changes in both branches
3. Rebase the feature branch onto main
4. Fast-forward merge the feature branch to main

```bash
# Create a new file in main branch
echo "This is another main branch file" > main-file2.txt
git add main-file2.txt
git commit -m "Add main-file2.txt"

# Create and switch to a feature branch
git checkout -b feature/rebase-example

# Create a new file in the feature branch
echo "This is another feature branch file" > feature-file2.txt
git add feature-file2.txt
git commit -m "Add feature-file2.txt"

# Switch back to main and make a change
git checkout main
echo "New line in main file 2" >> main-file2.txt
git add main-file2.txt
git commit -m "Update main-file2.txt in main branch"

# Rebase the feature branch onto main
git checkout feature/rebase-example
git rebase main

# Fast-forward merge the feature branch to main
git checkout main
git merge feature/rebase-example

# Examine the commit history
git log --graph --oneline --all
```

### Exercise 3: Handling Conflicts During Merge

1. Create a new branch from main
2. Make conflicting changes in both branches
3. Merge the feature branch into main and resolve the conflict

```bash
# Create a file in main branch
echo "Line 1\nLine 2\nLine 3" > conflict-file.txt
git add conflict-file.txt
git commit -m "Add conflict-file.txt"

# Create and switch to a feature branch
git checkout -b feature/merge-conflict

# Modify the file in the feature branch
sed -i '' 's/Line 2/Line 2 modified in feature/' conflict-file.txt
git add conflict-file.txt
git commit -m "Modify Line 2 in feature branch"

# Switch back to main and make a conflicting change
git checkout main
sed -i '' 's/Line 2/Line 2 modified in main/' conflict-file.txt
git add conflict-file.txt
git commit -m "Modify Line 2 in main branch"

# Try to merge the feature branch (this will cause a conflict)
git merge feature/merge-conflict

# Resolve the conflict manually by editing the file
echo "Line 1\nLine 2 modified in both branches\nLine 3" > conflict-file.txt
git add conflict-file.txt
git commit -m "Resolve merge conflict"

# Examine the commit history
git log --graph --oneline --all
```

### Exercise 4: Handling Conflicts During Rebase

1. Create a new branch from main
2. Make conflicting changes in both branches
3. Rebase the feature branch onto main and resolve the conflict

```bash
# Create a file in main branch
echo "Line A\nLine B\nLine C" > rebase-conflict-file.txt
git add rebase-conflict-file.txt
git commit -m "Add rebase-conflict-file.txt"

# Create and switch to a feature branch
git checkout -b feature/rebase-conflict

# Modify the file in the feature branch
sed -i '' 's/Line B/Line B modified in feature/' rebase-conflict-file.txt
git add rebase-conflict-file.txt
git commit -m "Modify Line B in feature branch"

# Switch back to main and make a conflicting change
git checkout main
sed -i '' 's/Line B/Line B modified in main/' rebase-conflict-file.txt
git add rebase-conflict-file.txt
git commit -m "Modify Line B in main branch"

# Try to rebase the feature branch (this will cause a conflict)
git checkout feature/rebase-conflict
git rebase main

# Resolve the conflict manually by editing the file
echo "Line A\nLine B modified in both branches\nLine C" > rebase-conflict-file.txt
git add rebase-conflict-file.txt
git rebase --continue

# Fast-forward merge the feature branch to main
git checkout main
git merge feature/rebase-conflict

# Examine the commit history
git log --graph --oneline --all
```

## When to Use Merge vs Rebase

### Use Merge When:

- You want to preserve the complete history and chronological order
- The branch being merged is a shared branch (e.g., a feature branch that multiple people work on)
- You want to clearly see where a feature branch was integrated

### Use Rebase When:

- You want a cleaner, linear history
- The branch being rebased is a private branch (not shared with others)
- You want to integrate the latest changes from the main branch into your feature branch
- You're preparing a feature branch for a clean merge into the main branch

## Best Practices

1. **Never rebase shared branches**: Only rebase branches that you haven't pushed or that no one else is working on
2. **Merge for collaboration, rebase for cleanup**: Use merges for collaborative work and rebases for cleaning up your local work
3. **Commit often, rebase selectively**: Make frequent, small commits and use interactive rebase to clean them up before sharing
4. **Understand the implications**: Make sure you understand what happens during a rebase before using it

## Conclusion

Both merge and rebase are powerful tools in Git, each with its own advantages and appropriate use cases. Understanding when and how to use each one will help you maintain a clean and meaningful Git history.