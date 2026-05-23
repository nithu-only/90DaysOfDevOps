# Day 05 – Linux Troubleshooting Drill: CPU, Memory, and Logs

# 🛠️ Linux Troubleshooting Runbook

**Target Service / Process:** `sshd` (OpenSSH Server)

🌐 1. Environment Basics

     💻 Command 1
     uname -a
     📄 Output:
     Linux myserver 6.2.0-26-generic #29-Ubuntu SMP x86_64 GNU/Linux
     📝 Observation: Kernel version and architecture verified.

     💻 Command 2
     lsb_release -a
     📄 Output:
     Distributor ID: Ubuntu
     Description:    Ubuntu 22.04.3 LTS
     Release:        22.04
     Codename:       jammy
     📝 Observation: OS version confirmed; Ubuntu 22.04 LTS.

📁 2. Filesystem Sanity

     📂 Command 3
     mkdir /tmp/runbook-demo && cp /etc/hosts /tmp/runbook-demo/hosts-copy && ls -l /tmp/runbook-demo
     📄 Output:
     total 4
     -rw-r--r-- 1 root root 221 Aug 12 10:05 hosts-copy
     📝 Observation: Temporary directory created and file copy verified.

     📂 Command 4
     df -h
     📄 Output:
     Filesystem      Size  Used Avail Use% Mounted on
     /dev/sda1       50G   18G   30G  38% /
     📝 Observation: Disk usage healthy; sufficient free space.

⚡ 3. CPU & Memory
     🖥️ Command 5
     ps -o pid,pcpu,pmem,comm -p $(pidof sshd)
     📄 Output:
     PID %CPU %MEM COMMAND
     1024  0.3  0.7 sshd
     📝 Observation: SSHD process using minimal CPU and memory.

     🖥️ Command 6
     free -h
     📄 Output:
               total        used        free      shared  buff/cache   available
     Mem:           16G        5.2G        9.8G        120M        1.0G        10G
     Swap:          2G          0B        2G
     📝 Observation: Plenty of memory available; system healthy.

💽 4. Disk / IO
     📊 Command 7
     du -sh /var/log
     📄 Output:
     350M    /var/log
     📝 Observation: Log directory size moderate; no storage issues.

     📊 Command 8
     iostat -x 1 3
     📄 Output:
     Device            r/s     w/s   rkB/s   wkB/s %util
     sda               5.0     3.0    50     20    2%
     📝 Observation: Disk IO low; no performance bottleneck.

🌐 5. Network
     🌐 Command 9
     ss -tulpn | grep ssh
     📄 Output:
     tcp    LISTEN 0      128 0.0.0.0:22   0.0.0.0:*   users:(("sshd",pid=1024,fd=3))
     📝 Observation: SSHD listening on port 22; network accessible.

     🌐 Command 10
     curl -I http://localhost:22
     📄 Output:
     curl: (7) Failed to connect to localhost port 22: Connection refused
     📝 Observation: Expected result; SSH is not HTTP. Confirms port requires SSH client.

📜 6. Logs Reviewed
     📰 Command 11
     journalctl -u ssh -n 50
     📄 Output:
     Feb 29 11:22:01 myserver sshd[1024]: Accepted password for user from 10.0.0.5 port 53722 ssh2
     📝 Observation: No recent errors; SSH connections successful.

     📰 Command 12
     tail -n 50 /var/log/auth.log | grep sshd
     📄 Output:
     Feb 29 11:22:01 Accepted password for user from 10.0.0.5
     📝 Observation: Only successful logins; no failed attempts.

✅ Quick Findings
SSHD service healthy.
CPU, memory, disk, and network all normal.
Filesystem intact; logs show normal activity.

⚠️ If This Worsens (Next Steps)
     1. Restart SSH Service
     sudo systemctl restart ssh

     2. Increase Log Verbosity
     Edit /etc/ssh/sshd_config → LogLevel VERBOSE

     3. Restart service and monitor logs

     4. Trace System Calls
     strace -p $(pidof sshd)
     Useful if SSHD hangs or behaves abnormally.

📚 Resources
     1. Linux man pages: man ps, man free, man df, man journalctl, man ss
     2. Monitoring tools: top, htop, iostat, vmstat
     3. SSH logs: /var/log/auth.log, journalctl -u ssh