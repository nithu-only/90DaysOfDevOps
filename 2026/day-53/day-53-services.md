# Day 53 -- Kubernetes Services

## What Problem Services Solve

Pods in Kubernetes are ephemeral: - Pod IPs change on restart - Multiple
Pods exist in a Deployment

Services provide: - Stable IP - DNS name - Load balancing

------------------------------------------------------------------------

## Deployment

``` yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
```

------------------------------------------------------------------------

## ClusterIP Service

``` yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-clusterip
spec:
  type: ClusterIP
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
```

Use: Internal communication

------------------------------------------------------------------------

## NodePort Service

``` yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-nodeport
spec:
  type: NodePort
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
```

Use: External access via node IP

------------------------------------------------------------------------

## LoadBalancer Service

``` yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-loadbalancer
spec:
  type: LoadBalancer
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
```

Use: Cloud external access

------------------------------------------------------------------------

## DNS in Kubernetes

Format: `<service-name>`{=html}.`<namespace>`{=html}.svc.cluster.local

Example: web-app-clusterip.default.svc.cluster.local

------------------------------------------------------------------------

## Endpoints

Check: kubectl get endpoints web-app-clusterip

Endpoints = Pod IPs behind Service

------------------------------------------------------------------------

## Service Comparison

  Type           Access        Use Case
  -------------- ------------- --------------------
  ClusterIP      Internal      Service-to-service
  NodePort       NodeIP:Port   Testing
  LoadBalancer   External IP   Production

------------------------------------------------------------------------

## Verification Commands

kubectl get services kubectl describe service web-app-loadbalancer
kubectl get endpoints

------------------------------------------------------------------------

## Cleanup

kubectl delete -f app-deployment.yaml kubectl delete -f
clusterip-service.yaml kubectl delete -f nodeport-service.yaml kubectl
delete -f loadbalancer-service.yaml
