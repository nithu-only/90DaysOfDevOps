# Day 37 – Docker Revision

## Self Assessment Checklist

| Skill | Status |
|-----|-----|
Run a container from Docker Hub | Can Do |
List, stop, remove containers/images | Can Do |
Explain image layers and caching | Can Do |
Write Dockerfile from scratch | Can Do |
Explain CMD vs ENTRYPOINT | Shaky |
Build and tag custom image | Can Do |
Create and use named volumes | Can Do |
Use bind mounts | Can Do |
Create custom networks | Can Do |
Write docker-compose.yml | Can Do |
Use environment variables in Compose | Shaky |
Write multi-stage Dockerfile | Can Do |
Push image to Docker Hub | Can Do |
Use healthchecks and depends_on | Shaky |

---

# Quick Fire Questions

## 1. Difference between Image and Container

A Docker **image** is a read-only template that contains application code, libraries, dependencies, and configuration required to run an application.

A **container** is a running instance of an image. It is a lightweight isolated environment where the application executes.

Example:

docker run nginx

This command creates a container from the nginx image.

---

## 2. What happens to data when a container is removed?

Data stored inside the container filesystem is **deleted when the container is removed**.

To persist data, we use:

- Docker volumes
- Bind mounts

Example:

docker run -v myvolume:/data nginx

---

## 3. How do two containers communicate on the same network?

If containers are attached to the **same custom Docker network**, they can communicate using their **container names as hostnames**.

Example:

docker network create mynetwork

docker run -d --name db --network mynetwork mysql

docker run -d --name app --network mynetwork node

The app container can reach the database using:

db:3306

---

## 4. Difference between `docker compose down` and `docker compose down -v`

docker compose down  
Stops and removes containers, networks.

docker compose down -v  
Stops and removes containers, networks **and volumes**.

This means persistent data stored in volumes will also be deleted.

---

## 5. Why are multi-stage builds useful?

Multi-stage builds allow us to:

- Reduce final image size
- Remove build dependencies
- Improve security
- Improve build performance

Example:

Build stage → compile code  
Production stage → copy only compiled files

This results in smaller and cleaner production images.

---

## 6. Difference between COPY and ADD

COPY

- Copies files from host to container
- Simple and recommended for most use cases

ADD

- Can copy files
- Can automatically extract tar archives
- Can download remote URLs

Best practice: **Use COPY unless ADD is specifically required.**

---

## 7. What does `-p 8080:80` mean?

It maps:

Host Port → Container Port

8080 (host) → 80 (container)

Example:

docker run -p 8080:80 nginx

Access application at:

http://localhost:8080

---

## 8. How to check Docker disk usage?

Command:

docker system df

It shows:

- Image size
- Container usage
- Volume usage
- Build cache size