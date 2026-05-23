# 🚀 Day 72 — Ansible Project: Automate Docker and Nginx Deployment

---

# 📌 Objective

Build a **production-style automated deployment pipeline** using Ansible that:

* Configures servers from scratch
* Installs Docker and runs a containerized application
* Sets up Nginx as a reverse proxy
* Secures credentials using Ansible Vault
* Uses roles, templates, handlers, and variables
* Achieves idempotent deployment

---

# 🏗️ Task 1: Project Structure Setup

## 📁 Directory Layout

```
ansible-docker-project/
│
├── ansible.cfg
├── inventory.ini
├── site.yml
│
├── group_vars/
│   ├── all.yml
│   └── web/
│       ├── vars.yml
│       └── vault.yml
│
├── roles/
│   ├── common/
│   ├── docker/
│   └── nginx/
│
└── day-72-ansible-project.md
```

---

## ⚙️ Setup Commands

```bash
mkdir ansible-docker-project
cd ansible-docker-project

mkdir -p group_vars/all
mkdir -p group_vars/web
mkdir roles

ansible-galaxy init roles/common
ansible-galaxy init roles/docker
ansible-galaxy init roles/nginx

touch ansible.cfg inventory.ini site.yml
```

---

## ⚙️ ansible.cfg

```ini
[defaults]
inventory = inventory.ini
host_key_checking = False
remote_user = ec2-user
private_key_file = your-key.pem
vault_password_file = .vault_pass
```

---

## 🌐 inventory.ini

```ini
[web]
<YOUR_SERVER_IP>

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

---

# 🧰 Task 2: Common Role (Baseline Setup)

## 🎯 Purpose

Prepare all servers with:

* Essential tools
* Timezone
* User setup

---

## 📄 roles/common/tasks/main.yml

```yaml
---
- name: Update package cache
  yum:
    update_cache: true

- name: Install packages
  yum:
    name: "{{ common_packages }}"
    state: present

- name: Set hostname
  hostname:
    name: "{{ inventory_hostname }}"

- name: Set timezone
  timezone:
    name: "{{ timezone }}"

- name: Create deploy user
  user:
    name: deploy
    groups: wheel
    shell: /bin/bash
```

---

## 🌍 group_vars/all.yml

```yaml
timezone: Asia/Kolkata
project_name: devops-app
app_env: development

common_packages:
  - vim
  - curl
  - wget
  - git
  - htop
  - tree
  - jq
  - unzip
```

---

# 🐳 Task 3: Docker Role

## 🎯 Purpose

* Install Docker
* Pull image
* Run container
* Perform health check

---

## 📄 roles/docker/defaults/main.yml

```yaml
docker_app_image: nginx
docker_app_tag: latest
docker_app_name: myapp
docker_app_port: 8080
docker_container_port: 80
```

---

## ⚙️ Install Dependency

```bash
ansible-galaxy collection install community.docker
```

---

## 📄 roles/docker/tasks/main.yml

```yaml
---
- name: Install dependencies
  yum:
    name:
      - yum-utils
      - device-mapper-persistent-data
      - lvm2

- name: Add Docker repo
  get_url:
    url: https://download.docker.com/linux/centos/docker-ce.repo
    dest: /etc/yum.repos.d/docker-ce.repo

- name: Install Docker
  yum:
    name: docker-ce
    state: present
  notify: Restart Docker

- name: Start Docker
  service:
    name: docker
    state: started
    enabled: true

- name: Add deploy user to docker group
  user:
    name: deploy
    groups: docker
    append: yes

- name: Install pip
  yum:
    name: python3-pip

- name: Install Docker SDK
  pip:
    name: docker

- name: Docker login
  community.docker.docker_login:
    username: "{{ vault_docker_username }}"
    password: "{{ vault_docker_password }}"
  when: vault_docker_username is defined

- name: Pull image
  community.docker.docker_image:
    name: "{{ docker_app_image }}"
    tag: "{{ docker_app_tag }}"
    source: pull

- name: Run container
  community.docker.docker_container:
    name: "{{ docker_app_name }}"
    image: "{{ docker_app_image }}:{{ docker_app_tag }}"
    state: started
    restart_policy: always
    ports:
      - "{{ docker_app_port }}:{{ docker_container_port }}"

- name: Health check
  uri:
    url: "http://localhost:{{ docker_app_port }}"
    status_code: 200
  register: result
  retries: 5
  delay: 3
  until: result.status == 200
```

---

## 📄 roles/docker/handlers/main.yml

```yaml
- name: Restart Docker
  service:
    name: docker
    state: restarted
```

---

# 🌐 Task 4: Nginx Role

## 🎯 Purpose

* Install Nginx
* Configure reverse proxy
* Route traffic → Docker container

---

## 📄 roles/nginx/defaults/main.yml

```yaml
nginx_http_port: 80
nginx_upstream_port: 8080
nginx_server_name: "_"
```

---

## 📄 roles/nginx/tasks/main.yml

```yaml
---
- name: Install Nginx
  yum:
    name: nginx
    state: present

- name: Remove default config
  file:
    path: /etc/nginx/nginx.conf
    state: absent

- name: Deploy nginx.conf
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: Reload Nginx

- name: Deploy reverse proxy config
  template:
    src: app-proxy.conf.j2
    dest: /etc/nginx/conf.d/app.conf
  notify: Reload Nginx

- name: Test config
  command: nginx -t
  changed_when: false

- name: Start Nginx
  service:
    name: nginx
    state: started
    enabled: true
```

---

## 📄 Reverse Proxy Template (app-proxy.conf.j2)

```nginx
upstream docker_app {
    server 127.0.0.1:{{ nginx_upstream_port }};
}

server {
    listen {{ nginx_http_port }};

    location / {
        proxy_pass http://docker_app;
    }
}
```

---

# 🔐 Task 5: Vault Setup

```bash
ansible-vault create group_vars/web/vault.yml
```

```yaml
vault_docker_username: your-username
vault_docker_password: your-token
```

```bash
echo "MySecretPass" > .vault_pass
chmod 600 .vault_pass
echo ".vault_pass" >> .gitignore
```

---

# 🧠 Task 6: Master Playbook

## 📄 site.yml

```yaml
---
- name: Common
  hosts: all
  become: true
  roles:
    - common

- name: Docker
  hosts: web
  become: true
  roles:
    - docker

- name: Nginx
  hosts: web
  become: true
  roles:
    - nginx
```

---

# 🚀 Deployment

```bash
ansible-playbook site.yml --check --diff
ansible-playbook site.yml
```

---

# ✅ Task 7: Verification

## Test Container

```bash
curl http://<SERVER_IP>:8080
```

## Test Nginx

```bash
curl http://<SERVER_IP>
```

## Check Containers

```bash
docker ps
```

---

# 🔁 Bonus Task

```bash
ansible-playbook site.yml --tags docker \
-e "docker_app_image=httpd docker_app_tag=latest docker_app_name=apache-app"
```

---

# 🔄 Idempotency Check

```bash
ansible-playbook site.yml
```

✔ Output should show mostly `ok` and minimal `changed`

---

# 📊 Concepts Mapping

| Day | Concept      |
| --- | ------------ |
| 68  | Inventory    |
| 69  | Playbooks    |
| 70  | Variables    |
| 71  | Roles, Vault |
| 72  | Full system  |

---

# 🚀 Production Improvements

* SSL (HTTPS with Certbot)
* Monitoring (Prometheus/Grafana)
* Logging (ELK stack)
* CI/CD pipeline
* Kubernetes deployment

---

# 🎯 Final Outcome

✔ One command deployment
✔ Docker + Nginx automated
✔ Secure credentials
✔ Idempotent system

---

# 🧾 Conclusion

This project demonstrates a **complete DevOps automation pipeline** using Ansible, combining all core concepts into a real-world deployment scenario.

---
