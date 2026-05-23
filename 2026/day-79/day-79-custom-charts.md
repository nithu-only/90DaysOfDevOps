# Day 79 — Custom Helm Charts for AI-BankApp

## Objective

The goal of this task is to convert the 12 raw Kubernetes manifests from the `k8s/` directory of the AI-BankApp project into a reusable and configurable Helm chart.

By the end of this implementation, the complete application stack (Spring Boot BankApp, MySQL, and Ollama AI chatbot) can be deployed using a single Helm command.

---

# Task 1 — Scaffold the Chart and Study the Raw Manifests

## Step 1: Clone the Repository

Clone the repository and switch to the correct branch.

git clone -b feat/gitops https://github.com/TrainWithShubham/AI-BankApp-DevOps.git
cd AI-BankApp-DevOps

Verify the branch:
git branch


Expected Output:
* feat/gitops

## Step 2: Study the Existing Kubernetes Manifests

List all Kubernetes manifests inside the `k8s/` directory.
ls k8s/

Expected files:
bankapp-deployment.yml
cert-manager.yml
configmap.yml
gateway.yml
hpa.yml
mysql-deployment.yml
namespace.yml
ollama-deployment.yml
pv.yml
pvc.yml
secrets.yml
service.yml

### Purpose of Each Manifest

| File Name              | Purpose                                          |
| ---------------------- | ------------------------------------------------ |
| namespace.yml          | Creates the bankapp namespace                    |
| configmap.yml          | Stores MySQL host, database name, and Ollama URL |
| secrets.yml            | Stores MySQL credentials                         |
| pv.yml                 | Defines StorageClass                             |
| pvc.yml                | Creates Persistent Volume Claims                 |
| bankapp-deployment.yml | Deploys Spring Boot banking application          |
| mysql-deployment.yml   | Deploys MySQL database                           |
| ollama-deployment.yml  | Deploys Ollama AI chatbot                        |
| service.yml            | Creates Kubernetes services                      |
| hpa.yml                | Configures Horizontal Pod Autoscaler             |
| gateway.yml            | Configures Envoy Gateway                         |
| cert-manager.yml       | Configures TLS certificate issuer                |


## Step 3: Create the Helm Chart

Create a Helm chart directory.

mkdir helm-chart
cd helm-chart

Scaffold a new Helm chart:
helm create bankapp


Expected folder structure:
bankapp/
├── Chart.yaml
├── values.yaml
├── charts/
├── templates/
└── charts/

## Step 4: Remove Auto-Generated Templates

Delete the default templates because custom templates will be created.
rm -rf bankapp/templates/*.yaml
rm -rf bankapp/templates/tests/


Verify the remaining files:
ls bankapp/templates

Expected output:
_helpers.tpl
NOTES.txt

# Task 2 — Configure Chart.yaml and values.yaml

## Step 1: Configure Chart.yaml

Open the file:
nano bankapp/Chart.yaml

Replace the content with:
apiVersion: v2
name: bankapp
description: AI-BankApp -- Spring Boot banking application with MySQL and Ollama AI chatbot
type: application
version: 0.1.0
appVersion: "1.0.0"

maintainers:
  - name: TrainWithShubham
    url: https://github.com/TrainWithShubham

keywords:
  - bankapp
  - spring-boot
  - mysql
  - ollama
  - ai

## Step 2: Configure values.yaml

Open the file:
nano bankapp/values.yaml

Paste the provided `values.yaml` configuration from the assignment.

### Why `values.yaml`?

Instead of hardcoding values directly in Kubernetes manifests, Helm uses variables from `values.yaml`.

Example:

Hardcoded approach:
image: trainwithshubham/ai-bankapp-eks:latest

Helm approach:
image: "{{ .Values.bankapp.image.repository }}:{{ .Values.bankapp.image.tag }}"

Benefits:

* Easier environment-specific configuration
* Reusable deployments
* No manual YAML modifications
* Easier upgrades and maintenance

## Step 3: Validate the Chart

Run:
helm lint bankapp/

Expected output:
1 chart(s) linted, 0 chart(s) failed

# Task 3 — Create Core Templates

All templates are created inside:
bankapp/templates/

## Step 1: Create ConfigMap Template

Create file:
nano bankapp/templates/configmap.yaml

Paste the ConfigMap template provided in the task.

Validate rendering:
helm template my-bankapp bankapp/

Verify:
kind: ConfigMap


### Purpose

The ConfigMap stores:

* MySQL host
* MySQL port
* Database name
* Ollama URL

Helm dynamically injects values using:
{{ .Values }}

## Step 2: Create Secret Template

Create file:
nano bankapp/templates/secrets.yaml

Paste the Secret template.

### Key Improvement

Previously, credentials required manual Base64 encoding:
echo -n "Test@123" | base64

Helm automatically encodes secrets using:
| b64enc

Render templates:
helm template my-bankapp bankapp/

Verify:
kind: Secret

## Step 3: Create Storage Template

Create file:
nano bankapp/templates/storage.yaml

Paste the StorageClass and PVC template.

### StorageClass Logic

The StorageClass is conditionally created.

Enabled:
storageClass.create=true

Disabled:
--set storageClass.create=false

### Persistent Volume Claims

MySQL PVC is created only when:
mysql.enabled=true

Ollama PVC is created only when:
ollama.enabled=true

Validate:
helm template my-bankapp bankapp/

Verify:
kind: PersistentVolumeClaim

# Task 4 — Create Deployment Templates

## Step 1: Create BankApp Deployment

Create file:
nano bankapp/templates/bankapp-deployment.yaml

Paste the deployment template.

### Improvements Over Raw YAML

Hardcoded service names are replaced with dynamic naming.

Before:
name: mysql

After:
{{ include "bankapp.fullname" . }}-mysql

This ensures unique resource names across environments.

### Init Containers

Init containers wait for dependencies before the Spring Boot application starts.

Purpose:

* Wait for MySQL
* Wait for Ollama

Without init containers:

* Application startup may fail
* CrashLoopBackOff may occur

### Conditional Ollama Support

Disable Ollama:
--set ollama.enabled=false

This automatically removes:

* Ollama Deployment
* Ollama Service
* Ollama PVC
* Wait-for-Ollama init container

## Step 2: Create MySQL Deployment

Create file:
nano bankapp/templates/mysql-deployment.yaml

Paste template.

### Improvements

#### Secret-Based Credentials

Credentials are injected securely using Kubernetes Secrets.
MYSQL_ROOT_PASSWORD

#### Persistent Storage

Volume mount:
/var/lib/mysql

Ensures database persistence after pod restarts.

#### Recreate Strategy
type: Recreate

Prevents multiple pods from accessing the same volume.

## Step 3: Create Ollama Deployment

Create file:
nano bankapp/templates/ollama-deployment.yaml

Paste template.

### Lifecycle Hook

Automatically downloads the model:
ollama pull tinyllama

### Dynamic Model Selection

Change models without modifying YAML.

Example:
--set ollama.model=llama2

# Task 5 — Create Services and HPA

## Step 1: Create Services

Create file:
nano bankapp/templates/services.yaml

Paste service template.

### Services Created

| Service         | Purpose                 |
| --------------- | ----------------------- |
| bankapp-mysql   | MySQL database access   |
| bankapp-ollama  | Ollama communication    |
| bankapp-service | Spring Boot application |

## Step 2: Create HPA

Create file:
nano bankapp/templates/hpa.yaml

Paste HPA template.

### Autoscaling Behavior

When CPU utilization exceeds 70%:
2 → 4 replicas

When CPU usage decreases, pods scale down automatically.

# Task 6 — Validate and Deploy

## Step 1: Lint the Chart

Validate syntax:
helm lint bankapp/

Expected output:
1 chart(s) linted, 0 chart(s) failed

## Step 2: Render Templates Locally

Render manifests:
helm template my-bankapp bankapp/

Expected resources:

* ConfigMap
* Secret
* Deployment
* Service
* PersistentVolumeClaim
* HorizontalPodAutoscaler

All Helm placeholders should be resolved.

## Step 3: Test Overrides

Render chart with overrides:
helm template my-bankapp bankapp/ \
  --set bankapp.image.tag=abc1234 \
  --set bankapp.replicaCount=2 \
  --set ollama.enabled=false

Expected Result:

* Ollama Deployment removed
* Ollama Service removed
* Ollama PVC removed
* Wait-for-Ollama init container removed

## Step 4: Dry Run Installation

Validate installation without deployment:

helm install my-bankapp bankapp/ \
  --dry-run --debug \
  -n bankapp \
  --create-namespace

## Step 5: Deploy on Kind

Since Kind uses the `standard` StorageClass:
helm install my-bankapp bankapp/ \
  -n bankapp \
  --create-namespace \
  --set storageClass.create=false \
  --set mysql.persistence.storageClass=standard \
  --set ollama.persistence.storageClass=standard

Wait for Ollama to download the model.

## Step 6: Verify Deployment

Check Helm release:
helm list -n bankapp

Check resources:
kubectl get all -n bankapp

Check PVCs:
kubectl get pvc -n bankapp

Check ConfigMaps and Secrets:
kubectl get configmap,secret -n bankapp

Watch pod status:
kubectl get pods -n bankapp -w

Wait until all pods show:
Running

## Step 7: Access the Application

Forward service port:
kubectl port-forward svc/my-bankapp-bankapp-service -n bankapp 8080:8080

Open:
http://localhost:8080
```

Expected Result:

The AI-BankApp login page should appear.

## Step 8: Cleanup

Remove deployment:
helm uninstall my-bankapp -n bankapp

Verify cleanup:
kubectl get all -n bankapp

# Helm Template Syntax Cheat Sheet

### Access Values
{{ .Values.bankapp.image.tag }}


### Conditional Statements
{{- if .Values.ollama.enabled }}

### Include Helper Functions
{{ include "bankapp.fullname" . }}

### Convert Objects to YAML
{{- toYaml . | nindent 12 }}

### Base64 Encoding
{{ .Values.secrets.mysqlPassword | b64enc }}

### YAML Indentation
nindent

# Final Outcome

Successfully converted 12 raw Kubernetes manifests into a reusable Helm chart.

### Achievements

* Fully configurable deployment using `values.yaml`
* Dynamic resource generation using Helm templates
* ConfigMap, Secrets, PVCs, Deployments, Services, and HPA templated
* Conditional Ollama deployment support
* Helm validation using `helm lint`
* Manifest rendering using `helm template`
* Single-command deployment:

helm install my-bankapp bankapp/


The AI-BankApp stack can now be deployed, updated, and rolled back efficiently using Helm.
