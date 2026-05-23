## Day 06 – Linux File System Hierarchy & Scenario-Based Practice

## Part 1: Linux File System Hierarchy
     1. / (root)
          **What it contains:**  
          The top-level directory. Every file and directory in Linux starts from here.

          **Command run:**
          ls -l /
          **Noted folders: bin, etc, home, var

          **I would use this when:**
          I want to understand the overall system structure or navigate to any core directory.

     2. /home
          **What it contains:**
          Home directories for all normal users. Each user stores personal files and configs here.

          **Command run:**
          ls -l /home
          **Noted folders: user directories (e.g., ubuntu, axata)

          **I would use this when:**
          I need to check user files, scripts, SSH keys, or application files owned by a user.

     3. /root
          **What it contains:**
          Home directory for the root (admin) user.

          **Command run:**
          ls -l /root
          **Noted folders/files: .bashrc, scripts

          **I would use this when:**
          I am logged in as root and need to access admin-specific files or scripts.

     4. /etc
          **What it contains:**
          System-wide configuration files.

          **Command run:**
          ls -l /etc
          **Noted files: hostname, hosts, ssh/

          **I would use this when:**
          I need to change or inspect configuration for services or the system itself.

     5. /var/log
          **What it contains:**
          Log files for system services, applications, and the kernel.

          **Command run:**
          ls -l /var/log
          **Noted files: syslog, auth.log, journal/

          **I would use this when:**
          A service fails, the server behaves oddly, or I need to investigate incidents.

     6. /tmp
          **What it contains:**
          Temporary files used by applications. Cleared on reboot.

          **Command run:**
          ls -l /tmp
          **Noted files: temp files, sockets

          **I would use this when:**
          Applications need short-lived storage or during troubleshooting tests.

     7. /bin
          **What it contains:**
          Essential system commands required for basic operation.

          **Command run:**
          ls -l /bin
          **Noted binaries: ls, cp, mv, bash

          **I would use this when:**
          The system is in minimal or recovery mode.

     8. /usr/bin
          **What it contains:**
          Most user-level command binaries.

          **Command run:**
          ls -l /usr/bin | head
          **Noted binaries: git, docker, python

          **I would use this when:**
          Running standard user commands and tools.

     9. /opt
          **What it contains:**
          Optional or third-party applications.

          **Command run:**
          ls -l /opt
          **Noted folders: vendor apps (if installed)

          **I would use this when:**
          Managing manually installed software outside package managers.

## Hands-on Tasks
     1. Find largest log files:
     du -sh /var/log/* 2>/dev/null | sort -h | tail -5
     Output:
          156K    /var/log/syslog
          188K    /var/log/apt
          264K    /var/log/dpkg.log
          376K    /var/log/syslog.1
          18M     /var/log/journal

     2. Look at a config file in /etc: 
     cat /etc/hostname
     Output:
          ubuntu

     3. Check your home directory:
     ls -la ~
     Output:
          total 36
          drwx------  4 root root 4096 Jan 21 14:56 .
          drwxr-xr-x 22 root root 4096 Jan 21 14:56 ..
          -rw-------  1 root root   10 Feb 10  2025 .bash_history
          -rw-r--r--  1 root root 3194 Jan 21 14:56 .bashrc
          -rw-r--r--  1 root root  161 Apr 22  2024 .profile
          drwx------  2 root root 4096 Jan 21 14:55 .ssh
          drwxr-xr-x  4 root root 4096 Jan 31 20:48 .theia
          -rw-r--r--  1 root root  109 Jan 21 14:56 .vimrc
          -rw-r--r--  1 root root  165 Jan 21 14:56 .wget-hsts
          lrwxrwxrwx  1 root root    1 Jan 21 14:56 filesystem -> /


## Part 2: Scenario-Based Practice
Focus is on thinking like a DevOps engineer, not memorizing commands.

Scenario 1: Service Not Starting
     Problem:
     Service myapp failed after reboot.

     Step-by-step solution:
          Step 1:
          systemctl status myapp
          Why: Checks if the service is running, failed, or inactive.

          Step 2:
          journalctl -u myapp -n 50
          Why: Reads recent logs to identify startup errors.

          Step 3:
          systemctl is-enabled myapp
          Why: Confirms whether the service starts on boot.

          Step 4:
          systemctl list-unit-files | grep myapp
          Why: Verifies the service unit exists and its state.

     What I learned:
     Always check status → logs → boot configuration in that order.

Scenario 2: High CPU Usage
     Problem:
     Server is slow; suspected high CPU usage.

     Step-by-step solution:
          Step 1:
          top
          Why: Shows live CPU usage and top-consuming processes.

          Step 2:
          ps aux --sort=-%cpu | head -10
          Why: Lists processes sorted by CPU usage.

          Step 3:
          ps -fp <PID>
          Why: Identifies what the high-CPU process actually is.

     What I learned:
     Always identify the process before taking action.

Scenario 3: Finding Service Logs
     Problem:
     Developer asks for Docker service logs.

     Step-by-step solution:
          Step 1:
          systemctl status docker
          Why: Confirms service name and status.

          Step 2:
          journalctl -u docker -n 50
          Why: Views recent logs for the Docker service.

          Step 3:
          journalctl -u docker -f
          Why: Follows logs in real time during troubleshooting.

     What I learned:
     systemd services log to journald, not always files.

Scenario 4: File Permission Issue
     Problem:
     Script fails with Permission denied.

     Step-by-step solution:
          Step 1:
          ls -l /home/user/backup.sh
          Why: Checks current permissions.

          Step 2:
          chmod +x /home/user/backup.sh
          Why: Adds execute permission.

          Step 3:
          ls -l /home/user/backup.sh
          Why: Verifies permission change.

          Step 4:
          ./backup.sh
          Why: Confirms the fix works.