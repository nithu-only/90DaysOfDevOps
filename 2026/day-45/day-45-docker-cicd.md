# Day 45 – Docker Build & Push with GitHub Actions

## Objective

The goal of today's task was to build a complete CI/CD pipeline using GitHub Actions that automatically builds a Docker image and pushes it to Docker Hub whenever code is pushed to the repository.

This simulates a real-world production workflow where developers push code and the CI/CD pipeline handles the build and delivery of container images automatically.


## Technologies Used

- GitHub Actions
- Docker
- Docker Hub
- Node.js
- Git


## Workflow Overview

The pipeline performs the following steps automatically:

1. A developer pushes code to the GitHub repository.
2. GitHub Actions workflow is triggered.
3. The runner checks out the repository code.
4. Docker builds the image using the Dockerfile.
5. The image is tagged with:
   - `latest`
   - `sha-<short-commit-hash>`
6. GitHub Actions logs into Docker Hub using stored secrets.
7. The Docker image is pushed to Docker Hub.
8. The image becomes available for deployment anywhere.


## Workflow File

The CI/CD pipeline is defined in:

.github/workflows/docker-publish.yml

This workflow:

- Runs on `push`
- Builds the Docker image
- Pushes the image only when the branch is `main`

## Docker Image Tags

Two tags are generated for better version control:

- `latest` – points to the most recent stable build
- `sha-<commit-hash>` – uniquely identifies the exact version of the code

Example:


username/github-actions-practice:latest
username/github-actions-practice:sha-abc123

## Branch Control Logic

The pipeline builds the Docker image for all branches.

However, pushing the image to Docker Hub only happens when changes are pushed to the **main branch**.

This prevents unnecessary images from feature branches.

Example behavior:

| Branch | Build Image | Push Image |
|------|------|------|
| main | Yes | Yes |
| feature branch | Yes | No |
| pull request | Yes | No |


## Testing the Image

After the image is pushed to Docker Hub, it can be pulled and run locally.

Pull the image:

docker pull <dockerhub-username>/github-actions-practice:latest

Run the container:

docker run -p 3000:3000 <dockerhub-username>/github-actions-practice:latest

Open in browser:

http://localhost:3000


## Full Journey: Git Push to Running Container

The complete process works as follows:

Developer pushes code to GitHub
        ↓
GitHub Actions workflow triggers
        ↓
Runner checks out repository code
        ↓
Docker image builds from Dockerfile
        ↓
Image is tagged with latest and commit SHA
        ↓
GitHub logs into Docker Hub
        ↓
Image pushed to Docker Hub
        ↓
Server or developer pulls the image
        ↓
Docker container runs the application