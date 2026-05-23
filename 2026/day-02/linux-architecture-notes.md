# Linux Architecture Notes (Day 02)

These notes explain **how Linux works internally** in a simple and practical way.  

---

## 1. Core Components of Linux

### 1.1 Kernel (The Brain of Linux)
- The **kernel** is the core of the operating system
- It directly interacts with hardware
- Responsibilities include:
  - **CPU scheduling** (which process runs)
  - **Memory management** (RAM usage)
  - **Process lifecycle** (create, run, terminate)
  - **Device and disk management**
- Runs in **kernel space** (highest privilege)

> Users and applications never access hardware directly — everything goes through the kernel.

---

### 1.2 User Space
- Area where **users and applications run**
- Examples:
  - Shells: `bash`, `zsh`
  - Commands: `ls`, `ps`, `grep`
  - Applications: `nginx`, `docker`, `node`
- Runs in **user space** (restricted access)

> If an application crashes, the system remains stable.

---

### 1.3 Init System – systemd
- The **first process started by the kernel**
- Always has **PID 1**
- Manages the system after boot

**Responsibilities:**
- Start and stop services
- Handle service dependencies
- Restart failed services
- Manage logs

> Most modern Linux distributions use **systemd**.

---

## 2. Processes in Linux

### 2.1 What Is a Process?
- A **process** is a **running instance of a program**
- A program is just a file on disk, but once it starts running, it becomes a process

**Example:**
- `nginx` installed → program
- `nginx` running → process
- Multiple users accessing a server may create **multiple processes of the same program**

Each process is isolated and managed by the kernel.

#### Each process has:
- **PID (Process ID)**  
  - A unique number assigned by the kernel  
  - Used to identify and manage the process  
  - Example: `kill 1234`

- **Parent PID (PPID)**  
  - The PID of the process that started it  
  - Helps form a **process hierarchy (tree)**  
  - Example: shell → child commands

- **State**  
  - Shows what the process is currently doing  
  - Examples: running, sleeping, stopped, zombie

---

### 2.2 How a Process Is Created
Linux creates processes using a **parent-child model**.

#### Step-by-step process creation:
1. A **parent process** (like a shell) calls `fork()`
   - This creates an **exact copy** of the parent process

2. The new process is called the **child process**
   - Child gets a **new PID**
   - Initially, parent and child are almost identical

3. The child process calls `exec()`
   - Replaces its memory with a **new program**
   - Example: shell → `ls`, `python`, `nginx`

4. The kernel:
   - Assigns CPU time
   - Allocates memory
   - Tracks process state and execution

#### Simple real-life example:
- You type `ls` in terminal
- Shell (parent) → `fork()`
- Child → `exec(ls)`
- Kernel runs `ls`
- Output is shown
- Process exits

---

### 2.3 Process States
Every process in Linux is always in **one state at a time**.  
Understanding these states helps identify performance issues and stuck processes.

---

#### **Running (R)**
- The process is **actively using the CPU**
- Either currently executing or ready to run

**Example:**
- A script performing calculations
- A service under heavy traffic
Too many running processes may indicate **CPU overload**.

---

#### **Sleeping (S)**
- The process is **waiting for an event or input/output**
- This is the **most common and healthy state**

**Example:**
- Waiting for user input
- Waiting for a network response
Normal behavior for most services.

---

#### **Uninterruptible Sleep (D)**
- Process is waiting on **disk or network I/O**
- Cannot be interrupted or killed easily

**Example:**
- Disk read/write issues
- Network file system delays
Many `D` state processes usually indicate **storage or I/O problems**.

---

#### **Stopped (T)**
- Process execution is **paused**
- Usually stopped by a signal or debugging

**Example:**
- Pressing `Ctrl + Z` in terminal
- Debugging a process
Process can be resumed using `fg` or `bg`.

---

#### **Zombie (Z)**
- Process has **finished execution**
- Parent process has not collected the exit status

**Example:**
- Parent application bug
- Improper process cleanup
Zombies don’t use CPU or memory, but **many zombies indicate a faulty parent process**.

---

### Why Process States Matter in DevOps
- Help identify **CPU bottlenecks**
- Detect **disk or network issues**
- Reveal **application bugs**
- Speed up incident root-cause analysis

---

## 3. systemd and Its Importance

### What systemd Does
- Starts services in parallel (faster boot)
- Monitors service health
- Restarts crashed services
- Centralized logging via `journald`

### Why DevOps Engineers Must Know systemd
Most production issues involve:
- Services not starting
- Services crashing
- High CPU or memory usage

systemd helps:
- Check service status
- Restart services safely
- Analyze logs

---

## 4. Daily Linux Commands

- `ps aux` – List running processes
- `top` / `htop` – Monitor CPU & memory
- `systemctl status <service>` – Check service status
- `systemctl restart <service>` – Restart service
- `journalctl -u <service>` – View service logs

---

## 5. Key Takeaways
- The **kernel** controls hardware and resources
- **User space** keeps applications isolated
- **systemd** manages services and logs
- Understanding these basics enables faster troubleshooting


## Linux Architecture Overview

+-----------------------------+
|        Applications         |
|  (nginx, docker, node)      |
+-----------------------------+
              |
              | System Calls
              v
+-----------------------------+
|         User Space          |
|  (Shell, Libraries, Tools) |
+-----------------------------+
              |
              | Kernel API
              v
+-----------------------------+
|           Kernel            |
|  CPU | Memory | Disk | Net |
+-----------------------------+
              |
              | Hardware Control
              v
+-----------------------------+
|          Hardware           |
|   CPU | RAM | Disk | NIC   |
+-----------------------------+


