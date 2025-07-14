# Conflict Resolution in Git

This directory contains exercises to help you understand, create, and resolve conflicts in Git.

## Overview

Merge conflicts occur when Git cannot automatically merge changes from different branches. This typically happens when:

1. Two branches modify the same line in a file
2. One branch deletes a file while another modifies it
3. Two branches add a file with the same name but different content

Learning to resolve conflicts is an essential skill for any Git user.

## Understanding Conflict Markers

When Git encounters a conflict, it modifies the affected files to show both versions of the conflicting content, separated by conflict markers:

```
<<<<<<< HEAD
This is the content from the current branch (HEAD)
=======
This is the content from the branch being merged
>>>>>>> branch-name
```

To resolve the conflict, you need to:
1. Edit the file to remove the conflict markers
2. Choose which content to keep (or combine them)
3. Save the file
4. Stage the resolved file with `git add`
5. Complete the merge with `git commit`

## Exercises

### Exercise 1: Creating and Resolving a Basic Conflict

1. Create a file with some content
2. Create a branch and modify a line in the file
3. Switch back to the main branch and modify the same line differently
4. Attempt to merge the branches and resolve the conflict

```bash
# Create a file in main branch
echo "Line 1\nLine 2\nLine 3\nLine 4" > basic-conflict.txt
git add basic-conflict.txt
git commit -m "Add basic-conflict.txt"

# Create and switch to a feature branch
git checkout -b feature/basic-conflict

# Modify Line 2 in the feature branch
sed -i '' 's/Line 2/Line 2 modified in feature branch/' basic-conflict.txt
git add basic-conflict.txt
git commit -m "Modify Line 2 in feature branch"

# Switch back to main and modify the same line
git checkout main
sed -i '' 's/Line 2/Line 2 modified in main branch/' basic-conflict.txt
git add basic-conflict.txt
git commit -m "Modify Line 2 in main branch"

# Try to merge the feature branch (this will cause a conflict)
git merge feature/basic-conflict

# You'll see a conflict message. Examine the file:
cat basic-conflict.txt

# Resolve the conflict by editing the file
# For example, keep both changes:
echo "Line 1\nLine 2 modified in main and feature branches\nLine 3\nLine 4" > basic-conflict.txt

# Stage the resolved file
git add basic-conflict.txt

# Complete the merge
git commit -m "Resolve conflict in basic-conflict.txt"

# Verify the merge is complete
git status
```

### Exercise 2: Resolving Multiple Conflicts

1. Create a file with multiple lines
2. Create a branch and modify several lines
3. Switch back to the main branch and modify the same lines differently
4. Attempt to merge the branches and resolve all conflicts

```bash
# Create a file in main branch
echo "Header\nSection 1\nSection 2\nSection 3\nFooter" > multiple-conflicts.txt
git add multiple-conflicts.txt
git commit -m "Add multiple-conflicts.txt"

# Create and switch to a feature branch
git checkout -b feature/multiple-conflicts

# Modify multiple lines in the feature branch
sed -i '' 's/Header/Header - Feature Version/' multiple-conflicts.txt
sed -i '' 's/Section 2/Section 2 - Updated in Feature/' multiple-conflicts.txt
sed -i '' 's/Footer/Footer - Feature Note/' multiple-conflicts.txt
git add multiple-conflicts.txt
git commit -m "Update multiple sections in feature branch"

# Switch back to main and modify the same lines
git checkout main
sed -i '' 's/Header/Header - Main Version/' multiple-conflicts.txt
sed -i '' 's/Section 2/Section 2 - Updated in Main/' multiple-conflicts.txt
sed -i '' 's/Footer/Footer - Main Note/' multiple-conflicts.txt
git add multiple-conflicts.txt
git commit -m "Update multiple sections in main branch"

# Try to merge the feature branch (this will cause multiple conflicts)
git merge feature/multiple-conflicts

# You'll see a conflict message. Examine the file:
cat multiple-conflicts.txt

# Resolve each conflict one by one
# For example:
echo "Header - Combined Version\nSection 1\nSection 2 - Updated in Both Branches\nSection 3\nFooter - Notes from Both Branches" > multiple-conflicts.txt

# Stage the resolved file
git add multiple-conflicts.txt

# Complete the merge
git commit -m "Resolve multiple conflicts in multiple-conflicts.txt"

# Verify the merge is complete
git status
```

### Exercise 3: Using Merge Tools

1. Configure a merge tool (if not already configured)
2. Create a conflict scenario
3. Use the merge tool to resolve the conflict

```bash
# Check available merge tools
git mergetool --tool-help

# Configure a merge tool (example with vimdiff)
git config --global merge.tool vimdiff
git config --global mergetool.prompt false

# Create a file in main branch
echo "First paragraph\nSecond paragraph\nThird paragraph" > mergetool-example.txt
git add mergetool-example.txt
git commit -m "Add mergetool-example.txt"

# Create and switch to a feature branch
git checkout -b feature/mergetool

# Modify the file in the feature branch
sed -i '' 's/Second paragraph/Second paragraph modified in feature/' mergetool-example.txt
git add mergetool-example.txt
git commit -m "Update second paragraph in feature branch"

# Switch back to main and modify the same paragraph
git checkout main
sed -i '' 's/Second paragraph/Second paragraph modified in main/' mergetool-example.txt
git add mergetool-example.txt
git commit -m "Update second paragraph in main branch"

# Try to merge the feature branch (this will cause a conflict)
git merge feature/mergetool

# Launch the merge tool to resolve the conflict
git mergetool

# After resolving with the merge tool, complete the merge
git commit -m "Resolve conflict using merge tool"

# Clean up backup files created by the merge tool
rm *.orig
```

### Exercise 4: Aborting a Merge

1. Create a conflict scenario
2. Start a merge that causes conflicts
3. Decide to abort the merge instead of resolving the conflicts

```bash
# Create a file in main branch
echo "Important data 1\nImportant data 2\nImportant data 3" > abort-example.txt
git add abort-example.txt
git commit -m "Add abort-example.txt"

# Create and switch to a feature branch
git checkout -b feature/abort-merge

# Make significant changes in the feature branch
echo "Completely different content\nThat would be hard to merge\nWith the original file" > abort-example.txt
git add abort-example.txt
git commit -m "Completely rewrite abort-example.txt in feature branch"

# Switch back to main and make different changes
git checkout main
echo "Important data 1 - updated\nImportant data 2 - critical update\nImportant data 3 - final version\nImportant data 4 - new addition" > abort-example.txt
git add abort-example.txt
git commit -m "Update and extend abort-example.txt in main branch"

# Try to merge the feature branch (this will cause complex conflicts)
git merge feature/abort-merge

# Examine the conflict
cat abort-example.txt

# Decide it's too complex and abort the merge
git merge --abort

# Verify that we're back to the pre-merge state
git status
cat abort-example.txt
```

### Exercise 5: Preventing Conflicts with Good Practices

1. Create a file with multiple sections
2. Create two branches that modify different sections
3. Merge without conflicts

```bash
# Create a structured file in main branch
echo "# Section 1\nContent for section 1\n\n# Section 2\nContent for section 2\n\n# Section 3\nContent for section 3" > structured-file.txt
git add structured-file.txt
git commit -m "Add structured-file.txt with clear sections"

# Create and switch to first feature branch
git checkout -b feature/section1

# Modify only Section 1
sed -i '' 's/Content for section 1/Updated content for section 1\nAdditional information for section 1/' structured-file.txt
git add structured-file.txt
git commit -m "Update Section 1 content"

# Switch back to main
git checkout main

# Create and switch to second feature branch
git checkout -b feature/section3

# Modify only Section 3
sed -i '' 's/Content for section 3/Updated content for section 3\nAdditional information for section 3/' structured-file.txt
git add structured-file.txt
git commit -m "Update Section 3 content"

# Merge first feature branch into main (should be clean)
git checkout main
git merge feature/section1

# Merge second feature branch into main (should also be clean)
git merge feature/section3

# Verify the final content
cat structured-file.txt
```

## Strategies to Minimize Conflicts

1. **Pull/Rebase Frequently**: Keep your branch updated with the latest changes from the main branch
2. **Small, Focused Commits**: Make small, logical commits that are easier to merge
3. **Modular Code Structure**: Organize code into modules/files to reduce the chance of multiple people editing the same file
4. **Clear Team Communication**: Communicate with your team about who is working on what
5. **Short-Lived Feature Branches**: Complete and merge feature branches quickly to reduce divergence
6. **Code Reviews**: Use code reviews to catch potential conflicts early

## Advanced Conflict Resolution Techniques

1. **Using `git checkout --ours` or `git checkout --theirs`**: Accept one version entirely
   ```bash
   git checkout --ours path/to/file  # Keep the version from the current branch
   git checkout --theirs path/to/file  # Keep the version from the branch being merged
   ```

2. **Using `git diff` to understand conflicts**:
   ```bash
   git diff  # Show the differences in the conflicted file
   ```

3. **Using `git log` to understand the context**:
   ```bash
   git log --merge -p path/to/file  # Show the commits that caused the conflict
   ```

## Conclusion

Conflict resolution is an inevitable part of collaborative development with Git. By understanding how conflicts occur and practicing resolution techniques, you can handle conflicts confidently and efficiently. Remember that conflicts aren't errors—they're a natural result of parallel development and Git's way of asking for human guidance on how to combine changes.