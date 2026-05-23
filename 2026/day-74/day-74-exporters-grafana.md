## Day 74 -- Node Exporter, cAdvisor, and Grafana Dashboards

## Task 1: Add Node Exporter (Host Metrics)
    1. Update docker-compose.yml
        Add this service:

        node-exporter:
        image: prom/node-exporter:latest
        container_name: node-exporter
        ports:
            - "9100:9100"
        volumes:
            - /proc:/host/proc:ro
            - /sys:/host/sys:ro
            - /:/rootfs:ro
        command:
            - '--path.procfs=/host/proc'
            - '--path.sysfs=/host/sys'
            - '--path.rootfs=/rootfs'
            - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
        restart: unless-stopped

    2. Update prometheus.yml
    Add scrape config:

        scrape_configs:
        - job_name: "prometheus"
            static_configs:
            - targets: ["localhost:9090"]

        - job_name: "node-exporter"
            static_configs:
            - targets: ["node-exporter:9100"]

    3. Restart services
        docker compose up -d

    4. Verify Node Exporter
        curl http://localhost:9100/metrics | head -20
    
        Go to Prometheus UI:
         http://localhost:9090/targets

    5. Test PromQL Queries
        CPU:

        node_cpu_seconds_total{mode="idle"}

        Memory:

        node_memory_MemTotal_bytes
        node_memory_MemAvailable_bytes

        Memory Usage:

        (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100

        Disk:

        (1 - node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100

        Network:

        rate(node_network_receive_bytes_total[5m])

## Task 2: Add cAdvisor (Container Metrics)
    1. Update docker-compose.yml
        cadvisor:
        image: gcr.io/cadvisor/cadvisor:latest
        container_name: cadvisor
        ports:
            - "8080:8080"
        volumes:
            - /var/run/docker.sock:/var/run/docker.sock:ro
            - /sys:/sys:ro
            - /var/lib/docker/:/var/lib/docker:ro
        restart: unless-stopped

    2. Update prometheus.yml
        - job_name: "cadvisor"
        static_configs:
            - targets: ["cadvisor:8080"]

    3. Restart
        docker compose up -d

    4. Verify cAdvisor 
        Open:
            http://localhost:8080

    5. Test PromQL Queries

    CPU:
        rate(container_cpu_usage_seconds_total{name!=""}[5m])
        Memory:
        container_memory_usage_bytes{name!=""}
        Network:
        rate(container_network_receive_bytes_total{name!=""}[5m])
        Top memory containers:
        topk(3, container_memory_usage_bytes{name!=""})

    🧠 Concept: Node Exporter vs cAdvisor
        | Feature        | Node Exporter                         | cAdvisor                           |
        | -------------- | ------------------------------------- | ---------------------------------- |
        | Scope          | Host machine                          | Docker containers                  |
        | Metrics Prefix | `node_`                               | `container_`                       |
        | Tracks         | CPU, RAM, disk, network (system-wide) | Per-container CPU, memory, network |
        | Use case       | Server health                         | Container performance              |

    👉 Use both together in real production systems.

## Task 3: Set Up Grafana
    1. Add Grafana service
        grafana:
        image: grafana/grafana-enterprise:latest
        container_name: grafana
        ports:
            - "3000:3000"
        volumes:
            - grafana_data:/var/lib/grafana
        environment:
            - GF_SECURITY_ADMIN_USER=admin
            - GF_SECURITY_ADMIN_PASSWORD=admin123
        restart: unless-stopped

    2. Add volume
        volumes:
        prometheus_data:
        grafana_data:

    3. Start Grafana
        docker compose up -d

    4. Login
        Open:
            http://localhost:3000
        Login:
            admin / admin123

    5. Add Prometheus datasource
        Go → Connections → Data Sources
        Click → Add Data Source
        Select → Prometheus
        
        URL:
        http://prometheus:9090

## Task 4: Build Dashboard
    ➤ Create Dashboard
    Go:
        Dashboards → New → Add Visualization
    📊 Panel 1 — CPU Usage
    100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
    Type: Gauge
    Title: CPU Usage %
    📊 Panel 2 — Memory Usage
    (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100
    Type: Gauge
    Title: Memory Usage %
    📊 Panel 3 — Container CPU
    rate(container_cpu_usage_seconds_total{name!=""}[5m]) * 100
    Type: Time Series
    Legend: {{name}}
    📊 Panel 4 — Container Memory
    container_memory_usage_bytes{name!=""} / 1024 / 1024
    Type: Bar Chart
    Title: Container Memory (MB)
    📊 Panel 5 — Disk Usage
    (1 - node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}) * 100
    Type: Stat
    Title: Disk Usage %

    💾 Save Dashboard
    Name:
    DevOps Observability Overview

✅ Task 5: Auto-Provision Datasource (YAML)
    1. Create folders
        mkdir -p grafana/provisioning/datasources
        mkdir -p grafana/provisioning/dashboards

    2. Create datasource file
        grafana/provisioning/datasources/datasources.yml
        apiVersion: 1

        datasources:
        - name: Prometheus
            type: prometheus
            access: proxy
            url: http://prometheus:9090
            isDefault: true
            editable: false

    3. Update Grafana service
        volumes:
        - grafana_data:/var/lib/grafana
        - ./grafana/provisioning:/etc/grafana/provisioning

    4. Restart Grafana
        docker compose up -d grafana
    5. Verify
        Go to:
        Connections → Data Sources
    ✅ Prometheus should already exist

    🧠 Why YAML Provisioning?
    No manual UI work
    Repeatable (CI/CD friendly)
    Version-controlled
    Works across environments (dev/staging/prod)

## Task 6: Import Community Dashboards
    1. Import Node Exporter Dashboard
        Go → Dashboards → Import
        Enter ID:
        1860
        Select Prometheus datasource
        Click Import

    2. Import cAdvisor Dashboard
        Use ID:
        193
    🎯 What you get
    Full system metrics (CPU, RAM, disk)
    Container-level monitoring
    Ready-made production dashboards

    ✅ Final Verification
    Run:
    docker compose ps
    