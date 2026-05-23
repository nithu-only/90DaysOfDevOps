#  Day 56 – Kubernetes StatefulSets

##  Overview

Deployments work well for stateless applications, but they are not suitable for stateful workloads like databases.

StatefulSets are designed for applications that require:
- Stable pod identity
- Ordered deployment and scaling
- Persistent storage
- Stable network identity


## When to Use StatefulSets

Use StatefulSets for:
- Databases (MySQL, PostgreSQL)
- Distributed systems (Kafka, Zookeeper)
- Applications needing:
  - Stable hostnames
  - Persistent storage
  - Ordered startup/shutdown


##  Deployment vs StatefulSet

| Feature | Deployment | StatefulSet |
|--------|------------|------------|
| Pod Names | Random (app-xyz) | Stable (app-0, app-1) |
| Startup Order | Parallel | Ordered |
| Storage | Shared PVC | Unique PVC per pod |
| Network Identity | Dynamic | Stable DNS |

---

## Task 1: Problem with Deployments

    kubectl create deployment nginx-deploy --image=nginx --replicas=3
    kubectl get pods

    ### Observation
    - Pod names are random (e.g., nginx-xyz-abc)
    - Deleting a pod creates a new one with a different name

    ### Problem
    Databases require stable identity for clustering and replication.

    ![alt text](image.png)

## Task 2: Headless Service

    ### service.yaml (important part)

        apiVersion: v1
        kind: Service
        metadata:
        name: my-headless-service
        spec:
        clusterIP: None
        selector:
            app: my-app
        ports:
            - port: 80
            targetPort: 80

    ### Apply

    kubectl apply -f service.yaml
    kubectl get svc

    ### Verification
    - CLUSTER-IP shows `None`

    ### Why?
    Headless Service creates individual DNS entries for each pod instead of load balancing.

    ![alt text](image-1.png)

## Task 3: StatefulSet Creation

    ### statefulset.yaml (important parts)
        apiVersion: apps/v1
        kind: StatefulSet
        metadata:
        name: web
        spec:
        serviceName: "web"
        replicas: 3
        selector:
            matchLabels:
            app: web
        template:
            metadata:
            labels:
                app: web
            spec:
            containers:
            - name: nginx
                image: nginx
                ports:
                - containerPort: 80
                volumeMounts:
                - name: web-data
                mountPath: /usr/share/nginx/html
        volumeClaimTemplates:
        - metadata:
            name: web-data
            spec:
            accessModes: ["ReadWriteOnce"]
            resources:
                requests:
                storage: 100Mi

    ### Apply

        kubectl apply -f statefulset.yaml
        kubectl get pods -l app=nginx -w


    ### Observation
    Pods are created in order:
    - web-0
    - web-1
    - web-2

    ### Check PVCs
    kubectl get pvc

    ### Expected PVCs
    - web-data-web-0
    - web-data-web-1
    - web-data-web-2

   ![alt text](image-2.png) 

## Task 4: Stable Network Identity
    
    ### Test DNS
    kubectl run busybox --image=busybox -it --rm -- sh

    nslookup web-0.web.default.svc.cluster.local
    nslookup web-1.web.default.svc.cluster.local
    nslookup web-2.web.default.svc.cluster.local

    ### Verify IP
    kubectl get pods -o wide

    ### Result
    DNS IP matches pod IP.
    ![alt text](image-3.png)
    ![alt text](image-4.png)

## Task 5: Data Persistence

    ### Write Data
    kubectl exec web-0 -- sh -c "echo 'Data from web-0' > /usr/share/nginx/html/index.html"

    ### Delete Pod
    kubectl delete pod web-0

    ### Verify Data
    kubectl exec web-0 -- cat /usr/share/nginx/html/index.html

    ### Result
    Data remains the same after pod recreation.

    ![alt text](image-5.png)

## Task 6: Ordered Scaling

    ### Scale Up
    kubectl scale statefulset web --replicas=5

    Pods created:
    - web-3
    - web-4

    ### Scale Down
    kubectl scale statefulset web --replicas=3

    Pods deleted:
    - web-4
    - web-3 (reverse order)

    ### Check PVCs
    kubectl get pvc

    ### Result
    All 5 PVCs still exist.
    ![alt text](image-6.png)

## 🧹 Task 7: Cleanup

    kubectl delete statefulset web
    kubectl delete svc web

    ### Check PVCs
    kubectl get pvc

    ### Important
    PVCs are NOT deleted automatically.

    ### Manual Cleanup
    kubectl delete pvc --all

## 🔑 Key Concepts

### Headless Service
- Required for StatefulSets
- Enables per-pod DNS

### Stable DNS
- Each pod gets a unique hostname

### volumeClaimTemplates
- Creates a PVC per pod automatically

---

## 🧪 Final Verification Answers

| Question                            | Answer |
|-------------------------------------|--------|
| Why random pod names are a problem? | Databases need stable identity |
| CLUSTER-IP value?                   | None |
| Pod names?                          | web-0, web-1, web-2 |
| PVC names?                          | web-data-web-0, web-data-web-1, web-data-web-2 |
| DNS IP match?                       | Yes |
| Data after pod recreation?          | Same |
| PVC count after scale down?         | 5 |
| PVC auto-deleted?                   | No |

---

## 📚 Summary

StatefulSets are essential for running stateful applications in Kubernetes.

They provide:
- Stable identity
- Persistent storage
- Ordered scaling and deployment

Used widely for databases and distributed systems in production.
