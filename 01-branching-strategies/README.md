# Branching Strategies

This directory contains exercises to help you understand and practice different Git branching strategies.

## Overview

Branching is a fundamental concept in Git that allows developers to diverge from the main line of development and work independently without affecting the main codebase. Different projects may adopt different branching strategies based on their specific needs.

## Common Branching Strategies

### 1. Git Flow

Git Flow is a branching model that defines specific branch types and how they should interact:

- **Main Branches**:
  - `main` (or `master`): Production-ready code
  - `develop`: Latest delivered development changes

- **Supporting Branches**:
  - `feature/*`: New features
  - `release/*`: Preparation for a new production release
  - `hotfix/*`: Urgent fixes for production issues
  - `bugfix/*`: Non-urgent bug fixes

### 2. GitHub Flow

A simpler alternative to Git Flow:

- Single `main` branch
- Feature branches created directly from `main`
- Pull requests for code review
- Merge back to `main` after approval
- Deploy immediately after merge

### 3. GitLab Flow

Combines Git Flow and GitHub Flow:

- `main` branch represents production
- Feature branches for development
- Environment branches (`staging`, `production`)
- Merge requests for code review

## Exercises

### Exercise 1: Basic Branching

1. Create a new file called `feature1.txt` in the main branch
2. Create a new branch called `feature/login`
3. Add a new file called `login.txt` in the feature branch
4. Make some changes to `feature1.txt` in the feature branch
5. Switch back to the main branch and observe that your changes are not visible
6. Switch back to the feature branch and confirm your changes are still there

```bash
# Create a file in main branch
echo "This is the main branch file" > feature1.txt
git add feature1.txt
git commit -m "Add feature1.txt in main branch"

# Create and switch to a feature branch
git checkout -b feature/login

# Add a new file in the feature branch
echo "Login functionality" > login.txt
git add login.txt
git commit -m "Add login.txt in feature branch"

# Modify the existing file in the feature branch
echo "Modified in feature branch" >> feature1.txt
git add feature1.txt
git commit -m "Modify feature1.txt in feature branch"

# Switch back to main branch
git checkout main

# Verify changes are not visible in main branch
cat feature1.txt

# Switch back to feature branch
git checkout feature/login

# Verify changes are visible in feature branch
cat feature1.txt
```

### Exercise 2: Implementing Git Flow

1. Create a `develop` branch from `main`
2. Create a `feature/registration` branch from `develop`
3. Make some changes in the feature branch
4. Merge the feature branch back to `develop`
5. Create a `release/1.0` branch from `develop`
6. Make some final adjustments in the release branch
7. Merge the release branch to both `main` and `develop`

```bash
# Create develop branch
git checkout main
git checkout -b develop

# Create feature branch
git checkout -b feature/registration develop

# Make changes in feature branch
echo "Registration functionality" > registration.txt
git add registration.txt
git commit -m "Add registration functionality"

# Merge feature branch to develop
git checkout develop
git merge --no-ff feature/registration -m "Merge feature/registration into develop"

# Create release branch
git checkout -b release/1.0 develop

# Make final adjustments
echo "Version 1.0" > version.txt
git add version.txt
git commit -m "Prepare for 1.0 release"

# Merge release branch to main
git checkout main
git merge --no-ff release/1.0 -m "Merge release/1.0 into main"

# Tag the release
git tag -a v1.0 -m "Version 1.0"

# Merge release branch back to develop
git checkout develop
git merge --no-ff release/1.0 -m "Merge release/1.0 back into develop"

# Delete the release branch
git branch -d release/1.0
```

### Exercise 3: Implementing GitHub Flow

1. Create a `feature/profile` branch from `main`
2. Make changes in the feature branch
3. Push the branch to the remote repository (simulated)
4. Create a pull request (simulated)
5. Merge the feature branch to `main`

```bash
# Create feature branch
git checkout main
git checkout -b feature/profile

# Make changes
echo "User profile functionality" > profile.txt
git add profile.txt
git commit -m "Add user profile functionality"

# Simulate pushing to remote
echo "git push origin feature/profile"

# Simulate pull request and code review
echo "Create pull request on GitHub"
echo "Review code"
echo "Approve pull request"

# Merge to main
git checkout main
git merge --no-ff feature/profile -m "Merge feature/profile into main"

# Delete feature branch
git branch -d feature/profile
```

## When to Use Each Strategy

- **Git Flow**: Larger projects with scheduled releases and multiple versions in production
- **GitHub Flow**: Smaller teams, continuous delivery, web applications
- **GitLab Flow**: Projects that deploy to multiple environments

## Best Practices

1. **Keep branches focused**: Each branch should represent a single feature or fix
2. **Regular updates**: Keep your branches updated with the latest changes from the main branch
3. **Delete merged branches**: Clean up branches after they've been merged
4. **Meaningful commit messages**: Write clear commit messages that explain the purpose of the change
5. **Code review**: Use pull/merge requests for code review before merging

## Conclusion

Understanding different branching strategies helps you choose the right approach for your project. Practice these exercises to get comfortable with branching and merging in Git.