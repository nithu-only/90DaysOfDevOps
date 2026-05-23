# Day 36 -- Docker Project: Dockerizing a Full Application {#day-36-docker-project-dockerizing-a-full-application}

## 1. Application Chosen and Why {#application-chosen-and-why}

For this project, I chose to build and Dockerize a **Node.js Express Task Manager API with MongoDB**.

The application provides basic functionality to:

- Create tasks

- Retrieve tasks

- Store them in a MongoDB database

I selected this application because it represents a **common real-world backend architecture** where:

- A backend API service communicates with a database

- Multiple containers must run together

- Services must communicate through container networking

This project helped demonstrate several important DevOps concepts including:

- Containerizing applications using Docker

- Running multi-container environments using Docker Compose

- Managing environment variables

- Persisting database data using volumes

- Implementing health checks for service reliability

- Applying Docker best practices such as non-root users and multi-stage builds

This setup closely simulates how backend services are containerized and deployed in real production environments.

# 2. Dockerfile with Explanation {#dockerfile-with-explanation}

Below is the Dockerfile used to build the Node.js application image.

\# Stage 1: Build stage

\# Using a lightweight Node.js Alpine image to reduce the overall image size

FROM node:20-alpine AS builder

\# Set the working directory inside the container

WORKDIR /app

\# Copy package files first to leverage Docker layer caching

COPY app/package\*.json ./

\# Install Node.js dependencies

RUN npm install

\# Copy the rest of the application source code

COPY app .

\# Stage 2: Production stage

\# Create a smaller final image containing only the required files

FROM node:20-alpine

\# Set working directory

WORKDIR /app

\# Create a non-root user and group for security

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

\# Copy the built application from the builder stage

COPY \--from=builder /app .

\# Switch to the non-root user

USER appuser

\# Expose the port used by the Node.js application

EXPOSE 3000

\# Command to start the application

CMD \[\"node\", \"index.js\"\]

### Key Best Practices Used

- **Alpine base image** to keep the image lightweight

- **Multi-stage build** to separate dependency installation and runtime

- **Layer caching optimization** by copying package files first

- **Non-root user** to improve container security

- **Minimal final image size**

# 3. Challenges Faced and Solutions {#challenges-faced-and-solutions}

### Challenge 1: Application Starting Before MongoDB

When running the containers together, the Node.js application sometimes attempted to connect to MongoDB before the database container was fully ready.

**Solution**

A **health check** was added to the MongoDB container in the docker-compose.yml file, and the application container was configured with depends_on using the health condition.

This ensured the API container only started after MongoDB became healthy.

### Challenge 2: Large Docker Image Size

The initial Docker image size was larger than expected because it included unnecessary layers and development dependencies.

**Solution**

I optimized the image by:

- Using the **node:alpine** base image

- Implementing a **multi-stage Docker build**

- Using a **.dockerignore file** to exclude unnecessary files such as .git and node_modules

These optimizations significantly reduced the final image size.

### Challenge 3: Running Containers as Root

By default, containers run as the root user, which is considered a security risk.

**Solution**

I created a **non-root user (appuser)** inside the container and configured the container to run the application under that user.

This improves security and follows container best practices used in production systems.

# 4. Final Docker Image Size {#final-docker-image-size}

After applying the optimizations and using the Alpine base image, the final Docker image size was approximately:

**\~120 MB**

This is significantly smaller compared to standard Node.js images that can exceed 400 MB.

# 5. Docker Hub Image {#docker-hub-image}

The Docker image for this project has been pushed to Docker Hub and can be accessed at:

https://hub.docker.com/repository/docker/axata/task-app

You can pull the image using:

docker pull axata/task-app:latest

This allows the application to be deployed quickly without rebuilding the image locally.

# Conclusion

This project demonstrates how to containerize a full application stack using Docker and Docker Compose. It highlights important containerization practices such as image optimization, service orchestration, container networking, and secure runtime configurations.

The project simulates how backend services are packaged and deployed in modern cloud-native environments.
