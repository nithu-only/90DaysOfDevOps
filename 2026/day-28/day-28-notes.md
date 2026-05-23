**\### Day 28 -- Revision Day: Everything from Day 1 to Day 27**

**  
\## Task:1 Self-Assessment Checklist**

**Linux**

- Navigate the filesystem: ls, cd, pwd, mkdir, rm, mv, cp ✅

- Processes: ps aux, top, kill, jobs, bg, fg ✅

- systemd: systemctl start/stop/status/enable ✅

- Edit text: vi/vim or nano ✅

- Troubleshooting: top, free -h, df -h, du -sh ✅

- File system hierarchy: know /etc (configs), /var (logs), /home (users), /tmp (temporary), /boot (kernel) ✅

- Users/groups: useradd, groupadd, passwd ✅

- File permissions: chmod 755 file (numeric), chmod u+x file (symbolic) ✅

- Ownership: chown user:group file ✅

- LVM: pvcreate, vgcreate, lvcreate ✅

- Networking: ping, curl, netstat -tulnp, ss, dig, nslookup ✅

- DNS/IP/subnet/ports: understand A record, subnet mask, default gateway, ports like 22, 80, 443 ✅

> **Shell Scripting**

- Variables, arguments, input: read, \$1, \$2 ✅

- Conditional logic: if/elif/else, case ✅

- Loops: for, while, until ✅

- Functions: my_func() { } ✅

- Text processing: grep, awk, sed, sort, uniq ✅

- Error handling: set -euo pipefail, trap ✅

- Scheduling: crontab -e ✅

- Variables, arguments, input: read, \$1, \$2 ✅

- Conditional logic: if/elif/else, case ✅

- Loops: for, while, until ✅

- Functions: my_func() { } ✅

- Text processing: grep, awk, sed, sort, uniq

- Error handling: set -euo pipefail, trap ✅

- Scheduling: crontab -e ✅

> **Git & GitHub**

- Initialize, commit, view history: git init, git add ., git commit -m \"msg\", git log ✅

- Branching: git branch, git checkout, git switch ✅

- Push/pull: git push, git pull ✅

- Clone vs fork: clone = copy repo locally, fork = copy to your account ✅

- Merge/rebase: fast-forward vs merge commit, rebase to keep linear history ✅

- Stash: git stash, git stash pop ✅

- Cherry-pick: git cherry-pick \<commit\> ✅

- Reset vs revert: reset changes history, revert creates new commit ✅

- Branching strategies: GitFlow, GitHub Flow, Trunk-Based ✅

- GitHub CLI: gh repo create, gh pr create ✅

**\## Task 2: Revisit Weak Spots**

> **1. LVM (Logical Volume Manager)**

**Commands Practiced:**

> \# Create a physical volume
>
> sudo pvcreate /dev/sdb
>
> \# Create a volume group
>
> sudo vgcreate vg_data /dev/sdb
>
> \# Create a logical volume of 5G
>
> sudo lvcreate -n lv_backup -L 5G vg_data
>
> \# Format the logical volume
>
> sudo mkfs.ext4 /dev/vg_data/lv_backu
>
> \# Mount it
>
> sudo mkdir /mnt/backup
>
> sudo mount /dev/vg_data/lv_backup /mnt/backup
>
> \# Check status
>
> lsblk
>
> sudo pvs
>
> sudo vgs
>
> sudo lvs
>
> **What I re-learned:**

- PV (Physical Volume): Raw disk or partition used by LVM.

- VG (Volume Group): Pool of space combining one or more PVs.

- LV (Logical Volume): Flexible "partition" from VG, can grow/shrink easily.

- LVM allows dynamic resizing, snapshots, and easier management vs traditional partitions.

- Always check with lsblk or lvs to verify mount points and sizes.

> **2. Error Handling in Shell Scripting**
>
> **Script Practiced:**
>
> \#!/bin/bash
>
> set -euo pipefail \# exit on error, unset vars, fail on pipe error
>
> trap \'echo \"Error occurred at line \$LINENO\"; exit 1\' ERR
>
> echo \"Starting backup script\...\"
>
> \# Simulate a command that may fail
>
> cp /nonexistent/file /tmp/
>
> echo \"Backup completed successfully.\"
>
> **What I re-learned:**

- set -e → script exits if any command fails.

- set -u → script exits if an unset variable is used.

- set -o pipefail → pipe fails if any command in the chain fails.

- trap \'\...\' ERR → custom error handling (prints line number and exits).

- This ensures scripts fail safely and errors are easy to debug.

- Best practice for automation and cron jobs.

> **3. Git Reset**
>
> **Commands Practiced:**
>
> \# Create a test commit
>
> git commit -m \"Test commit\"
>
> \# Soft reset: keep changes staged
>
> git reset \--soft HEAD\~1
>
> \# Mixed reset: keep changes unstaged (default)
>
> git reset HEAD\~1
>
> \# Hard reset: discard changes completely
>
> git reset \--hard HEAD\~1
>
> \# Check history
>
> git log \--oneline
>
> **What I re-learned:**

- git reset rewrites commit history; useful for local cleanup.

- \--soft → keeps changes staged (ready to commit).

- \--mixed → keeps changes unstaged.

- \--hard → discards all local changes; use carefully!

- Difference from git revert: revert creates a new commit that undoes changes (safe for shared branches).

- Practical scenario: I used reset to undo my last commit before pushing, fixing mistakes without affecting remote.

**\## Task 3: Quick-Fire Questions**

1.  **What does chmod 755 script.sh do?**

Owner: read/write/execute, Group: read/execute, Others: read/execute

2.  **What is the difference between a process and a service?**

Process: running program, Service: background process managed by systemd/init.

3.  **How do you find which process is using port 8080?**

lsof -i :8080 or netstat -tulnp \| grep 8080.

4.  **What does set -euo pipefail do in a shell script?**

-e exit on error, -u exit on unset variable, -o pipefail fail on first command in pipe that fails.

5.  **What is the difference between git reset \--hard and git revert?**

resets commit history + working directory; git revert → creates a new commit that undoes changes.

6.  **What branching strategy would you recommend for a team of 5 developers shipping weekly?**

Branching strategy for 5 devs → GitHub Flow or Trunk-Based for weekly shipping.

7.  **What does git stash do and when would you use it?**

saves uncommitted changes to stack; use to switch branches safely.

8.  **How do you schedule a script to run every day at 3 AM?**

0 3 \* \* \* / path/to/script.sh

9.  **What is the difference between git fetch and git pull?**

git fetch → download changes, git pull → fetch + merge.

> **10.What is LVM and why would you use it instead of regular partitions?**
>
> Logical Volume Manager; allows dynamic resizing, snapshots, easier management vs static partitions**.**
>
> **\## Task 5: Teach It Back**

**Linux file permissions:**

> Linux uses a permission system to control who can access files. Each file has three permission types: read (r), write (w), execute (x), for three groups: owner, group, others. chmod changes these permissions, e.g., chmod 755 file allows the owner full access and others read/execute. Proper permissions protect files from unauthorized changes and maintain system security.
