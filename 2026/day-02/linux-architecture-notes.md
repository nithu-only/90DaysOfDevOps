# Day 02 – Linux Architecture, Processes, and systemd

## What I Learned?
- Core Linux components (A-Application, S-Shell, K-Kernel)
- Different process states (Ready, Sleep, Dead, Terminated, Zombie)
- How systemd manages the system services.

## In detail:
- The kernel is the core of Linux and manages CPU, memory, and hardware. (attached .pdf)
- User space applications communicate with the kernel through system calls.
- Every process has a PID and a lifecycle.
- systemd (PID 1) manages services and ensures system stability.
- Zombie processes occur when a child process exits but the parent does not clean it up.

## Commands Practiced:
```python
# to get the snapshot of the running processes
$ ps 
# to get realtime view of running process
$ top
# to control system services like to start, restart, stop, enable, disable
$ systemctl
# view logs collected by systemd journal
$ jounalctl
# to terminate the process by its PId
$ kill

```
## References documentation:
[ps](https://man7.org/linux/man-pages/man1/ps.1.html)
[top](https://man7.org/linux/man-pages/man1/top.1.html)
[man](https://man7.org/linux/man-pages/man1/man.1.html)
[systemctl](https://man7.org/linux/man-pages/man1/systemctl.1.html)
[kill](https://man7.org/linux/man-pages/man2/kill.2.html)
[jounalctl](https://man7.org/linux/man-pages/man1/journalctl.1.html)


## Why This Matters for DevOps
Linux is the base OS for almost every production system.

If you know how processes and systemd work, you can:
- Debug crashed services faster
- Fix CPU/memory issues
- Understand logs and service restarts confidently

This knowledge saves hours during incidents.
