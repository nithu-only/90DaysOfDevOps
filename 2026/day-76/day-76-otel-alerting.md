# Day 76 — OpenTelemetry and Alerting

## Overview

Today completes the **three pillars of observability**:

* Metrics → Prometheus
* Logs → Loki
* Traces → OpenTelemetry

Additionally, alerting is configured so the system proactively notifies issues instead of manual monitoring.

---

# Task 1 — Understanding OpenTelemetry

## What is OpenTelemetry (OTEL)?

* Open-source, vendor-neutral observability framework
* Handles:

  * Metrics
  * Logs
  * Traces
* Not a storage backend
* Sends data to systems like Prometheus, Loki, Jaeger, Grafana

---

## What is OTEL Collector?

A service that processes telemetry data using pipelines:

Receivers → Processors → Exporters

* **Receivers**: Accept incoming data (OTLP, Prometheus, Jaeger)
* **Processors**: Transform data (batching, filtering)
* **Exporters**: Send data to destinations (Prometheus, debug, Jaeger)

---

## What is OTLP?

* OpenTelemetry Protocol (standard format)
* Supports:

  * gRPC → Port 4317
  * HTTP → Port 4318

---

## What are Distributed Traces?

* Track request across services
* Components:

  * Trace → entire request lifecycle
  * Span → individual step

Example:
User → API → Auth Service → Database


---

# Task 2 — OpenTelemetry Collector Setup

## Create directory

mkdir -p otel-collector


## Create configuration file

`otel-collector/otel-collector-config.yml`

receivers:
  otlp:
    protocols:
      grpc:
      http:

processors:
  batch:

exporters:
  prometheus:
    endpoint: "0.0.0.0:8889"
  debug:
    verbosity: detailed

service:
  pipelines:
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [prometheus]

    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [debug]

    logs:
      receivers: [otlp]
      processors: [batch]
      exporters: [debug]


## Update docker-compose

otel-collector:
  image: otel/opentelemetry-collector-contrib:latest
  container_name: otel-collector
  ports:
    - "4317:4317"
    - "4318:4318"
    - "8889:8889"
  volumes:
    - ./otel-collector/otel-collector-config.yml:/etc/otelcol-contrib/config.yaml
  restart: unless-stopped


## Update Prometheus config

- job_name: "otel-collector"
  static_configs:
    - targets: ["otel-collector:8889"]

## Start services
docker compose up -d


## Verify collector

docker logs otel-collector | tail -5

Check Prometheus Targets → `otel-collector` should be **UP**


# 📡 Task 3 — Send Test Traces

## Send trace

curl -X POST http://localhost:4318/v1/traces \
-H "Content-Type: application/json" \
-d '{
  "resourceSpans": [{
    "resource": {
      "attributes": [{
        "key": "service.name",
        "value": { "stringValue": "my-test-service" }
      }]
    },
    "scopeSpans": [{
      "spans": [{
        "traceId": "5b8efff798038103d269b633813fc60c",
        "spanId": "eee19b7ec3c1b174",
        "name": "test-span",
        "kind": 1,
        "startTimeUnixNano": "1544712660000000000",
        "endTimeUnixNano": "1544712661000000000"
      }]
    }]
  }]
}'

## Verify trace

docker logs otel-collector | grep test-span

# 📊 Task 4 — Send Metrics

curl -X POST http://localhost:4318/v1/metrics \
-H "Content-Type: application/json" \
-d '{
  "resourceMetrics": [{
    "scopeMetrics": [{
      "metrics": [{
        "name": "test_requests_total",
        "sum": {
          "dataPoints": [{
            "asInt": "42",
            "timeUnixNano": "1544712661000000000"
          }],
          "aggregationTemporality": 2,
          "isMonotonic": true
        }
      }]
    }]
  }]
}'

## Query in Prometheus
test_requests_total


# 🚨 Task 5 — Prometheus Alerting

## Create alert rules file

`alert-rules.yml`

(Include CPU, Memory, ContainerDown, TargetDown, Disk alerts)


## Update Prometheus config

rule_files:
  - /etc/prometheus/alert-rules.yml


## Mount rules file

- ./alert-rules.yml:/etc/prometheus/alert-rules.yml


## Restart Prometheus
docker compose up -d prometheus

## Verify alerts

Prometheus UI:

Status → Rules
Alerts → View state


## Test alert
docker compose stop notes-app

Wait → Alert should fire

docker compose start notes-app

# 🔔 Task 6 — Grafana Alerting

## Create contact point

* Alerting → Contact Points
* Type: Email
* Name: DevOps Team

## Create alert rule

* Query:

container_memory_usage_bytes{name="notes-app"} / 1024 / 1024

* Condition: Above 100
* Evaluation: 1m for 2m
* Label: severity=warning

## Notification policy

* Default → DevOps Team
* Add rule:

  * severity=critical → separate routing


# ⚖️ Prometheus vs Grafana Alerts

| Feature       | Prometheus         | Grafana              |
| ------------- | ------------------ | -------------------- |
| Config        | YAML               | UI                   |
| Notifications | Needs Alertmanager | Built-in             |
| Use case      | Infra alerts       | App/dashboard alerts |

# 🏗️ Task 7 — Architecture

## Metrics Pipeline
Node Exporter → Prometheus → Grafana
cAdvisor → Prometheus → Grafana
OTEL → Prometheus → Grafana

## Logs Pipeline
Promtail → Loki → Grafana


## Traces Pipeline

App → OTEL → Debug (future: Jaeger/Tempo)


# 🔎 Services Overview

| Service        | Port           | Purpose           |
| -------------- | -------------- | ----------------- |
| Prometheus     | 9090           | Metrics           |
| Node Exporter  | 9100           | Host metrics      |
| cAdvisor       | 8080           | Container metrics |
| Grafana        | 3000           | Visualization     |
| Loki           | 3100           | Logs              |
| Promtail       | 9080           | Log collection    |
| OTEL Collector | 4317/4318/8889 | Telemetry         |
| Notes App      | 8000           | Sample app        |


# ✅ Final Verification
docker compose ps

All containers should be:

* Running
* Healthy

