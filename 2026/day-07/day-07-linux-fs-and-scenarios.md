# Day 07 – Linux File System Hierarchy & Scenario Practice

# Part 1 – Linux File System Hierarchy

## Core Directories

### `/` (Root)

Starting point of the entire file system.
I would use this when navigating absolute paths.

### `/home`

Contains user home directories.
Example seen: user folders like `/home/nithin`.
I would use this when accessing user files.

### `/root`

Home directory for root user.
I would use this when logged in as root.

### `/etc`

Contains system configuration files.
Example: `/etc/hostname`, `/etc/ssh/sshd_config`.
I would use this when modifying service configurations.

### `/var/log`

Stores log files for services and system.
Example: `syslog`, `auth.log`.
I would use this when troubleshooting errors.

### `/tmp`

Temporary files stored here.
I would use this for temporary scripts or test files.

## Additional Directories

### `/bin`

Essential system command binaries.
Example: `ls`, `cp`, `mv`.
Used during basic system operations.

### `/usr/bin`

User-level command binaries.
Used when running most installed programs.

### `/opt`

Optional or third-party software installations.
Used when installing custom applications.

## Hands-On Commands

### Find Largest Logs

``` python
$ du -sh /var/log/* 2>/dev/null | sort -h | tail -5
# To get the largest log files for troubleshooting.
```



### View Hostname Config

```python
$ cat /etc/hostname
# To check the system hostname.
```



### Check Home Directory

```python
$ ls -la ~
```

Viewed hidden files and permissions.

# Part 2 – Scenario-Based Practice

## Scenario 1: Service Not Starting (myapp)

Step 1: `systemctl status myapp`
Why: Check if service is failed or inactive.

Step 2: `journalctl -u myapp -n 50`
Why: Review recent logs for errors.

Step 3: `systemctl is-enabled myapp`
Why: Verify if service starts on boot.

Step 4: `systemctl restart myapp`
Why: Attempt controlled restart after checking logs.

## Scenario 2: High CPU Usage

Step 1: `top`
Why: View live CPU usage.

Step 2: `ps aux --sort=-%cpu | head -10`
Why: Identify highest CPU-consuming processes.

Step 3: `ps -o pid,pcpu,pmem,comm -p <PID>`
Why: Inspect specific process details.

## Scenario 3: Finding Docker Logs

Step 1: `systemctl status docker`
Why: Confirm service is active.

Step 2: `journalctl -u docker -n 50`
Why: View last 50 log lines.

Step 3: `journalctl -u docker -f`
Why: Follow logs in real time.

## Scenario 4: File Permission Issue

Step 1: `ls -l /home/user/backup.sh`
Why: Check current permissions.

Step 2: `chmod +x /home/user/backup.sh`
Why: Add execute permission.

Step 3: `ls -l /home/user/backup.sh`
Why: Confirm permission updated.

Step 4: `./backup.sh`
Why: Test execution.

