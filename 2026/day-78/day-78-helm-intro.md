
# Day 78 -- Introduction to Helm and Chart Basics
## Objective
Learn Helm fundamentals, deploy applications using Helm charts, manage releases, and prepare for converting AI-BankApp raw Kubernetes manifests into a Helm chart.

# Task 1: Understand Helm Concepts

    ## Step 1: What is Helm?
        Helm is the **package manager for Kubernetes**, similar to:

        - `apt` for Ubuntu
        - `yum` for RHEL
        - `npm` for Node.js

        Instead of manually applying multiple Kubernetes YAML files:
        kubectl apply -f deployment.yml
        kubectl apply -f service.yml
        kubectl apply -f secret.yml
        kubectl apply -f pvc.yml

        You can deploy everything with:
        helm install bankapp ./chart

        Helm packages Kubernetes resources into reusable units called **Charts**.

    ## Step 2: Learn Core Helm Concepts
        ### 1. Chart
        A **Chart** is a reusable package of Kubernetes manifests.

        Example structure:
        mysql-chart/
        ├── Chart.yaml
        ├── values.yaml
        └── templates/
            ├── deployment.yaml
            ├── service.yaml
            └── secret.yaml

        A chart can include:

        - Deployment
        - StatefulSet
        - Service
        - ConfigMap
        - Secret
        - PVC
        - Ingress

        **Think:** Chart = Kubernetes application package

        ### 2. Release

        A **Release** is an installed instance of a chart.

        Example:
        helm install mysql-dev bitnami/mysql
        helm install mysql-prod bitnami/mysql

        Now you have:

        - mysql-dev
        - mysql-prod

        Check releases:
        helm list

        ### 3. Repository

        A **Repository** stores Helm charts.

        Examples:

        - DockerHub → Docker Images
        - Helm Repository → Helm Charts

        Add repository:
        helm repo add bitnami https://charts.bitnami.com/bitnami

        Search charts:
        helm search repo bitnami

        ### 4. Values
        Values customize a chart deployment.

        Example template:
        replicas: {{ .Values.replicaCount }}

        Override:
        replicaCount: 3

        This enables reusable deployments for:
        - dev
        - staging
        - production

        ## Why Helm Over Raw Manifests?

        AI-BankApp has 12 YAML files:
        bankapp-deployment.yml
        mysql-deployment.yml
        service.yml
        configmap.yml
        secrets.yml
        pv.yml
        pvc.yml
        gateway.yml
        hpa.yml

        ### Problems with Raw YAML

        - Hardcoded values
        - Manual edits
        - No rollback
        - Environment duplication

        ### Helm Benefits

        - Templating
        - Versioning
        - Rollback
        - Dependency management
        - Reusability

# Task 2: Install Helm and Explore AI-BankApp

    ## Step 1: Clone Repository
    git clone -b feat/gitops https://github.com/TrainWithShubham/AI-BankApp-DevOps.git

    cd AI-BankApp-DevOps

    Verify branch:
    git branch

    Expected:
    * feat/gitops

    ## Step 2: Create Kind Cluster

    Ensure Docker Desktop is running.

    Create cluster:
    kind create cluster --config setup-k8s/kind-config.yml

    Verify nodes:
    kubectl get nodes

    Expected:
    kind-control-plane
    kind-worker
    kind-worker2

    ## Step 3: Install Helm
    ### macOS
    brew install helm

    ### Linux
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

    Verify:
    helm version

    ## Step 4: Verify Kubernetes Connection
    kubectl cluster-info
    Check Helm:
    helm list

    ## Step 5: Explore AI-BankApp Kubernetes Files
    ls k8s/
    Expected:
    bankapp-deployment.yml
    configmap.yml
    gateway.yml
    mysql-deployment.yml
    namespace.yml
    ollama-deployment.yml
    pv.yml
    pvc.yml
    secrets.yml
    service.yml
    hpa.yml
    cert-manager.yml

    Observation:
    You are managing **12 hardcoded YAML files manually**.
    Tomorrow (Day 79), these will become Helm templates.

# Task 3: Deploy MySQL Using Helm

    ## Step 1: Add Bitnami Repository
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm repo update

    ## Step 2: Search MySQL Chart
    helm search repo bitnami/mysql

    ## Step 3: Install MySQL
    helm install bankapp-mysql bitnami/mysql   --set auth.rootPassword=Test@123   --set auth.database=bankappdb   --set primary.resources.requests.memory=256Mi   --set primary.resources.requests.cpu=250m   --set primary.resources.limits.memory=512Mi   --set primary.resources.limits.cpu=500m   --set primary.persistence.size=5Gi

    Wait for pods:
    kubectl get pods -w

    Wait until:
    Running

    ## Step 4: Verify Helm Release
    helm list

    Expected release:
    bankapp-mysql

    ## Step 5: Verify Created Resources
    Check resources:
    kubectl get all -l app.kubernetes.io/instance=bankapp-mysql

    Check PVC:
    kubectl get pvc -l app.kubernetes.io/instance=bankapp-mysql

    Check Secrets:
    kubectl get secret -l app.kubernetes.io/instance=bankapp-mysql

    ## Step 6: Verify MySQL
    Get pod:
    kubectl get pods

    Connect:
    kubectl exec -it bankapp-mysql-0 -- mysql -uroot -pTest@123

    Inside MySQL:
    SHOW DATABASES;

    Expected:
    bankappdb

    Exit:
    exit

# Task 4: Customize Deployment with Values File

    ## Step 1: Create Values File
    Create:
    touch mysql-values.yaml

    Add:
        auth:
        rootPassword: Test@123
        database: bankappdb

        primary:
        resources:
            limits:
            cpu: 500m
            memory: 512Mi
            requests:
            cpu: 250m
            memory: 256Mi

        persistence:
            size: 5Gi
            storageClass: ""

        metrics:
        enabled: true
        serviceMonitor:
            enabled: false

    ## Step 2: Deploy Using Values File
    helm install bankapp-mysql-v2 bitnami/mysql -f mysql-values.yaml

    ## Step 3: Verify Release
    helm list

    Expected:
    bankapp-mysql
    bankapp-mysql-v2

    ## Step 4: Explore Available Values
    helm show values bitnami/mysql | head -80

    Observe configurable options:
    - replication
    - metrics
    - persistence
    - resources
    - init scripts

    ## Step 5: Remove Second Release
    helm uninstall bankapp-mysql-v2

    Verify:
    helm list

# Task 5: Manage Releases (Upgrade, Rollback, Uninstall)
    ## Step 1: Upgrade Release
    Enable metrics:
    helm upgrade bankapp-mysql bitnami/mysql   --set auth.rootPassword=Test@123   --set auth.database=bankappdb   --set metrics.enabled=true

    ## Step 2: Check Revision History
    helm history bankapp-mysql

    Expected:
    REVISION
    1 deployed
    2 deployed

    ## Step 3: Rollback
    Rollback:
    helm rollback bankapp-mysql 1

    ## Step 4: Verify Rollback
    helm history bankapp-mysql

    Expected:
    1 deployed
    2 superseded
    3 deployed

    Helm keeps full revision history.

# Task 6: Explore Chart Structure
    ## Step 1: Pull Chart Locally
    helm pull bitnami/mysql --untar

    View structure:
    ls mysql/

    Expected:
    Chart.yaml
    values.yaml
    charts/
    templates/
    README.md

    ## Step 2: Explore Chart.yaml
    cat mysql/Chart.yaml

    Example:
    apiVersion: v2
    name: mysql
    description: A Helm chart for MySQL
    version: 12.2.1
    appVersion: "8.0.40"

    ### version
    Chart version.
    Used when chart logic/templates change.

    ### appVersion
    Application version.
    Represents actual software version (MySQL).

    ## Step 3: Explore Templates
    List templates:
    ls mysql/templates

    Open StatefulSet template:
    cat mysql/templates/primary/statefulset.yaml

    Example:
    replicas: {{ .Values.primary.replicaCount }}

    Helm injects values dynamically.

    Override example:
    --set primary.replicaCount=3

    ## Step 4: Explore values.yaml
    cat mysql/values.yaml

    Study configurable parameters.

    ## Step 5: Render Templates Locally
    Render without deployment:
    helm template test bitnami/mysql

    Useful for debugging manifests.

    ## Step 6: Cleanup
    Delete release:
    helm uninstall bankapp-mysql

    Delete chart:
    rm -rf mysql/
