# Day 70 — Variables, Facts, Conditionals, and Loops (Step-by-Step Guide)

## Task 1: Variables in Playbooks
- Create playbook: variables-demo.yml
- Run:
  ansible-playbook -i inventory.ini variables-demo.yml
- Override variables:
  ansible-playbook variables-demo.yml -e "app_name=my-custom-app app_port=9090"

**Key Learning:** CLI variables override playbook variables.

---

## Task 2: group_vars and host_vars

### Directory Structure
ansible-practice/
  inventory.ini
  group_vars/
    all.yml
    web.yml
    db.yml
  host_vars/
    web-server.yml
  playbooks/
    site.yml

### Key Concept: Variable Precedence
group_vars/all < group_vars/group < host_vars < playbook vars < extra vars (-e)

---

## Task 3: Ansible Facts

### Commands:
ansible web-server -m setup
ansible web-server -m setup -a "filter=ansible_distribution*"
ansible web-server -m setup -a "filter=ansible_memtotal_mb"

### Useful Facts:
- ansible_distribution → OS-based installs
- ansible_memtotal_mb → memory decisions
- ansible_default_ipv4.address → networking
- ansible_hostname → identification
- ansible_cpu_cores → scaling

---

## Task 4: Conditionals

### Example:
when: "'web' in group_names"
when: ansible_memtotal_mb < 1024
when: ansible_distribution == "Ubuntu"

**Key Learning:** Tasks run only when conditions match.

---

## Task 5: Loops

### Example:
loop:
  - git
  - curl
  - unzip

**Loop vs with_items:**
- loop = modern
- with_items = deprecated

---

## Task 6: Server Report

### Run:
ansible-playbook playbooks/server-report.yml

### Verify:
cat /tmp/server-report-*.txt

---

## Final Summary

- Variables → flexibility
- Facts → system awareness
- Conditionals → control execution
- Loops → automation at scale
- Register → capture outputs

