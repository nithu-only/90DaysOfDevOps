### Day 68 -- Introduction to Ansible and Inventory Setup

## Task 1: Understand Ansible (Write Notes)

    1. What is Configuration Management?
        Process of automating server setup and maintenance
        Ensures systems stay in a desired state
        Avoids manual errors and configuration drift

    2. Why do we need it?
        Consistency across environments
        Faster deployments
        Scalability
        Infrastructure as Code (IaC)

    3. Ansible vs Chef / Puppet / Salt
        | Tool    | Agent Required | Language    | Complexity |
        | ------- | -------------- | ----------- | ---------- |
        | Ansible | No           | YAML        | Easy       |
        | Puppet  | Yes          | DSL         | Medium     |
        | Chef    | Yes          | Ruby        | Hard       |
        | Salt    | Optional     | YAML/Python | Medium     |

    4. What does “Agentless” mean?
        No software installed on target servers
        Uses SSH to connect and execute tasks
    5. Ansible Architecture
        Control Node → Your laptop / EC2 where Ansible runs
        Managed Nodes → EC2 instances
        Inventory → List of servers
        Modules → Tasks (install package, copy file, etc.)
        Playbooks → YAML automation scripts

## Task 2: Set Up Lab Environment

    Minimal EC2 config:

    resource "aws_instance" "ansible_nodes" {
    count         = 3
    ami           = "ami-xxxxxxxx"
    instance_type = "t2.micro"
    key_name      = "your-key"

    tags = {
        Name = "ansible-node-${count.index}"
    }
    }

    ![alt text](image.png)

## Task 3: Install Ansible
    On your control node ( one EC2)
    
    Ubuntu:
    sudo apt update
    sudo apt install ansible -y
    
    Amazon Linux:
    sudo yum install ansible -y
    
    Verify
    ansible --version
    ![alt text](image-1.png)

    Installed on: Control Node (local laptop)
    Reason:
        Only control node runs Ansible
        Managed nodes only need SSH

## Task 4: Create Inventory File
    Step 1: Create project
        mkdir ansible-practice
        cd ansible-practice

    Step 2: Create inventory
    nano inventory.ini
    Paste:
        [web]
        web-server ansible_host=<IP1>

        [app]
        app-server ansible_host=<IP2>

        [db]
        db-server ansible_host=<IP3>

        [all:vars]
        ansible_user=ec2-user
        ansible_ssh_private_key_file=~/your-key.pem

    Step 3: Test connectivity
        ansible all -i inventory.ini -m ping

    Expected:
        web-server | SUCCESS => { "ping": "pong" }
    ![alt text](image-2.png)

## Task 5: Run Ad-Hoc Commands
    1. Check uptime
    ansible all -i inventory.ini -m command -a "uptime"

    2. Check memory (web only)
    ansible web -i inventory.ini -m command -a "free -h"

    3. Check disk
    ansible all -i inventory.ini -m command -a "df -h"

    4. Install package (IMPORTANT)
    ansible web -i inventory.ini -m yum -a "name=git state=present" --become
    👉 Ubuntu:
    ansible web -i inventory.ini -m apt -a "name=git state=present" --become
    💡 What is --become?
    Acts like sudo
    Needed for:
        Installing packages
        Managing services
        Writing to system directories

    5. Copy file
    echo "Hello from Ansible" > hello.txt
    ansible all -i inventory.ini -m copy -a "src=hello.txt dest=/tmp/hello.txt"

    6. Verify file
    ansible all -i inventory.ini -m command -a "cat /tmp/hello.txt"

## Task 6: Inventory Groups & Patterns
    Step 1: Update inventory
        [application:children]
        web
        app

        [all_servers:children]
        application
        db

    Step 2: Test groups
        ansible application -i inventory.ini -m ping
        ansible db -i inventory.ini -m ping
        ansible all_servers -i inventory.ini -m ping

    Step 3: Patterns
        ansible 'web:app' -i inventory.ini -m ping
        ansible 'all:!db' -i inventory.ini -m ping
    
    Step 4: Create ansible.cfg
        nano ansible.cfg

        Paste:

        [defaults]
        inventory = inventory.ini
        host_key_checking = False
        remote_user = ec2-user
        private_key_file = ~/your-key.pem

        Now test:
        ansible all -m ping

        No need for -i inventory.ini