# Day 05 – Linux Troubleshooting Runbook

## 🎯 Target Service SSH

Service: **ssh**
PID identified using:

```
pgrep sshd
```

---

## 1️⃣ Environment Check

```
uname -a
cat /etc/os-release
```

Observed kernel version and OS details.

---

## 2️⃣ Filesystem Sanity

```
mkdir /tmp/runbook-demo
cp /etc/hosts /tmp/runbook-demo/hosts-copy
ls -l /tmp/runbook-demo
```

Filesystem writable and functioning normally.

---

## 3️⃣ CPU & Memory Snapshot

```
ps -o pid,pcpu,pmem,comm -p <PID>
free -h
```

Low CPU usage, stable memory, no swap pressure.

---

## 4️⃣ Disk Check

```
df -h
du -sh /var/log
```

Disk usage under control. Logs not growing abnormally.

---

## 5️⃣ Network Check

```
ss -tulpn | grep ssh
ping -c 4 localhost
```

Port 22 listening. No packet loss.

---

## 6️⃣ Log Review

```
journalctl -u ssh -n 50
tail -n 50 /var/log/syslog
```

No recent errors or restart loops.

---

## 🔎 Quick Findings

* Service active and stable
* CPU / Memory normal
* Disk healthy
* Network working
* Logs clean

---

## 🚨 If This Worsens

1. Restart service: `systemctl restart ssh`
2. Increase log verbosity
3. Capture deeper diagnostics: `strace -p <PID>`
4. Check firewall: `ufw status`

---

This checklist provides a fast, repeatable troubleshooting routine for production incidents.
