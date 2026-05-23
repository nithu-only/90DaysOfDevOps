## Day 73 -- Introduction to Observability and Prometheus

## Task 1: Understand Observability
    Step 1: Write short notes (use this in your .md file)

        What is Observability?
        Observability is the ability to understand a system’s internal state by analyzing its outputs (metrics, logs, traces).

        Observability vs Monitoring

        Monitoring → tells WHEN something is wrong
        Observability → helps you understand WHY it is wrong

    Step 2: Learn the 3 Pillars
        1. Metrics

        Numerical data over time
        Example: CPU usage, request count
        Tools: Prometheus

        2. Logs

        Event-based records
        Example: error logs, debug logs
        Tools: Loki, ELK

        3. Traces

        Request flow across services
        Example: API → DB → Payment service
        Tools: Jaeger, OpenTelemetry

    Step 3: Why all 3 matter   
        | Pillar  | Purpose      |
        | ------- | ------------ |
        | Metrics | Detect issue |
        | Logs    | Debug issue  |
        | Traces  | Locate issue |

    Step 4: Architecture (write this in markdown)
        [App] --> metrics --> [Prometheus] --> [Grafana]
        [App] --> logs --> [Promtail] --> [Loki] --> [Grafana]
        [App] --> traces --> [OTEL Collector] --> [Grafana]
        [Host] --> metrics --> [Node Exporter] --> [Prometheus]
        [Docker] --> metrics --> [cAdvisor] --> [Prometheus]


## Task 2: Setup Prometheus with Docker
    Step 1: Create project folder
        mkdir observability-stack
        cd observability-stack
    Step 2: Create prometheus.yml
        global:
        scrape_interval: 15s
        evaluation_interval: 15s

        scrape_configs:
        - job_name: "prometheus"
            static_configs:
            - targets: ["localhost:9090"]
    Step 3: Create docker-compose.yml
        services:
        prometheus:
            image: prom/prometheus:latest
            container_name: prometheus
            ports:
            - "9090:9090"
            volumes:
            - ./prometheus.yml:/etc/prometheus/prometheus.yml
            - prometheus_data:/prometheus
            command:
            - '--config.file=/etc/prometheus/prometheus.yml'
            restart: unless-stopped

        volumes:
        prometheus_data:
    Step 4: Start Prometheus
        docker compose up -d
    Step 5: Verify
        Open:
        http://localhost:9090
    
✅ Task 3: Understand Prometheus Concepts
    Step 1: Learn key concepts
        Scrape Target → endpoint Prometheus pulls metrics from
        Time Series → metric + labels
    
    Step 2: Metric Types
        | Type      | Description    | Example          |
        | --------- | -------------- | ---------------- |
        | Counter   | Only increases | total_requests   |
        | Gauge     | Goes up/down   | memory_usage     |
        | Histogram | Buckets        | request_duration |
        | Summary   | Percentiles    | latency          |

    Step 3: Run queries in UI (/graph)
        Total metrics
            count({__name__=~".+"})
        Memory usage
            process_resident_memory_bytes
        HTTP requests
            prometheus_http_requests_total
        Filter by handler
            prometheus_http_requests_total{handler="/api/v1/query"}
    
    Step 4: Answer this (for markdown)
    Counter vs Gauge
        Counter → only increases
        Example: total API requests
        Gauge → increases & decreases
        Example: CPU usage

## Task 4: Learn PromQL Basics
    Step 1: Instant Vector
        up
        👉 Output:
        1 = healthy
        0 = down
    
    Step 2: Range Vector
        prometheus_http_requests_total[5m]
    
    Step 3: Rate (MOST IMPORTANT)
        rate(prometheus_http_requests_total[5m])
    
    Step 4: Aggregation
        sum(rate(prometheus_http_requests_total[5m]))
    
    Step 5: Filter
        prometheus_http_requests_total{code="200"}
        prometheus_http_requests_total{code!="200"}
    
    Step 6: Convert bytes → MB
        process_resident_memory_bytes / 1024 / 1024
    
    Step 7: Top K
        topk(5, prometheus_http_requests_total)
    Step 8: ✅ Challenge Query (IMPORTANT)
        Non-200 requests rate
        rate(prometheus_http_requests_total{code!="200"}[5m])

## Task 5: Add Sample Application
    Step 1: Update docker-compose.yml
        services:
        prometheus:
            image: prom/prometheus:latest
            container_name: prometheus
            ports:
            - "9090:9090"
            volumes:
            - ./prometheus.yml:/etc/prometheus/prometheus.yml
            - prometheus_data:/prometheus
            command:
            - '--config.file=/etc/prometheus/prometheus.yml'
            restart: unless-stopped

        notes-app:
            image: trainwithshubham/notes-app:latest
            container_name: notes-app
            ports:
            - "8000:8000"
            restart: unless-stopped

        volumes:
        prometheus_data:
    
    Step 2: Update prometheus.yml
        scrape_configs:
        - job_name: "prometheus"
            static_configs:
            - targets: ["localhost:9090"]

        - job_name: "notes-app"
            static_configs:
            - targets: ["notes-app:8000"]
        
    Step 3: Restart
        docker compose up -d
        Step 4: Verify

        Go to:

        Status → Targets

        ✅ You should see:

        prometheus → UP
        notes-app → UP
        Step 5: Generate traffic
        curl http://localhost:8000
        curl http://localhost:8000
        curl http://localhost:8000

## Task 6: Data Retention & Storage
    Step 1: Check storage usage
        docker exec prometheus du -sh /prometheus
    
    Step 2: Understand storage
        Prometheus uses TSDB (Time Series Database)
        Default retention = 15 days
    Step 3: Change retention
        Update docker-compose:

        command:
        - '--config.file=/etc/prometheus/prometheus.yml'
        - '--storage.tsdb.retention.time=30d'
        - '--storage.tsdb.retention.size=1GB'
    
    Step 4: Check TSDB UI
        Go to:
        Status → TSDB Status