**\### Day 23 -- Git Branching & Working with GitHub**

**\## Task 1: Understanding Branches**

> **1. What is a branch in Git?**
>
> A branch in Git is a lightweight, movable pointer to a commit. It represents an independent line of development where changes can be made without affecting other branches.
>
> **2. Why do we use branches instead of committing everything to main?**
>
> Branches allow developers to:
>
> \- Work on features or bug fixes safely
>
> \- Experiment without breaking stable code
>
> \- Collaborate with multiple developers simultaneously
>
> \- Keep the main branch production-ready
>
> **3. What is HEAD in Git?**
>
> HEAD is a pointer that refers to the current branch and the latest commit you are working on. It tells Git where you are in the repository history.
>
> **4. What happens to your files when you switch branches?**
>
> When switching branches, Git updates the working directory to match the snapshot of the selected branch. Files may change, appear, or disappear based on the branch\'s commits.

**\## Task 2: Branching Commands --- Hands-On**

1.  **List all branches in your repo**

> Git branch

2.  **Create a new branch called feature-1**

> git branch feature-1

3.  **Switch to feature-1**

> git switch feature-1

4.  **Create a new branch and switch to it in a single command --- call it feature-2**

> git switch -c feature-2

5.  **Try using git switch to move between branches --- how is it different from git checkout?**

> git switch → Only for switching or creating branches.
>
> git checkout → Multi-purpose: switch branches, create branches, restore files, or check out commits.

6.  **Make a commit on feature-1 that does not exist on main**

> git switch feature-1
>
> echo \"Feature work\" \>\> feature.txt
>
> git add .
>
> git commit -m \"Added feature work\"

7.  **Switch back to main --- verify that the commit from feature-1 is not there**

> git switch main
>
> The commit made on feature-1 is not visible on main.

8.  **Delete a branch you no longer need**

> git branch -d feature-2

**\## Task 3: Push to GitHub**

1.  **Create a new repository on GitHub (do NOT initialize it with a README)**

2.  **Connect your local devops-git-practice repo to the GitHub remote**

> git remote add origin https://github.com/\....devops-git-practice.git

3.  **Push your main branch to GitHub**

> git push -u origin main

4.  **Push feature-1 branch to GitHub**

> git push -u origin feature-1

5.  **Verify both branches are visible on GitHub**

6.  **Answer in your notes: What is the difference between origin and upstream?**

> origin: the default remote name pointing to the repository.
>
> upstream: refers to the original repository forked from.

**\## Task 4: Pull from GitHub**

1.  **Make a change to a file directly on GitHub (use the GitHub editor)**

2.  **Pull that change to your local repo**

> git pull origin main

3.  **Answer in your notes: What is the difference between git fetch and git pull?**

> git fetch downloads new changes from remote but does NOT merge them.
>
> git pull downloads changes AND merges them into the current branch.

**\## Task 5: Clone vs Fork**

1.  **Clone any public repository from GitHub to your local machine**

> git clone https://github.com/\... /repo.git

2.  **Fork the same repository on GitHub, then clone your fork**

3.  **Answer in your notes:**

- **What is the difference between clone and fork?**

> Clone: copies a repository to your local machine.
>
> Fork: creates your own copy of someone else's repository on GitHub.

- **When would you clone vs fork?**

> Clone when you want a local copy of a repo you control.
>
> Fork when you want to contribute to someone else\'s project.

- **After forking, how do you keep your fork in sync with the original repo?**

> git remote add upstream https://github.com/\.../repo.git
>
> git fetch upstream
>
> git merge upstream/main
