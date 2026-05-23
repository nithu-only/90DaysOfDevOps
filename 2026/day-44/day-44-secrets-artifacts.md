# Day 44 – Secrets, Artifacts & Running Real Tests in CI

## 1. GitHub Secrets

    Secrets allow sensitive information like passwords, tokens, or API keys to be stored securely in GitHub Actions.  

    ### Steps Taken:
    - Created `MY_SECRET_MESSAGE` in GitHub repo settings → Secrets and Variables → Actions.
    - Verified that printing the secret directly shows `***` in logs.
    - Added additional secrets: `DOCKER_USERNAME` and `DOCKER_TOKEN` (for Day 45).

    ### Notes:
    - Secrets **should never be printed** in CI logs because logs are accessible to collaborators and can be stored long-term.
    - GitHub automatically masks secrets in logs to prevent accidental exposure.

---

## 2. Using Secrets as Environment Variables

    Secrets can be passed to steps as environment variables without hardcoding them.  

    env:
    SECRET_MESSAGE: ${{ secrets.MY_SECRET_MESSAGE }}
    run: echo "Length of secret ${#SECRET_MESSAGE}"

    Verified secret was never printed directly.

    Used safely in shell commands.

## 3. Uploading Artifacts

    Artifacts are files generated during a workflow and can be downloaded later.

    Steps Taken:

    Generated a file: report.txt with test or log information.

    Uploaded it using actions/upload-artifact@v4.

    Verified download from the Actions tab.

## 4. Downloading Artifacts Between Jobs

    Artifacts allow sharing files between jobs in a workflow.

    Example:

    Job 1: Create message.txt and upload as artifact.

    Job 2: Download artifact and print its contents.

    Use case in real pipelines:

    Separate build and deployment stages.

    Share logs, test reports, or compiled binaries between jobs.

    Output:
    Hello from Job 1

## 5. Running Real Tests in CI

    Added a test script: test-script.sh to simulate real testing.

    #!/bin/bash
    echo "Running test script..."
    if [ 2 -eq 2 ]; then
    echo "Test Passed"
    exit 0
    else
    echo "Test Failed"
    exit 1
    fi
    Workflow Steps:

    Checkout repository.

    Make script executable: chmod +x test-script.sh.

    Run script: ./test-script.sh.

    Notes:

    Pipeline passes when exit 0.

    Pipeline fails when exit 1.

    Intentionally broke script to see pipeline fail (RED ❌), then fixed it to go GREEN ✅.

    Demonstrates CI automatically catching problems before merging

## 6. Caching Dependencies

    Caching improves workflow speed by storing dependencies for future runs.

    Steps:

    Added actions/cache@v4 to cache ~/.npm.

    Installed dependencies with npm install.

    First run → Cache miss → Dependencies installed.

    Second run → Cache restored → Faster workflow.

    Notes:

    Cache stores node_modules (npm dependencies) in GitHub runner storage.

    Significant time savings on repeated runs.

    Workflow now demonstrates real CI speed improvements.