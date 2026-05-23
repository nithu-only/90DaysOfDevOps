# Day 51 – Kubernetes Manifests and Pods

## The Anatomy of a Kubernetes Manifest

Every Kubernetes resource is defined using a YAML file with four required fields:

- apiVersion: Specifies API version (v1 for Pods)
- kind: Defines resource type (Pod)
- metadata: Contains name and labels
- spec: Defines desired state (containers, images, ports, commands)

---

## Nginx Pod (nginx-pod.yaml)

apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80

Commands:
kubectl apply -f nginx-pod.yaml
kubectl get pods
kubectl describe pod nginx-pod
kubectl logs nginx-pod
kubectl exec -it nginx-pod -- /bin/bash

---

## BusyBox Pod (busybox-pod.yaml)

apiVersion: v1
kind: Pod
metadata:
  name: busybox-pod
  labels:
    app: busybox
    environment: dev
spec:
  containers:
  - name: busybox
    image: busybox:latest
    command: ["sh", "-c", "echo Hello from BusyBox && sleep 3600"]

Commands:
kubectl apply -f busybox-pod.yaml
kubectl get pods
kubectl logs busybox-pod

---

## Third Pod (alpine-pod.yaml)

apiVersion: v1
kind: Pod
metadata:
  name: alpine-pod
  labels:
    app: alpine
    environment: test
    team: devops
spec:
  containers:
  - name: alpine
    image: alpine:latest
    command: ["sh", "-c", "echo Alpine Pod Running && sleep 3600"]

Commands:
kubectl apply -f alpine-pod.yaml
kubectl get pods

---

## Imperative vs Declarative

Imperative:
kubectl run redis-pod --image=redis:latest

Declarative:
kubectl apply -f nginx-pod.yaml

Key Difference:
Imperative is command-based and quick for testing.
Declarative uses YAML, is reusable, and preferred for production.

---

## Validation Commands

kubectl apply -f nginx-pod.yaml --dry-run=client
kubectl apply -f nginx-pod.yaml --dry-run=server

Example Error:
error: spec.containers[0].image: Required value

---

## Labels and Filtering

kubectl get pods --show-labels
kubectl get pods -l app=nginx
kubectl get pods -l environment=dev

Add label:
kubectl label pod nginx-pod environment=production

Remove label:
kubectl label pod nginx-pod environment-

---

## Cleanup

kubectl delete pod nginx-pod
kubectl delete pod busybox-pod
kubectl delete pod alpine-pod
kubectl delete pod redis-pod

---

## Screenshot of Running Pods

Add screenshot of:
kubectl get pods

Ensure STATUS is Running.

---

## What Happens When You Delete a Standalone Pod?

- Pod is permanently deleted
- Not recreated automatically
- No controller manages it

Deployments are used in production to ensure pods are always running.

---

