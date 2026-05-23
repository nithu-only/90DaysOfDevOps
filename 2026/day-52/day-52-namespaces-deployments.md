### Day 52 – Kubernetes Namespaces and Deployments

## What are Namespaces and Why Use Them?

    Namespaces in Kubernetes are used to organize and isolate resources within a cluster.

    🔹 Why they are useful:
        Separate environments (dev, staging, production)
        Avoid naming conflicts
        Apply resource quotas and access controls
        Better cluster organization
    
    🔹 Default Namespaces:
        kubectl get namespaces

    You will see:

        default → Default workspace
        kube-system → Internal Kubernetes components
        kube-public → Public resources
        kube-node-lease → Node heartbeat tracking

    Check system pods:
        kubectl get pods -n kube-system
    
    ![alt text](image.png)

## Creating and Using Namespaces
    Create namespaces:
        kubectl create namespace dev
        kubectl create namespace staging

    Using a manifest:
        # namespace.yaml
        apiVersion: v1
        kind: Namespace
        metadata:
        name: production
        kubectl apply -f namespace.yaml

    Run pods in namespaces:
        kubectl run nginx-dev --image=nginx:latest -n dev
        kubectl run nginx-staging --image=nginx:latest -n staging
    
    View pods:
        kubectl get pods          # default namespace only
        kubectl get pods -A       # all namespaces
    ![alt text](image-1.png)

## Deployment Breakdown
    🔹 apiVersion: apps/v1
    Specifies the API version for Deployment resources.

    🔹 kind: Deployment
    Defines that this resource is a Deployment.

    🔹 metadata
    name: Name of deployment
    namespace: Where it runs
    labels: Used for identification
    
    🔹 spec
    Defines desired state

    replicas: Number of pods (3)
    selector: Links deployment to pods
    template: Blueprint for pods

    🔹 template
    Contains Pod configuration:

    Labels (must match selector)
    Container definition
    Image and ports

    Creating the Deployment
    kubectl apply -f nginx-deployment.yaml

    Check:
    kubectl get deployments -n dev
    kubectl get pods -n dev

    Key Columns:
    READY → Running containers / desired containers
    UP-TO-DATE → Pods updated to latest spec
    AVAILABLE → Pods ready to serve traffic

## Self-Healing Behavior

    This is the key difference between a Deployment and a standalone Pod.

    # List pods
    kubectl get pods -n dev

    # Delete one of the deployment's pods (use an actual pod name from your output)
    kubectl delete pod <pod-name> -n dev

    # Immediately check again
    kubectl get pods -n dev
    The Deployment controller detects that only 2 of 3 desired replicas exist and immediately creates a new one. The deleted pod is replaced within seconds.

    New pod has a different name
    Deployment ensures desired replicas always run

## Scaling Deployments

    Change the number of replicas:
    # Scale up to 5
    kubectl scale deployment nginx-deployment --replicas=5 -n dev
    kubectl get pods -n dev

    # Scale down to 2
    kubectl scale deployment nginx-deployment --replicas=2 -n dev
    kubectl get pods -n dev

    Declarative Scaling:
    Update YAML:

    replicas: 4

    kubectl apply -f nginx-deployment.yaml
    
    What happens?
    Scaling up → New pods created
    Scaling down → Extra pods terminated

## Rolling Updates

    Update image:
    kubectl set image deployment/nginx-deployment nginx=nginx:1.25 -n dev

    Track rollout:
    kubectl rollout status deployment/nginx-deployment -n dev

    How it works:
    Pods updated one by one
    Zero downtime ensured
    Old pods removed only after new ones are ready

    Check history:
    kubectl rollout history deployment/nginx-deployment -n dev

    Rollback:
    kubectl rollout undo deployment/nginx-deployment -n dev
    kubectl rollout status deployment/nginx-deployment -n dev

    Verify:
    kubectl describe deployment nginx-deployment -n dev | grep Image
    
    Result:
    Image reverts to previous version (nginx:1.24)

## Clean Up

    kubectl delete deployment nginx-deployment -n dev
    kubectl delete pod nginx-dev -n dev
    kubectl delete pod nginx-staging -n staging
    kubectl delete namespace dev staging production

    Verify:
    kubectl get namespaces
    kubectl get pods -A
