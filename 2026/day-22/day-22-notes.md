**### Day 22 – Introduction to Git: Your First Repository## Quick Reference Table**

**##Task 1: Install & Configure Git**

    **Verify installation**
    	git --version


    **Set identity**
    	git config --global user.name "Axata"
        git config --global user.email "staraxu@gmail.com"

    ** Verify configuration**
    	git config --list

**## Task 2: Create Your Git Project**

    **Create project folder**
    **
        mkdir devops-git-practice

        cd devops-git-practice
    **Initialize Git repository**

        git init

    ** Check repository status**
    **
        git status

    ** Explore hidden .git folder**
    **
        ls –a

**## Task 3: Create git-commands.md**

    **Create file:**
    **
        touch git-commands.md

    **File Content:**

    \# Git Commands Reference

    \## Setup & Config

    \### git config

    Sets user identity

    Example:

    git config --global user.name "Axata"

    \---

    \## Basic Workflow

    \### git init

    Creates a new repository

    Example:

    git init

    \### git add

    Stages files for commit

    Example:

    git add git-commands.md

    \### git commit

    Saves snapshot of staged files

    Example:

    git commit -m "Add git commands file"

    \---

    \## Viewing Changes

    \### git status

    Shows file state

    Example:

    git status

    \### git log

    Shows commit history

    Example:

    git log

**## Task 4: Stage & Commit**

	** Stage file**
		git add git-commands.md

     **Check staged files**
		git status

	** Commit**
		git commit -m "Initial commit: add git commands reference"

	**View history**
		git log

**## Task 5: Build Commit History**

    **See changes**
        git diff

     **Stage & commit again**
        git add .
        git commit -m "Add viewing and restore commands"

    **Compact history view**
        git log

**## Task 6: Create day-22-notes.md**

    **Git Workflow:**
        **Working Directory → Staging Area → Repository**
        **edit            git add         git commit**

    **Create file:**
        touch day-22-notes.md

    **Content:**\
        # Day 22 Notes
        \## 1. Difference between git add and git commit

        git add moves changes to the staging area.

        git commit permanently saves those staged changes to the repository.

        \## 2. What does the staging area do?

        The staging area lets you prepare and review changes before committing.

        It allows selective commits instead of committing everything.

        \## 3. What information does git log show?

        It shows commit history including:

        \- commit ID

        \- author

        \- date

        \- commit message

        \## 4. What is the .git folder?

        .git stores all repository history, commits, and configuration.

        Deleting it removes version control and history.

        \## 5. Working directory vs staging vs repository

        Working directory → files you edit

        Staging area → files ready to commit

        Repository → saved history of commits


        **	

