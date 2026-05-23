# Day 36 – Docker Project: Dockerizing a Full Application

## Overview

This project demonstrates how to **Dockerize a complete full-stack backend application** using **Docker, Docker Compose, and MongoDB**.

The application is a simple **Task Manager API** built with **Node.js and Express** that allows users to create and retrieve tasks stored in **MongoDB**.

The project showcases how to:

* Containerize an application using **Docker**
* Orchestrate multiple containers using **Docker Compose**
* Use **environment variables** for configuration
* Implement **database persistence using volumes**
* Apply **multi-stage builds** to reduce image size
* Run containers securely using a **non-root user**

This simulates a **real-world production-ready containerized setup**.

---

# Tech Stack

* Node.js
* Express.js
* MongoDB
* Docker
* Docker Compose

---

# Project Structure

```
day36-docker-project
│
├── app
│   ├── index.js
│   └── package.json
│
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
├── .env
├── README.md
└── day-36-docker-project.md
```

---

# Application Features

* Create tasks
* Retrieve tasks
* Store data in MongoDB
* Fully containerized application
* Persistent database storage

---

# Architecture

```
User Request
     │
     ▼
Node.js Express API (Docker Container)
     │
     ▼
MongoDB Database (Docker Container)
     │
     ▼
Persistent Volume (Docker Volume)
```

---

# Environment Variables

Create a `.env` file in the root directory.

```
MONGO_URI=mongodb://mongo:27017/tasks
PORT=3000
```

| Variable  | Description                     |
| --------- | ------------------------------- |
| MONGO_URI | MongoDB connection string       |
| PORT      | Port where the Node.js app runs |

---

# Docker Setup

## Build and Run the Application

Run the following command:

```
docker compose up --build
```

This will:

* Build the application image
* Start the Node.js container
* Start the MongoDB container
* Create a network between them
* Create a persistent volume for MongoDB

---

# Access the Application

Once containers are running, the API will be available at:

```
http://localhost:3000
```

---

# API Endpoints

## Create Task

POST request

```
POST /task
```

Example request body:

```
{
"title": "Learn Docker"
}
```

---

## Get All Tasks

GET request

```
GET /tasks
```

Returns all stored tasks from MongoDB.

---

# Database Persistence

MongoDB data is stored using a **Docker volume**:

```
mongo-data:/data/db
```

This ensures that **data is not lost when containers restart**.

---

# Docker Image

The application image is available on Docker Hub.

Example:

```
https://hub.docker.com/r/axatadarji/day36-task-app
```

---

# Run Using Only Docker Hub Image

After pushing the image, you can run the project without rebuilding.

Pull image:

```
docker pull axatadarji/day36-task-app:latest
```

Then start using Docker Compose.

---

# Docker Best Practices Implemented

* Multi-stage Docker builds
* Alpine base images for smaller image size
* Non-root user for security
* Environment variable configuration
* Healthchecks for database container
* Persistent volumes
* Custom Docker network

---

# Learning Outcomes

Through this project I learned:

* How to Dockerize real applications
* How to connect multiple containers
* How to manage container networking
* How to persist database data using volumes
* How to build production-ready Docker images

---

# Future Improvements

* Add a frontend UI
* Add authentication
* Deploy to Kubernetes
* Implement CI/CD pipeline
* Add automated testing

---

# Author

**Axata Darji**

Master of Applied Computer Science
DevOps & Cloud Enthusiast
