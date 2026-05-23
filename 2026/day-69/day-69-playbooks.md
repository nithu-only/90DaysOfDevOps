## Day 69 -- Ansible Playbooks and Modules

## Task 1: Your First Playbook
    1. Create playbook file
        mkdir day-69
        cd day-69
        nano install-nginx.yml

    2. Add playbook (Ubuntu version 👇)

        - name: Install and start Nginx on web servers
        hosts: web
        become: true

        tasks:
            - name: Install Nginx
            apt:
                name: nginx
                state: present
                update_cache: yes

            - name: Start and enable Nginx
            service:
                name: nginx
                state: started
                enabled: true

            - name: Create a custom index page
            copy:
                content: "<h1>Deployed by Ansible - TerraWeek Server</h1>"
                dest: /var/www/html/index.html

    3. Run playbook
        ansible-playbook install-nginx.yml

    4. Verify
        curl http://<your-ec2-public-ip>

    5. Run again (IMPORTANT)
    ansible-playbook install-nginx.yml

## Task 2: Understand Playbook Structure
    👉 Play vs Task
        Play = targets group of servers
        Task = single action (install, start, copy)

    👉 Multiple plays?
        ✔️ YES — one playbook can have multiple plays

    👉 become: true
        Play level → applies to all tasks
        Task level → applies only to that task

    👉 If a task fails?
        By default → playbook STOPS
        Unless:
            ignore_errors: yes

## Task 3: Essential Modules
    1. Create structure
        mkdir files
        nano essential-modules.yml

    2. Create sample file
        nano files/app.conf

        Add:
            PORT=3000
            ENV=production

    3. Add playbook
        ---
        - name: Practice essential modules
        hosts: all
        become: true

        tasks:
            - name: Install packages
            apt:
                name:
                - git
                - curl
                - wget
                - tree
                state: present
                update_cache: yes

            - name: Ensure nginx running
            service:
                name: nginx
                state: started
                enabled: true

            - name: Copy config file
            copy:
                src: files/app.conf
                dest: /etc/app.conf
                owner: root
                group: root
                mode: '0644'

            - name: Create app directory
            file:
                path: /opt/myapp
                state: directory
                owner: ubuntu
                mode: '0755'

            - name: Check disk space
            command: df -h
            register: disk_output

            - name: Print disk output
            debug:
                var: disk_output.stdout_lines

            - name: Count processes
            shell: ps aux | wc -l
            register: process_count

            - name: Show process count
            debug:
                msg: "Total processes: {{ process_count.stdout }}"

            - name: Set timezone
            lineinfile:
                path: /etc/environment
                line: 'TZ=Asia/Kolkata'
                create: true

    4. Run it
        ansible-playbook essential-modules.yml

    5. command vs shell
    | command     | shell                |
    | ----------- | -------------------- | 
    | No pipes (` | `)                   |
    | More secure | Less secure          |
    | Preferred   | Use only when needed |

## Task 4: Handlers
    1. Create nginx config
        nano files/nginx.conf

        Add basic config (simple):

        events {}

        http {
        server {
            listen 80;
            location / {
            root /usr/share/nginx/html;
            index index.html;
            }
        }
        }

    2. Create playbook
        nano nginx-config.yml
        ---
        - name: Configure Nginx
        hosts: web
        become: true

        tasks:
            - name: Install nginx
            apt:
                name: nginx
                state: present

            - name: Copy nginx config
            copy:
                src: files/nginx.conf
                dest: /etc/nginx/nginx.conf
            notify: Restart Nginx

            - name: Deploy index page
            copy:
                content: "<h1>Managed by Ansible</h1><p>{{ inventory_hostname }}</p>"
                dest: /var/www/html/index.html

            - name: Ensure nginx running
            service:
                name: nginx
                state: started
                enabled: true

        handlers:
            - name: Restart Nginx
            service:
                name: nginx
                state: restarted

    3. Run twice
        ansible-playbook nginx-config.yml
        ansible-playbook nginx-config.yml

    Observe:
        First run → handler runs
        Second run → handler NOT triggered
    Handlers run only when change happens

## Task 5: Dry Run, Diff, Verbosity
    🔹 Dry Run
        ansible-playbook install-nginx.yml --check

    🔹 Diff
        ansible-playbook nginx-config.yml --check --diff

    🔹 Verbosity
        ansible-playbook install-nginx.yml -v
        ansible-playbook install-nginx.yml -vv
        ansible-playbook install-nginx.yml -vvv

    🔹 Limit hosts
        ansible-playbook install-nginx.yml --limit web

    🔹 Preview execution
        ansible-playbook install-nginx.yml --list-hosts
        ansible-playbook install-nginx.yml --list-tasks

    Why --check --diff is IMPORTANT?
    Because:
        Prevents breaking production 
        Shows exact changes before applying
        Helps review config safely

## Task 6: Multiple Plays
    1. Create file
        nano multi-play.yml

    2. Add playbook (Ubuntu version)
        ---
        - name: Configure web servers
        hosts: web
        become: true
        tasks:
            - name: Install nginx
            apt:
                name: nginx
                state: present

            - name: Start nginx
            service:
                name: nginx
                state: started
                enabled: true

        - name: Configure app servers
        hosts: app
        become: true
        tasks:
            - name: Install dependencies
            apt:
                name:
                - gcc
                - make
                state: present

            - name: Create app directory
            file:
                path: /opt/app
                state: directory
                mode: '0755'

        - name: Configure db servers
        hosts: db
        become: true
        tasks:
            - name: Install mysql client
            apt:
                name: mysql-client
                state: present

            - name: Create data directory
            file:
                path: /var/lib/appdata
                state: directory
                mode: '0700'

    3. Run
        ansible-playbook multi-play.yml