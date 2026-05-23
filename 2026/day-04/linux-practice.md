# Day 04 – Linux Practice: Processes and Services

> Goal: Practice core Linux commands for processes, services, and logs.
> System used: Ubuntu (systemd-based)
> Service inspected: **ssh**

---

## Process Checks

### 1. List running processes

ps aux | head -10

**Output (sample):**

USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.1 169084  1312 ?        Ss   09:01   0:01 /sbin/init
root         678  0.0  0.3  72232  3420 ?        Ss   09:01   0:00 /lib/systemd/systemd-journald

### 2. Check process activity interactively

top

**Observation:**

* Identified CPU and memory usage
* Verified system is mostly idle

### 3. Find PID of a specific process

pgrep sshd

**Output:**

812


## Service Checks

### 4. Check status of SSH service

systemctl status ssh

**Output (key lines):**

● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled)
     Active: active (running)

### 5. List running services

systemctl list-units --type=service --state=running | head

**Observation:**

* Verified multiple core services are running
* Confirmed ssh.service is active

---

## Log Checks

### 6. View logs for SSH service

journalctl -u ssh --no-pager | tail -n 10

**Output (sample):**

Jan 29 09:10:15 server sshd[812]: Server listening on 0.0.0.0 port 22.
Jan 29 09:10:15 server sshd[812]: Server listening on :: port 22.

### 7. Check system log entries

tail -n 50 /var/log/syslog

**Observation:**

* No critical errors
* Normal system activity observed

---

## Mini Troubleshooting Flow

**Scenario:** SSH service not responding

1. Check service status

systemctl status ssh

2. If stopped, start service

sudo systemctl start ssh

3. Verify process is running

pgrep sshd

4. Inspect logs for errors

journalctl -u ssh --since "10 minutes ago"


**Result:**

* Service running successfully
* No errors found in logs

---

## Key Takeaways

* `ps`, `top`, and `pgrep` help quickly identify process health
* `systemctl` is essential for managing services
* `journalctl` and `tail` are critical for troubleshooting

---

## Resources

* `man ps`
* `man systemctl`
* `man journalctl`
* Linux Foundation Docs
