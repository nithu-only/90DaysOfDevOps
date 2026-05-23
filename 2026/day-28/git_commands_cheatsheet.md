# Git & GitHub Commands Cheat Sheet

## Repository Initialization
```
git init             # Initialize a new repository
git clone <url>      # Clone a repo locally
git remote add origin <url>   # Link local repo to remote
```

## Staging & Committing
```
git add <file>       # Stage file(s)
git add .            # Stage all changes
git commit -m "msg"  # Commit staged changes
git status           # Check current status
git log --oneline    # View commit history
```

## Branching
```
git branch           # List branches
git branch <name>    # Create new branch
git checkout <branch> | git switch <branch> # Switch branch
git checkout -b <branch> | git switch -c <branch> # Create + switch
```

## Merging & Rebasing
```
git merge <branch>   # Merge branch into current
git rebase <branch>  # Rebase current onto another branch
git merge --squash <branch>  # Combine all commits from branch
```

## Reset & Revert
```
git reset --soft HEAD~1   # Undo last commit, keep changes staged
git reset --mixed HEAD~1  # Undo last commit, unstaged changes
git reset --hard HEAD~1   # Undo last commit, discard changes
git revert <commit>       # Create a new commit that undoes changes
```

## Cherry-pick
```
git cherry-pick <commit>  # Apply specific commit from another branch
```

## Stashing
```
git stash           # Save uncommitted changes
git stash pop       # Apply and remove last stash
git stash list      # List stashes
```

## Remote Operations
```
git push origin <branch>     # Push changes to remote
git pull origin <branch>     # Fetch + merge from remote
git fetch origin             # Fetch changes from remote without merging
```

## GitHub Concepts
- **Fork**: Copy of a repo under your account
- **Clone**: Copy of a repo locally
- **Pull Request**: Merge request from feature branch to main branch

## Branching Strategies
- **GitFlow**: feature, develop, release, main/master
- **GitHub Flow**: main branch + short-lived feature branches
- **Trunk-Based Development**: everyone commits to main/trunk frequently

## GitHub CLI
```
gh repo create              # Create repo on GitHub
gh pr create                # Create Pull Request
gh issue create             # Create GitHub issue
gh auth login               # Authenticate CLI with GitHub
```

