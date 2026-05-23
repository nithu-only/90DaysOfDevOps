**\### Day 25 -- Git Reset vs Revert & Branching Strategies**

**\## Task 1: Git Reset --- Hands-On**

**🔹 git reset \--soft HEAD\~1**

> Moves HEAD back one commit.
>
> **What happens:**

- Commit C is removed from history

- Changes remain staged

- Ready to recommit

> **Use case:** Fix last commit message or combine commits.

**🔹 git reset \--mixed HEAD\~1 (default)**

> Moves HEAD back one commit.
>
> **What happens:**

- Commit C removed

- Changes remain in working directory

- Changes are unstaged

> **Use case:** Re-edit or reorganize changes before recommitting.

🔹 **git reset \--hard HEAD\~1**

> Moves HEAD back one commit.
>
> **What happens:**

- Commit C removed

- Changes permanently deleted

- Working directory restored to previous state

> **Use case:** Discard unwanted changes completely.

**What is the difference between \--soft, \--mixed, and \--hard?**

| **Option** | **Commit Removed** | **Changes Staged** | **Changes Kept** | **Safe** |
|------------|--------------------|--------------------|------------------|----------|
| \--soft    | Yes                | Yes                | Yes              | Yes      |
| \--mixed   | Yes                | No                 | Yes              | Yes      |
| \--hard    | Yes                | No                 | No               | No       |

**Which is destructive and why?**

> git reset \--hard is destructive because it permanently deletes uncommitted changes.

**When to use each?**

> **\--soft**

- fix commit message

- squash commits

> **\--mixed**

- reorganize changes

- modify files before recommitting

> **\--hard**

- discard mistakes

- remove unwanted changes

**Should you use reset on pushed commits?**

No --- it rewrites history and breaks collaboration.

> Use revert instead.

**\## Task 2: Git Rebase --- Observations**

**After commits: X → Y → Z**

> **Command:**
>
> git revert \<commit-hash-of-Y\>

**What happens?**

- New commit created that undoes changes from Y

- History remains intact

**Is commit Y still in history?**

> Yes --- Git adds a new commit that reverses it.

**How is revert different from reset?**

| **Reset**                     | **Revert**          |
|-------------------------------|---------------------|
| Rewrites history              | Preserves history   |
| Removes commits               | Creates undo commit |
| Dangerous for shared branches | Safe for teams      |

**Why is revert safer?**

> Because it does not change commit history, preventing conflicts for collaborators.

**When to use revert vs reset?**

- **Use revert when:**

  - **commits are pushed**

  - **working with a team**

  - **undoing specific commit safely**

- **Use reset when:**

  - **working locally**

  - **fixing recent mistakes**

  - **cleaning commit history before push**

**\## Task 3: Reset vs Revert --- Summary**

| **Feature**                     | **Git reset**                | **Git revert**                         |
|---------------------------------|------------------------------|----------------------------------------|
| What it does                    | Moves HEAD & removes commits | Creates new commit that undoes changes |
| Removes commit from history     | Yes                          | No                                     |
| Safe fir shared/pushed branches | No                           | Yes                                    |
| When to use                     | Local cleanup                | Undo changes safely in team projects   |

**\## Task 4: Branching Strategies**

1.  **GitFlow Strategy**

**How it works**

- main → production code

- develop → integration branch

- feature branches → new work

- release branches → prep for release

- hotfix branches → urgent fixes

**Flow**

> main
>
> └── develop
>
> ├── feature/login
>
> ├── feature/payment
>
> └── release/v1.0
>
> └── hotfix/v1.0.1

**Used when**

- large teams

- scheduled releases

- enterprise software

**Pros**

- organized workflow

- stable releases

- supports parallel development

**Cons**

- complex

- slow for fast-moving teams

2.  **GitHub Flow**

**How it works**

- single main branch

- create feature branch

- open pull request

- review & merge

**Flow**

> main
>
> └── feature-branch
>
> └── Pull Request → Merge

**Used when**

- continuous deployment

- SaaS products

- agile teams

**Pros**

- simple & fast

- easy collaboration

- great for CI/CD

**Cons**

> less structure for large releases

3.  **Trunk-Based Development**

**How it works**

- developers commit frequently to main (trunk)

- short-lived branches (hours/days)

- heavy use of CI

**Flow**

> main (trunk)
>
> ├── short-lived branch → merge quickly
>
> ├── short-lived branch → merge quickly

**Used when**

- high-speed delivery

- DevOps & CI/CD environments

- companies like Google & Facebook

**Pros**

- fast integration

- fewer merge conflicts

- supports continuous delivery

**Cons**

- requires strong testing & CI

- discipline required

**Strategy Selection Answers**

**Startup shipping fast:**

> Trunk-Based Development or GitHub Flow

**Large team with scheduled releases:**

> GitFlow

**Open-source example:**

> Many projects like Kubernetes use a GitHub Flow--style workflow with pull requests and reviews.

**\## Task 5: Git Commands Reference Update**

**Setup & Config**

> git config \--global user.name \"Name\"
>
> git config \--global user.email \"email\"
>
> git init
>
> **Basic Workflow**
>
> git status
>
> git add .
>
> git commit -m \"message\"
>
> git log
>
> git diff
>
> **Branching**
>
> git branch
>
> git checkout branch-name
>
> git switch branch-name
>
> git merge branch-name
>
> **Remote Repositories**
>
> git clone URL
>
> git push origin main
>
> git pull
>
> git fetch
>
> **Merging & Rebasing**
>
> git merge branch
>
> git rebase main
>
> **Stash & Cherry Pick**
>
> git stash
>
> git stash pop
>
> git cherry-pick \<commit\>
>
> **Reset & Revert**
>
> git reset \--soft HEAD\~1
>
> git reset \--mixed HEAD\~1
>
> git reset \--hard HEAD\~1
>
> git revert \<commit\>
