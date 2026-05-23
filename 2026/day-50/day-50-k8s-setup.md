# Day 50 – Kubernetes Architecture and Cluster Setup

## Kubernetes Story (From Memory + Verified)

    Kubernetes was created to solve the problem of managing containers at scale. While Docker helps run containers, it does not handle orchestration like scaling, load balancing, self-healing, or deployment across multiple machines.

    Kubernetes was originally developed by Google, inspired by their internal system called Borg, which managed containers at massive scale.

    The name "Kubernetes" comes from Greek, meaning **"helmsman" or "pilot"**, symbolizing steering containerized applications.

## Kubernetes Architecture

    ### Control Plane (Master Node)

    - **API Server**
    - Entry point to the cluster
    - All commands (kubectl) go through this

    - **etcd**
    - Key-value database storing cluster state

    - **Scheduler**
    - Assigns pods to nodes based on resources and constraints

    - **Controller Manager**
    - Ensures desired state matches actual state
    - Handles replication, node health, etc.


    ### Worker Node

    - **kubelet**
    - Communicates with API server
    - Ensures containers are running as expected

    - **kube-proxy**
    - Manages networking rules
    - Enables communication between pods

    - **Container Runtime**
    - Runs containers (e.g., containerd, CRI-O)


    ## What Happens When You Run:

    ### `kubectl apply -f pod.yaml`

    1. kubectl sends request → API Server
    2. API Server validates and stores state in etcd
    3. Scheduler assigns pod to a node
    4. kubelet on that node pulls image and runs container
    5. Controller ensures desired state is maintained

    ### If API Server Goes Down

    - kubectl commands fail
    - Cluster cannot accept new changes
    - Existing workloads keep running (no new scheduling)

    ### If Worker Node Goes Down

    - Pods on that node become unavailable
    - Controller detects failure
    - Scheduler recreates pods on other nodes

## Cluster Setup Choice

    **Chosen Tool: kind (Kubernetes in Docker)**

    ### Why kind?

    - Lightweight and fast
    - Runs inside Docker (no VM required)
    - Ideal for DevOps practice and CI/CD testing
    - Easy to create and destroy clusters quickly

    ### Installation commands
    Invoke-WebRequest -Uri "https://kind.sigs.k8s.io/dl/latest/kind-windows-amd64" -OutFile "kind.exe"
    move .\kind.exe C:\Windows\System32\
    kind version
    kind create cluster --name devops-cluster
    ![alt text](image.png)

    ### Nodes
    kubectl get nodes

### kube-system Pods Explanation
    etcd
        Stores cluster data
    kube-apiserver
        Handles all API requests
    kube-scheduler
        Assigns pods to nodes
    kube-controller-manager
        Maintains desired state
    coredns
        DNS service for service discovery
    kube-proxy
        Handles networking across nodes

### Some useful commands
    # See cluster info
    kubectl cluster-info

    # List all nodes
    kubectl get nodes

    # Get detailed info about your node
    kubectl describe node <node-name>

    # List all namespaces
    kubectl get namespaces

    # See ALL pods running in the cluster (across all namespaces)
    kubectl get pods -A

    # Delete your cluster
    kind delete cluster --name devops-cluster

    # Recreate it
    kind create cluster --name devops-cluster

    # Verify it is back
    kubectl get nodes

    # Check which cluster kubectl is connected to
    kubectl config current-context

    # List all available contexts (clusters)
    kubectl config get-contexts

    # See the full kubeconfig
    kubectl config view

### kubectl Config
    What is kubeconfig?
        A kubeconfig file is a configuration file that stores cluster connection details such as:

            Cluster endpoint
            User credentials
            Contexts

    Default Location:
    ~/.kube/config