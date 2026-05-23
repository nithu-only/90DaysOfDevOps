## Pipeline Architecture

PR opened
↓
Build & Test Workflow

Merge to main
↓
Build & Test
↓
Docker Build & Push
↓
Deploy to Production Every 12 Hours
↓
Health Check Workflow

## Workflows

1. reusable-build-test.yml (Builds the application and runs tests.)
    name: Reusable Build and Test

    on:
    workflow_call:
        inputs:
        node_version:
            required: true
            type: string
        run_tests:
            required: false
            type: boolean
            default: true

        outputs:
        test_result:
            description: "Test Result"
            value: ${{ jobs.build.outputs.test_result }}

    jobs:
    build:
        runs-on: ubuntu-latest

        outputs:
        test_result: ${{ steps.result.outputs.result }}

        steps:

        - name: Checkout Code
            uses: actions/checkout@v4

        - name: Setup Node
            uses: actions/setup-node@v4
            with:
            node-version: ${{ inputs.node_version }}

        - name: Install Dependencies
            run: npm install

        - name: Run Tests
            if: ${{ inputs.run_tests }}
            run: npm test

        - name: Set Output
            id: result
            run: echo "result=passed" >> $GITHUB_OUTPUT

2. reusable-docker.yml (Builds and pushes Docker image to Docker Hub.)
    name: Reusable Docker Build

    on:
    workflow_call:
        inputs:
        image_name:
            required: true
            type: string
        tag:
            required: true
            type: string

        secrets:
        docker_username:
            required: true
        docker_token:
            required: true

    jobs:

    docker:
        runs-on: ubuntu-latest

        steps:

        - name: Checkout Code
            uses: actions/checkout@v4

        - name: Login to DockerHub
            run: echo "${{ secrets.docker_token }}" | docker login -u "${{ secrets.docker_username }}" --password-stdin

        - name: Build Image
            run: docker build -t ${{ secrets.docker_username }}/${{ inputs.image_name }}:${{ inputs.tag }} .

        - name: Push Image
            run: docker push ${{ secrets.docker_username }}/${{ inputs.image_name }}:${{ inputs.tag }}


3. pr-pipeline.yml (Runs tests on pull requests.) 
    name: PR Pipeline

    on:
    pull_request:
        branches: [ main ]
        types: [opened, synchronize]

    jobs:

    build-test:
        uses: ./.github/workflows/reusable-build-test.yml
        with:
        node_version: "18"
        run_tests: true

    pr-comment:
        runs-on: ubuntu-latest
        needs: build-test

        steps:
        - name: PR Summary
            run: echo "PR checks passed for branch ${{ github.head_ref }}"

4. main-pipeline.yml (Runs full CI/CD pipeline when code is merged to main.)
    name: Main Pipeline

    on:
    push:
        branches:
        - main

    jobs:

    build-test:
        uses: ./.github/workflows/reusable-build-test.yml
        with:
        node_version: "18"
        run_tests: true

    docker:
        needs: build-test
        uses: ./.github/workflows/reusable-docker.yml

        with:
        image_name: github-actions-capstone
        tag: latest

        secrets:
        docker_username: ${{ secrets.DOCKER_USERNAME }}
        docker_token: ${{ secrets.DOCKER_TOKEN }}

    deploy:
        needs: docker
        runs-on: ubuntu-latest
        environment: production

        steps:
        - name: Deploy Step
            run: echo "Deploying image to production"

5. health-check.yml (Runs container health check every 12 hours.)
    name: Health Check

on:
  schedule:
    - cron: '0 */12 * * *'
  workflow_dispatch:

jobs:
  health-check:

    runs-on: ubuntu-latest

    steps:

      - name: Pull Image
        run: docker pull ${{ secrets.DOCKER_USERNAME }}/github-actions-capstone:latest

      - name: Run Container
        run: docker run -d -p 3000:3000 --name test-container ${{ secrets.DOCKER_USERNAME }}/github-actions-capstone:latest

      - name: Wait
        run: sleep 5

      - name: Health Test
        run: curl -f http://localhost:3000/health

      - name: Stop Container
        run: docker rm -f test-container

      - name: Summary
        run: |
          echo "## Health Check Report" >> $GITHUB_STEP_SUMMARY
          echo "- Image- github-actions-capstone:latest" >> $GITHUB_STEP_SUMMARY
          echo "- Status- PASSED" >> $GITHUB_STEP_SUMMARY
          echo "- Time- $(date)" >> $GITHUB_STEP_SUMMARY

![alt text](image.png)

## Docker Image

https://hub.docker.com/repository/docker/axata/github-actions-capstone

## Improvements for Future

Slack notifications
Multi-environment deployments (dev/staging/prod)
Rollback automation
Security scanning with Trivy
Kubernetes deployment