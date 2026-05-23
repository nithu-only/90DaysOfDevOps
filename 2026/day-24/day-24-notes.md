**\### Day 23 -- Advanced Git: Merge, Rebase, Stash & Cherry Pick**

**\## Task 1: Git Merge --- Hands-On**

> **Fast-forward merge (feature-login)**
>
> When merging feature-login into main without new commits on main, Git performed a fast-forward merge.
>
> **What is a fast-forward merge?**
>
> A fast-forward merge happens when the main branch has not moved ahead. Git simply moves the branch pointer forward --- no extra merge commit is created.

**Merge commit scenario (feature-signup)**

> After adding commits to both main and feature-signup, merging created a merge commit.
>
> **When does Git create a merge commit?**
>
> When both branches have diverged, Git combines histories and creates a merge commit to preserve both timelines.
>
> **Merge Conflict**
>
> A merge conflict occurs when the same line of the same file is modified in both branches.
>
> Git pauses the merge and asks for manual resolution.

**\## Task 2: Git Rebase --- Observations**

1.  **What does rebase do?**

> Rebase replays your branch commits on top of the latest base branch.

2.  **How history differs from merge**

- Merge preserves branching history.

- Rebase creates a clean, linear history.

3.  **Why never rebase shared commits?**

> Rebase rewrites commit history. If others already pulled those commits, it causes conflicts and duplicate histories.

4.  **When to use rebase vs merge**

- Use rebase → to keep history clean before merging.

- Use merge → when preserving history and collaboration context is important.

**\## Task 3: Squash Commit vs Merge**

> **Squash merge (feature-profile)**
>
> Merged using:
>
> git merge \--squash feature-profile
>
> **Result:**
>
> All commits combined into one single commit.
>
> **git log:** only one new commit added.
>
> **Regular merge (feature-settings)**
>
> Merged normally → all commits preserved.
>
> **What does squash merging do?**
>
> Combines multiple commits into one before merging.
>
> **When to use squash merge**

- Feature branches with many small commits

- Cleaning up messy history

- Pull requests before merging

> **Trade-off**
>
> ✔ Clean history
>
> ✖ Loses detailed commit history

**\## Task 4: Git Stash --- Hands-On**

> **When switching branches with uncommitted changes, Git blocked the switch.**
>
> Save work-in-progress
>
> git stash push -m \"WIP login styling\"
>
> Switch branches safely.
>
> **Restore changes**
>
> git stash pop
>
> **Multiple stashes**
>
> git stash list
>
> git stash apply stash@{1}
>
> **Difference:** stash pop vs stash apply

- pop → restores AND removes stash

- apply → restores but keeps stash

> **When stash is useful**

- urgent bug fix while mid-feature

- switching branches quickly

- experimenting without committing

**\## Task 5: Cherry Picking**

> **Cherry-picked the second commit from feature-hotfix:**
>
> git cherry-pick \<commit-hash\>
>
> Only that commit was applied to main.

**What does cherry-pick do?**

> Applies a specific commit from another branch.
>
> **When to use it**

- applying a hotfix to production

- bringing one feature without merging whole branch

- backporting fixes to older releases

> **What can go wrong**

- duplicate commits

- conflicts

- messy history if overused
