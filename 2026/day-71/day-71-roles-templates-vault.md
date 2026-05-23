## Day 71 -- Roles, Galaxy, Templates and Vault

## Task 1: Jinja2 Templates
    Step 1: Create project structure
        mkdir -p day71/templates
        cd day71

    Step 2: Create template file
        nano templates/nginx-vhost.conf.j2

        Paste:

        # Managed by Ansible -- do not edit manually
        server {
            listen {{ http_port | default(80) }};
            server_name {{ ansible_hostname }};

            root /var/www/{{ app_name }};
            index index.html;

            location / {
                try_files $uri $uri/ =404;
            }

            access_log /var/log/nginx/{{ app_name }}_access.log;
            error_log /var/log/nginx/{{ app_name }}_error.log;
        }

    Step 3: Create playbook
    nano template-demo.yml

    Paste:

        - name: Deploy Nginx with template
        hosts: web
        become: true
        vars:
            app_name: terraweek-app
            http_port: 80

        tasks:
            - name: Install Nginx
            yum:
                name: nginx
                state: present

            - name: Create web root
            file:
                path: "/var/www/{{ app_name }}"
                state: directory
                mode: '0755'

            - name: Deploy vhost config from template
            template:
                src: templates/nginx-vhost.conf.j2
                dest: "/etc/nginx/conf.d/{{ app_name }}.conf"
                owner: root
                mode: '0644'
            notify: Restart Nginx

            - name: Deploy index page
            copy:
                content: "<h1>{{ app_name }}</h1><p>Host: {{ ansible_hostname }} | IP: {{ ansible_default_ipv4.address }}</p>"
                dest: "/var/www/{{ app_name }}/index.html"

        handlers:
            - name: Restart Nginx
            service:
                name: nginx
                state: restarted

    Step 4: Run playbook
        ansible-playbook template-demo.yml --diff

    Step 5: Verify
        SSH into server:

        ssh ec2-user@<IP>
        cat /etc/nginx/conf.d/terraweek-app.conf

## Task 2: Understand Role Structure
    Step 1: Generate role skeleton
        ansible-galaxy init roles/webserver
    
    Step 2: Explore structure
        tree roles/webserver

    Step 3: Key concept (IMPORTANT)
        | File              | Purpose                            |
        | ----------------- | ---------------------------------- |
        | defaults/main.yml | Low priority (can override easily) |
        | vars/main.yml     | High priority (hard to override)   |
    
## Task 3: Build Custom Role
    Step 1: Defaults
        nano roles/webserver/defaults/main.yml

        http_port: 80
        app_name: myapp
        max_connections: 512

    Step 2: Tasks
        nano roles/webserver/tasks/main.yml

        - name: Install Nginx
        yum:
            name: nginx
            state: present

        - name: Deploy Nginx config
        template:
            src: nginx.conf.j2
            dest: /etc/nginx/nginx.conf
            owner: root
            mode: '0644'
        notify: Restart Nginx

        - name: Deploy vhost config
        template:
            src: vhost.conf.j2
            dest: "/etc/nginx/conf.d/{{ app_name }}.conf"
            owner: root
            mode: '0644'
        notify: Restart Nginx

        - name: Create web root
        file:
            path: "/var/www/{{ app_name }}"
            state: directory
            mode: '0755'

        - name: Deploy index page
        template:
            src: index.html.j2
            dest: "/var/www/{{ app_name }}/index.html"
            mode: '0644'

        - name: Start and enable Nginx
        service:
            name: nginx
            state: started
            enabled: true

    Step 3: Handlers
        nano roles/webserver/handlers/main.yml

        - name: Restart Nginx
        service:
            name: nginx
            state: restarted
    
    Step 4: Templates
        nginx.conf.j2
            nano roles/webserver/templates/nginx.conf.j2
            
            user nginx;
            worker_processes auto;

            events {
                worker_connections {{ max_connections }};
            }

            http {
                include       mime.types;
                default_type  application/octet-stream;

                sendfile        on;
                keepalive_timeout 65;

                include /etc/nginx/conf.d/*.conf;
            }
    
        vhost.conf.j2
            nano roles/webserver/templates/vhost.conf.j2
            server {
                listen {{ http_port }};
                server_name {{ ansible_hostname }};

                root /var/www/{{ app_name }};
                index index.html;

                location / {
                    try_files $uri $uri/ =404;
                }
            }

        index.html.j2
            nano roles/webserver/templates/index.html.j2

            <h1>{{ app_name }}</h1>
            <p>Server: {{ ansible_hostname }}</p>
            <p>IP: {{ ansible_default_ipv4.address }}</p>
            <p>Environment: {{ app_env | default('development') }}</p>
            <p>Managed by Ansible</p>
    

    Step 5: Create playbook
        nano site.yml

        - name: Configure web servers
        hosts: web
        become: true
        roles:
            - role: webserver
            vars:
                app_name: terraweek
                http_port: 80
    
    Step 6: Run
        ansible-playbook site.yml
    
    Step 7: Verify
        curl http://<server-ip>

## Task 4: Ansible Galaxy
    Step 1: Search roles
        ansible-galaxy search nginx
    
    Step 2: Install role
        ansible-galaxy install geerlingguy.docker
    
    Step 3: Verify installation
        ansible-galaxy list

    Step 4: Use role
        nano docker-setup.yml

        - name: Install Docker using Galaxy role
        hosts: app
        become: true
        roles:
            - geerlingguy.docker

    Step 5: Run
        ansible-playbook docker-setup.yml
    
    Step 6: Requirements file (BEST PRACTICE)
        nano requirements.yml
        
        roles:
        - name: geerlingguy.docker
            version: "7.4.1"
        - name: geerlingguy.ntp

    Install all:
        ansible-galaxy install -r requirements.yml
    
    📌 Why requirements.yml?
        Version control
        Reproducible builds
        CI/CD friendly
        One command setup

## Task 5: Ansible Vault
    Step 1: Create encrypted file
        ansible-vault create group_vars/db/vault.yml

        Add:

        vault_db_password: SuperSecretP@ssw0rd
        vault_db_root_password: R00tP@ssw0rd123
        vault_api_key: sk-abc123xyz789

    Step 2: View encrypted file
        cat group_vars/db/vault.yml

    Step 3: Edit
        ansible-vault edit group_vars/db/vault.yml

    Step 4: Create test playbook
        nano db-setup.yml
        ---
        - name: Configure database
        hosts: db
        become: true

        tasks:
            - name: Show DB password
            debug:
                msg: "DB password set: {{ vault_db_password | length > 0 }}"

    Step 5: Run with password
        ansible-playbook db-setup.yml --ask-vault-pass
    
    Step 6: Use password file (CI/CD way)
        echo "YourVaultPassword" > .vault_pass
        chmod 600 .vault_pass
        echo ".vault_pass" >> .gitignore
    Run:
        ansible-playbook db-setup.yml --vault-password-file .vault_pass
    
    📌 Why password file?
        No manual input
        Automation friendly
        Works in pipelines

## Task 6: Combine Everything
    Step 1: Create DB template
        mkdir -p templates

        nano templates/db-config.j2
        # Database Configuration -- Managed by Ansible
        DB_HOST={{ ansible_default_ipv4.address }}
        DB_PORT={{ db_port | default(3306) }}
        DB_PASSWORD={{ vault_db_password }}
        DB_ROOT_PASSWORD={{ vault_db_root_password }}
    
    Step 2: Final site.yml
        nano site.yml
        ---
        - name: Configure web servers
        hosts: web
        become: true
        roles:
            - role: webserver
            vars:
                app_name: terraweek
                http_port: 80

        - name: Configure app servers with Docker
        hosts: app
        become: true
        roles:
            - geerlingguy.docker

        - name: Configure database servers
        hosts: db
        become: true
        tasks:
            - name: Create DB config with secrets
            template:
                src: templates/db-config.j2
                dest: /etc/db-config.env
                owner: root
                mode: '0600'

    Step 3: Run everything
        ansible-playbook site.yml --vault-password-file .vault_pass

    Step 4: Verify
        ssh ec2-user@<db-ip>
        cat /etc/db-config.env
        ls -l /etc/db-config.env

    ✅ Check:
        Secrets rendered
        Permission = 600
