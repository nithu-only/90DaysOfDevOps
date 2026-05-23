# Day 49 – DevSecOps: Add Security to CI/CD Pipeline

## What is DevSecOps?

DevSecOps means integrating security directly into the CI/CD pipeline so that vulnerabilities are detected early during development instead of after deployment.  
It ensures security checks are automated and enforced before code reaches production.


## What I Implemented

### 1. Docker Image Vulnerability Scan (Trivy)

    Added a security scan after building the Docker image in the main pipeline.
    - name: Scan Docker Image for Vulnerabilities
    uses: aquasecurity/trivy-action@master
    with:
        image-ref: '${{ secrets.DOCKER_USERNAME }}/github-actions-capstone:latest'
        format: 'table'
        exit-code: '1'
        severity: 'CRITICAL,HIGH'

    What it does:
        Scans Docker image for known vulnerabilities (CVEs)
        Fails pipeline if CRITICAL or HIGH issues are found

    Observation:
        Base image used: node:18-alpine
        Pipeline result:  Failed

### 2. Dependency Vulnerability Scan (PR Level)

    Added dependency review in PR pipeline.

    - name: Check Dependencies for Vulnerabilities
    uses: actions/dependency-review-action@v4
    with:
        fail-on-severity: critical

    What it does:
        Scans newly added dependencies in PRs
        Blocks PR if critical vulnerability is detected

    Verification:
        Opened a PR with new dependency
        Dependency scan ran successfully in PR checks

### 3. GitHub Secret Scanning

    Enabled from repository settings.

    Features:
        Secret Scanning → Detects exposed secrets after commit
        Push Protection → Blocks commits containing secrets

    If a secret (e.g., AWS key) is leaked:
        GitHub detects it automatically
        Alerts the user
        May revoke the key (for supported providers)

### 4. Workflow Permissions (Least Privilege)

    Restricted workflow permissions in pipelines.
    permissions:
    contents: read

    For PR workflows:
    permissions:
    contents: read
    pull-requests: write

    Why important:

    Prevents unauthorized access if an action is compromised
    Limits potential damage to repository

### Secure CI/CD Pipeline Flow
    🔹 Pull Request Flow
    PR Opened
    → Build & Test
    → Dependency Scan 🔐
    → PR Pass / Fail

    🔹 Main Branch Flow
    Push to main
    → Build & Test
    → Docker Build
    → Trivy Scan 🔐
    → Docker Push (only if secure)
    → Deploy

    🔹 Always Active
    → Secret Scanning 🔐
    → Push Protection 🔐