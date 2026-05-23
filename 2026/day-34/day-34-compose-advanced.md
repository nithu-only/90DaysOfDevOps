**\### Day 33 -- Docker Compose: Real-World Multi-Container Apps**

**\## Task 1: Build Your Own App Stack**

> **Created a folder structure:**  
> ![](media/image1.png){width="2.987759186351706in" height="1.8543274278215223in"}
>
> **Docker-compose file:  
> **version: \"5.0.2\"
>
> services:
>
> web:
>
> build: ./app
>
> container_name: web_app
>
> ports:
>
> \- \"3000:3000\"
>
> depends_on:
>
> db:
>
> condition: service_healthy
>
> environment:
>
> \- DB_HOST=db
>
> \- DB_USER=root
>
> \- DB_PASSWORD=root
>
> \- DB_NAME=testdb
>
> \- REDIS_HOST=redis
>
> networks:
>
> \- app-network
>
> labels:
>
> \- \"project=day34\"
>
> \- \"tier=frontend\"
>
> db:
>
> image: mysql:8
>
> container_name: mysql_db
>
> restart: always
>
> environment:
>
> MYSQL_ROOT_PASSWORD: root
>
> MYSQL_DATABASE: testdb
>
> volumes:
>
> \- db-data:/var/lib/mysql
>
> healthcheck:
>
> test: \[\"CMD\", \"mysqladmin\", \"ping\", \"-h\", \"localhost\", \"-proot\"\]
>
> interval: 5s
>
> timeout: 5s
>
> retries: 5
>
> networks:
>
> \- app-network
>
> labels:
>
> \- \"project=day34\"
>
> \- \"tier=database\"
>
> redis:
>
> image: redis:7
>
> container_name: redis_cache
>
> networks:
>
> \- app-network
>
> labels:
>
> \- \"project=day34\"
>
> \- \"tier=cache\"
>
> volumes:
>
> db-data:
>
> networks:
>
> app-network:
>
> driver: bridge
>
> **Dockerfile:  
> **![](media/image2.png){width="3.4586329833770777in" height="2.5002165354330708in"}
>
> **Package.json:**
>
> ![](media/image3.png){width="3.812830271216098in" height="2.1251837270341207in"}
>
> **Output:  
> **![](media/image4.png){width="4.306541994750656in" height="1.2312587489063866in"}

**\##Task 2: depends_on & Healthchecks**

1.  **Add depends_on to your compose file so the app starts after the database**

2.  **Add a healthcheck on the database service**

3.  **Use depends_on with condition: service_healthy so the app waits for the database to be truly ready, not just started**

> **Test: Bring everything down and up --- does the app wait for the DB?  
> **
>
> The app waits until Postgres is truly ready  
> No more connection refused errors

**\##Task 3: Restart Policies**

1.  **Add restart: always to your database service**

2.  **Manually kill the database container --- does it come back?  
    **Container automatically restarts.

3.  **Try restart: on-failure --- how is it different?**

Restarts only if container exits with non-zero status.

4.  **Write in your notes: When would you use each restart policy?**

- Batch jobs

- Workers

- Production databases

- Critical services that must always stay up

- Services that should not restart if manually stopped

**\## Task 4: Custom Dockerfiles in Compose**

1.  **Instead of using a pre-built image for your app, use build: in your compose file to build from a Dockerfile**

2.  **Make a code change in your app**

3.  **Rebuild and restart with one command**

docker compose up --build  
  
**\## Task 5: Named Networks & Volumes**

1.  **Define explicit networks in your compose file instead of relying on the default**

networks:

app-network:

driver: bridge

2.  **Define named volumes for database data  
    **volumes:

db-data:

3.  **Add labels to your services for better organization  
    **All services communicate via service names:

- db

- redis

- web

**\## Task:6 Scaling  
Try scaling your web app to 3 replicas using docker compose up --scale**

docker compose up \--scale web=3

**What happens? What breaks?**

Docker creates:

- web\_

- web_2

- web_3

**Write in your notes: Why doesn\'t simple scaling work with port mapping?**

Because of port mapping. Only one container can bind to host port 3000.

**Why Simple Scaling Fails?**

Because:

- All replicas try to bind to the same host port.

- Docker Compose is not a load balancer.
