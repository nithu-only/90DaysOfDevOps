# Docker Cheat Sheet

A quick reference for commonly used Docker commands.

---

# Container Commands

docker run -it nginx bash  
Run a container interactively

docker run -d -p 8080:80 nginx  
Run container in detached mode with port mapping

docker ps  
List running containers

docker ps -a  
List all containers

docker stop <container_id>  
Stop a running container

docker start <container_id>  
Start a stopped container

docker rm <container_id>  
Remove a container

docker exec -it <container_id> bash  
Execute command inside running container

docker logs <container_id>  
View container logs

---

# Image Commands

docker build -t myimage:1.0 .  
Build image from Dockerfile

docker images  
List local images

docker pull nginx  
Download image from Docker Hub

docker push username/myimage:1.0  
Push image to Docker Hub

docker tag myimage username/myimage:latest  
Tag image for pushing to Docker Hub

docker rmi <image_id>  
Remove an image

---

# Volume Commands

docker volume create myvolume  
Create a named volume

docker volume ls  
List volumes

docker volume inspect myvolume  
Inspect volume details

docker volume rm myvolume  
Remove a volume

docker run -v myvolume:/data nginx  
Attach volume to container

---

# Bind Mounts

docker run -v $(pwd):/app node  
Mount current directory to container

---

# Network Commands

docker network create mynetwork  
Create custom network

docker network ls  
List networks

docker network inspect mynetwork  
Inspect network details

docker network connect mynetwork container_name  
Connect container to network

docker run -d --network mynetwork nginx  
Run container on custom network

---

# Docker Compose Commands

docker compose up  
Start services

docker compose up -d  
Start services in detached mode

docker compose down  
Stop and remove containers

docker compose ps  
List compose services

docker compose logs  
View logs from services

docker compose build  
Build images defined in compose file

---

# Cleanup Commands

docker system df  
Show Docker disk usage

docker system prune  
Remove unused containers, networks, images

docker container prune  
Remove stopped containers

docker image prune  
Remove unused images

docker volume prune  
Remove unused volumes

---

# Dockerfile Instructions

FROM node:18  
Base image

WORKDIR /app  
Set working directory

COPY package.json .  
Copy files to container

RUN npm install  
Execute command during build

EXPOSE 3000  
Expose container port

CMD ["node", "app.js"]  
Default command to run container

ENTRYPOINT ["node"]  
Define main executable