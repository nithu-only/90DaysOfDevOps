# Day 09 – Linux User & Group Management Challenge

## Task
Today's goal is to **practice user and group management** by completing hands-on challenges.

## Challenge Tasks

### Task 1: Create Users (20 minutes)

The users have been created by using
``` bash
# Here -m will create Homedirectory for user & -s specifies Shell type for the user
$ useradd -m -s /bin/bash <user-name>
# You can see the created users by 
$ cat /etc/passwd
```

![useradd](./user%20task-1.png)
---
### Task 2: Create Groups (10 minutes)

The Groups will be created using:

```bash
# Groups will be created using groupadd commnad
$ groupadd <group-name>
# You can see the groups by
$ cat /etc/group
```
![groupadd](./user%20task-2.png)

---
### Task 3: Assign to Groups (15 minutes)

We can add users to the groups using:
```bash
# Method 1:
$ usermod -aG <group-name> <user-name>
# Method 2:
$ gpasswd -a <user-name> <group-name>
```
![task3](./user%20task-3.png)

---

### Task 4: Shared Directory

1. Create directory: `/opt/dev-project`
2. Set group owner to `developers`
3. Set permissions to `775` (rwxrwxr-x)
4. Test by creating files as `tokyo` and `berlin`

![task4](./user%20task-4.png)

---

### Task 5: Team Workspace (20 minutes)

1. Create user `nairobi` with home directory
2. Create group `project-team`
3. Add `nairobi` and `tokyo` to `project-team`
4. Create `/opt/team-workspace` directory
5. Set group to `project-team`, permissions to `775`
6. Test by creating file as `nairobi`

![task5](./user%20task-5.png)

