**Day 39 -- CI/CD Concepts**

**1. The Problem (Manual Deployments)**

Imagine a team of **5 developers** working on the same repository and deploying code manually to production.

**What Can Go Wrong?**

Many problems can occur in a manual deployment process:

- **Code conflicts** when multiple developers push changes at the same time.

- **Human errors** during manual builds or deployments.

- **Unverified code** reaching production without testing.

- **Different environments** causing inconsistent application behavior.

- **Downtime risks** if deployment steps are missed.

Manual deployments become slower and riskier as the team and application grow.

**What Does "It Works on My Machine" Mean?**

This phrase means the code works perfectly on a developer's local system but **fails in another environment** (such as staging or production).

This happens due to:

- Different dependency versions

- Missing environment variables

- Different operating systems

- Configuration mismatches

CI/CD solves this by ensuring code is built and tested in **consistent environments automatically**.

**How Many Times a Day Can Teams Deploy Manually?**

In most organizations, manual deployments limit teams to **1--2 deployments per day**, sometimes even less.

Reasons include:

- Deployment risk

- Time required for testing

- Coordination between developers and operations teams

With CI/CD, teams can deploy **multiple times per day safely**.

**2. CI vs CD vs CD**

**Continuous Integration (CI)**

Continuous Integration is the practice where developers **frequently merge code changes into a shared repository**, and every change automatically triggers builds and tests.

CI helps detect issues early such as:

- Build failures

- Unit test failures

- Integration issues

**Example:**  
A developer pushes code to GitHub → automated pipeline runs tests → if tests fail, the code cannot be merged.

**Continuous Delivery (CD)**

Continuous Delivery ensures that code is **always in a deployable state**. After passing CI stages, the application is automatically prepared for deployment but requires **manual approval** to release to production.

**Example:**  
After tests pass, the pipeline automatically builds a Docker image and deploys it to a **staging environment**, waiting for manual approval before production release.

**Continuous Deployment (CD)**

Continuous Deployment goes one step further than Continuous Delivery. Every change that passes automated tests is **automatically deployed to production** without human intervention.

**Example:**  
A developer merges code → tests pass → Docker image builds → application automatically deploys to production.

This approach is used by companies like **Netflix and Amazon** that deploy multiple times per day.

**3. Pipeline Anatomy**

A CI/CD pipeline consists of several components.

**Trigger**

A **trigger** starts the pipeline execution.

Common triggers include:

- Code push to repository

- Pull request creation

- Scheduled execution

- Manual trigger

Example:  
git push to GitHub triggers a GitHub Actions workflow.

**Stage**

A **stage** represents a major phase in the pipeline.

Examples:

- Build

- Test

- Deploy

Stages organize the pipeline into logical steps.

**Job**

A **job** is a collection of steps executed within a stage.

For example:

Build Stage

- Job: Build Docker Image

Test Stage

- Job: Run Unit Tests

Each job runs on a runner.

**Step**

A **step** is a single command or action inside a job.

Examples:

npm install  
npm test  
docker build .

Steps execute sequentially inside a job.

**Runner**

A **runner** is the machine that executes the pipeline jobs.

Examples:

- GitHub-hosted runners

- Self-hosted runners

- Jenkins agents

Runners provide compute resources for builds and tests.

**Artifact**

Artifacts are **files produced by the pipeline** that can be used in later stages.

Examples include:

- Build binaries

- Docker images

- Test reports

- Deployment packages

Artifacts allow stages to share outputs.

**4. CI/CD Pipeline Diagram**

Example pipeline when a developer pushes code to GitHub.

Developer Push Code  
│  
▼  
GitHub Trigger  
│  
▼  
┌───────────────┐  
│ Build Stage │  
│ Install deps │  
│ Build App │  
└───────────────┘  
│  
▼  
┌───────────────┐  
│ Test Stage │  
│ Unit Tests │  
│ Integration │  
│ Tests │  
└───────────────┘  
│  
▼  
┌───────────────┐  
│ Docker Build │  
│ Build Image │  
│ Push to Repo │  
└───────────────┘  
│  
▼  
┌───────────────┐  
│ Deploy Stage │  
│ Deploy to │  
│ Staging │  
└───────────────┘

Pipeline Flow:

Developer → GitHub → CI Pipeline → Build → Test → Docker Image → Deploy to Staging.

**5. Exploring an Open Source Repository**

Repository Chosen: **FastAPI**

GitHub Repository:  
[[https://github.com/fastapi/fastapi]{.underline}](https://github.com/fastapi/fastapi)

Workflow Folder:

.github/workflows/

**Example Workflow File**

test.yml

**What Triggers It?**

The workflow is triggered by:

- Push events

- Pull requests

This ensures every change is tested before merging.

**How Many Jobs Does It Have?**

The workflow contains multiple jobs such as:

- Running tests

- Checking code formatting

- Linting the code

Each job runs independently using GitHub Actions runners.

**What Does It Do?**

The workflow mainly performs:

- Installing dependencies

- Running automated tests

- Checking code quality

- Ensuring the application works across different Python versions

This ensures high reliability before merging code into the main branch.

**Key Takeaways**

- CI/CD automates **build, testing, and deployment**

- CI ensures **code integration quality**

- Continuous Delivery ensures **code is always deployable**

- Continuous Deployment enables **fully automated releases**

- Pipelines reduce human errors and increase deployment frequency
