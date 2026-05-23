## Day 75 -- Log Management with Loki and Promtail

## Task 1: Understand the Logging Pipeline
    🔁 Flow
        Docker Containers → Promtail → Loki → Grafana
    
    📌 What each component does:
        Docker → writes logs as JSON files
        Promtail → reads logs + adds labels
        Loki → stores logs (indexes only labels)
        Grafana → queries logs using LogQL
    
    ❓ Why Loki indexes only labels (Important Concept)
    ✅ Reason:
        Full-text indexing (like ELK) is expensive
        Loki indexes only metadata (labels like container_name, job)
    ✅ Advantages:
        Much cheaper storage
        Faster ingestion
        Simple architecture
    ⚠️ Trade-off:
        Slower full-text search
        Not ideal for deep log analytics
    👉 Think:
        Loki = Prometheus for logs (label-based)

⚙️ Task 2: Add Loki to Your Stack
    Step 1: Create directory
        mkdir -p loki
    Step 2: Create config file
        nano loki/loki-config.yml

        Paste:

        auth_enabled: false

        server:
        http_listen_port: 3100

        common:
        ring:
            instance_addr: 127.0.0.1
            kvstore:
            store: inmemory
        replication_factor: 1
        path_prefix: /loki

        schema_config:
        configs:
            - from: 2020-10-24
            store: tsdb
            object_store: filesystem
            schema: v13
            index:
                prefix: index_
                period: 24h

        storage_config:
        filesystem:
            directory: /loki/chunks

    Step 3: Update docker-compose.yml
        loki:
        image: grafana/loki:latest
        container_name: loki
        ports:
            - "3100:3100"
        volumes:
            - ./loki/loki-config.yml:/etc/loki/loki-config.yml
            - loki_data:/loki
        command: -config.file=/etc/loki/loki-config.yml
        restart: unless-stopped

    Step 4: Add volume
        volumes:
        prometheus_data:
        grafana_data:
        loki_data:
    
    Step 5: Start Loki
        docker compose up -d loki
    
    Step 6: Verify
        curl http://localhost:3100/ready

    ✅ Expected:
    ready

## Task 3: Add Promtail
    Step 1: Create directory
        mkdir -p promtail
    Step 2: Create config
        nano promtail/promtail-config.yml

        Paste:

        server:
        http_listen_port: 9080
        grpc_listen_port: 0

        positions:
        filename: /tmp/positions.yaml

        clients:
        - url: http://loki:3100/loki/api/v1/push

        scrape_configs:
        - job_name: docker
            static_configs:
            - targets:
                - localhost
                labels:
                job: docker
                __path__: /var/lib/docker/containers/*/*-json.log
            pipeline_stages:
            - docker: {}
    
    Step 3: Add to docker-compose
        promtail:
        image: grafana/promtail:latest
        container_name: promtail
        volumes:
            - ./promtail/promtail-config.yml:/etc/promtail/promtail-config.yml
            - /var/lib/docker/containers:/var/lib/docker/containers:ro
            - /var/run/docker.sock:/var/run/docker.sock
        command: -config.file=/etc/promtail/promtail-config.yml
        restart: unless-stopped

    Step 4: Restart stack
        docker compose up -d

    Step 5: Generate logs
        for i in $(seq 1 20); do curl -s http://localhost:8000 > /dev/null; done
    
    Step 6: Verify Promtail
        Open:
            http://localhost:9080/targets

📊 Task 4: Add Loki to Grafana
    ✅ Option A (Recommended — YAML)
    Edit:

    nano grafana/provisioning/datasources/datasources.yml
    apiVersion: 1

    datasources:
    - name: Prometheus
        type: prometheus
        access: proxy
        url: http://prometheus:9090
        isDefault: true

    - name: Loki
        type: loki
        access: proxy
        url: http://loki:3100

    Restart Grafana
        docker compose restart grafana
    
    Verify in UI:
    👉 Grafana → Connections → Data Sources
        You should see:

        Prometheus
        Loki

## Task 5: Query Logs with LogQL

    Go to:
    👉 Grafana → Explore → Select Loki
    🔹 Basic queries
    All logs
        {job="docker"}
    Specific container
        {container_name="notes-app"}
    Find errors
        {job="docker"} |= "error"
    Case-insensitive error
        {job="docker"} |~ "(?i)error"
    Exclude noise
        {job="docker"} != "health"
    Regex filter
        {job="docker"} |~ "status=[45]\\d{2}"

    📈 Metrics from logs
    Count logs
        count_over_time({job="docker"}[5m])
    Log rate
        rate({job="docker"}[5m])
    Top containers
        topk(5, sum by (container_name) (rate({job="docker"}[5m])))
    
    🧪 Exercise Answer
    Error logs (last 1 hour)
        {container_name="notes-app"} |= "error"
    👉 Set time range = Last 1 hour

    Errors per minute
        rate({container_name="notes-app"} |= "error"[1m])

🔗 Task 6: Correlate Metrics & Logs
    Step 1: Add Logs Panel
        Open Dashboard
        Add Panel
        Data Source → Loki
        Query:
            {job="docker"}
            Visualization → Logs
    
    Step 2: Use Explore Split View
        👉 Grafana → Explore → Split View

    Left (Metrics)
        rate(container_cpu_usage_seconds_total{name="notes-app"}[5m])
    
    Right (Logs)
        {container_name="notes-app"}

    🎯 What you achieve
        See CPU spike 📈
        Instantly see logs at same time 📜
        Debug faster ⚡
    💡 Why this is powerful
        Instead of:
        ❌ Checking Prometheus + ELK separately

        You now:
        ✅ See cause + effect in one place

        👉 Faster incident resolution
        👉 Better root cause analysis

⚖️ Loki vs ELK (Important for Documentation)
    | Feature  | Loki              | ELK                |
    | -------- | ----------------- | ------------------ |
    | Indexing | Labels only       | Full text          |
    | Cost     | Low               | High               |
    | Setup    | Simple            | Complex            |
    | Search   | Limited           | Powerful           |
    | Use case | DevOps monitoring | Deep log analytics |

🧠 When to use:

✅ Loki

Kubernetes / Docker monitoring
Cost-sensitive systems
Metrics + logs together

✅ ELK

Security analysis
Full-text search
Complex queries