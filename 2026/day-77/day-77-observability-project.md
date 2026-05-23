## Day 77 -- Observability Project: Full Stack with Docker Compose

## Task 1: Clone and Launch the Reference Stack
    Step 1: Clone the Repository
        Open terminal and run:
            git clone https://github.com/LondheShubham153/observability-for-devops.git
        Go inside the project:
            cd observability-for-devops

    Step 2: Understand Project Structure
        Install tree if not installed.  
            sudo apt install tree
            tree -I 'node_modules|build|staticfiles|__pycache__'

            You should see:
                observability-for-devops/
                │── docker-compose.yml
                │── prometheus.yml
                │── grafana/
                │   └── provisioning/
                │       ├── datasources/
                │       └── dashboards/
                │── loki/
                │── promtail/
                │── otel-collector/
                │── notes-app/

            Understand What Each Folder Does
                | Folder/File        | Purpose                |
                | ------------------ | ---------------------- |
                | docker-compose.yml | Runs all services      |
                | prometheus.yml     | Metrics scraping       |
                | grafana/           | Dashboard provisioning |
                | loki/              | Log storage            |
                | promtail/          | Log collection         |
                | otel-collector/    | Trace collection       |
                | notes-app/         | Demo application       |
    
    Step 3: Start Entire Stack  
        docker compose up -d
        
        What happens?
            Docker will:

            Pull required images
            Create containers
            Create internal monitoring network
            Start all 8 services

    Step 4: Verify Containers Are Running
        docker compose ps
        NAME                STATUS
        prometheus          Up
        grafana             Up
        node-exporter       Up
        cadvisor            Up
        loki                Up
        promtail            Up
        otel-collector      Up
        notes-app           Up

    Step 5: Validate Every Service

        1. Prometheus
            Open:
                http://localhost:9090
                Should open Prometheus UI.

        2. Node Exporter
        Run:
            curl http://localhost:9100/metrics | head -5

            Expected:

            # HELP go_gc_duration_seconds
            # TYPE go_gc_duration_seconds summary
            This means host metrics are exposed.

        3. cAdvisor
            Open:
                http://localhost:8080
            You should see container metrics UI.

        4. Grafana
            Open:
            http://localhost:3000
            Login:
                username: admin
                password: admin

        5. Loki
            Run:
                curl http://localhost:3100/ready
            Expected:
                ready

        6. OTEL Collector
            Check logs:
                docker logs otel-collector
            Look for:
            Everything is ready

        7. Notes App
            Open:
                http://localhost:8000
            Then API:
                http://localhost:8000/api/

## Task 2: Validate Metrics Pipeline
    Now verify Prometheus → Node Exporter → cAdvisor → OTEL metrics flow.
    Step 1: Open Targets Page
        Go to:
        http://localhost:9090/targets

        You should see:
        UP Targets
        prometheus
        node-exporter
        cadvisor
        otel-collector

        Everything should be green.
        If DOWN:
        Check logs:
            docker compose logs prometheus

    Step 2: Run PromQL Validation Queries
        Go to:
        http://localhost:9090

        Click Graph tab.
        Query 1: All Targets Health
            up
            Expected:
                1
            for every target.

        Query 2: CPU Usage
        100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

        What this means:
            Calculate idle CPU
            Convert to used CPU %
            Query 3: Memory Usage
            (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100
        Shows RAM utilization.

        Query 4: Container CPU
            rate(container_cpu_usage_seconds_total{name!=""}[5m]) * 100
        Shows CPU per container.

        Query 5: Top 3 Memory Containers
            topk(3, container_memory_usage_bytes{name!=""})
            Shows biggest memory consumers.

    Step 3: Compare With Your Previous Setup
        Open:
        cat prometheus.yml
        
        Compare with Day 73–76:
            Things to compare:
            Scrape jobs
            Example:
            scrape_configs:
            - job_name: prometheus
            - job_name: node-exporter
            - job_name: cadvisor
            - job_name: otel-collector

## Task 3: Validate Logs Pipeline
    Now test:

    Application → Docker logs → Promtail → Loki → Grafana

    Step 1: Generate Traffic
        Run:
        for i in $(seq 1 50); do
        curl -s http://localhost:8000 > /dev/null
        curl -s http://localhost:8000/api/ > /dev/null
        done
        This generates logs.

        Without traffic:
        Grafana may show No Data.

    Step 2: Open Grafana Explore
        Go:
            http://localhost:3000
        Click:
            Explore
                Select datasource:
                Loki
    
    Step 3: Run LogQL Queries
        All Container Logs
        {job="docker"}
        Shows logs from all containers.

        Notes App Logs Only
        {container_name="notes-app"}
        Error Logs
        {job="docker"} |= "error"

        Find failures.

        GET Requests
        {container_name="notes-app"} |= "GET"

        Shows request logs.

        Log Rate Per Container
        sum by (container_name) (rate({job="docker"}[5m]))

        Shows log volume.

    Step 4: Verify Promtail Targets
        Run:
        curl -s http://localhost:9080/targets | head -30
        You should see Docker log paths being watched.

    Step 5: Compare Promtail Config
        Open:
            cat promtail/promtail-config.yml
        Compare:
            Labels
            labels:
            job: docker
            Docker log path
            /var/lib/docker/containers/*/*.log

## Task 4: Validate Traces Pipeline
    Now test:
        Application → OTEL Collector → Trace Processing

    Step 1: Send Test Trace
        Run exact command:
        curl -X POST http://localhost:4318/v1/traces \
        -H "Content-Type: application/json" \
        -d @trace.json

        What this does:
            Creates:
                Parent Span
                GET /api/notes
            And child span:
                SELECT notes FROM database
                Simulating:
            HTTP request
            └── database query
            This is distributed tracing.

    Step 2: Verify Collector Received Trace
        Run:
        docker logs otel-collector 2>&1 | grep -A 20 "GET /api/notes"

        Expected:
        You should see:
            service.name: notes-app
            http.method: GET
            http.route: /api/notes
            db.system: sqlite

        You should also see:
        Parent-child relationship
        parentSpanId

    Step 3: Compare OTEL Config
        Open:
        cat otel-collector/otel-collector-config.yml

        Look for:
        Receivers
        receivers:
        otlp:
            protocols:
            grpc:
            http:
        Processors
        processors:
        batch:
        Exporters
        exporters:
        debug:
        Pipeline:
        service:
        pipelines:

## Task 5: Build Production Overview Dashboard
    Go:
    Grafana → Dashboards → New Dashboard
    Row 1 — System Health
    CPU Usage (Gauge)
    Query:

        100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
        Memory Usage
        (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100
        Disk Usage
        (1 - node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}) * 100
        Targets Up
        sum(up) / count(up)

        Panel:

        Stat
        Row 2 — Container Metrics
        CPU Time Series
        rate(container_cpu_usage_seconds_total{name!=""}[5m]) * 100

        Legend:

        {{name}}
        Memory Bar Chart
        container_memory_usage_bytes{name!=""} / 1024 / 1024
        Container Count
        count(container_last_seen{name!=""})
        Row 3 — Logs

        Datasource:

        Loki
        App Logs
        {container_name="notes-app"}

        Panel type:

        Logs
        Error Rate
        sum(rate({job="docker"} |= "error" [5m]))
        Log Volume
        sum by (container_name) (rate({job="docker"}[5m]))
        Row 4 — Service Overview
        Scrape Duration
        prometheus_target_interval_length_seconds{quantile="0.99"}
        OTEL Metrics
        otelcol_receiver_accepted_metric_points

    Step 2: Save Dashboard
        Name:
        Production Overview -- Observability Stack

        Settings:
        Time Range
        Last 30 minutes
        Auto Refresh
        10 seconds