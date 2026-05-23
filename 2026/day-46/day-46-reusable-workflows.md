# Day 46 – Reusable Workflows & Composite Actions

## Overview

In large DevOps environments, teams avoid repeating the same CI/CD logic across multiple repositories. GitHub Actions provides **Reusable Workflows** and **Composite Actions** to promote reuse and maintain consistency.

Today I learned how to create reusable pipelines using **workflow_call**, how to call those workflows from other workflows, and how to build **custom composite actions** for reusable step logic.

---

# Task 1 – Understanding Reusable Workflows

    ## What is a Reusable Workflow?

    A **Reusable Workflow** is a GitHub Actions workflow that can be called by other workflows. Instead of rewriting CI/CD pipelines across repositories, teams define a standard workflow once and reuse it anywhere.

    Reusable workflows help with:

    * Standardizing CI/CD pipelines
    * Reducing duplicated configuration
    * Improving maintainability
    * Centralizing DevOps best practices


    ## What is `workflow_call`?

    `workflow_call` is a trigger that allows a workflow to be invoked by another workflow.

    Example:

    on:
    workflow_call:

    This means the workflow cannot run independently. It must be triggered by another workflow.

    ## Reusable Workflow vs Regular Action

    Reusable workflows are called at the **job level**, while regular actions are used inside **steps**.

    Reusable workflows can contain **multiple jobs**, whereas regular actions typically perform **single tasks** within a workflow.

    ---

    ## Where Must Reusable Workflows Live?

    Reusable workflows must be stored in:

    .github/workflows/


    Example:

    .github/workflows/reusable-build.yml


# Task 2 – Creating a Reusable Workflow

    File created:


    .github/workflows/reusable-build.yml


    ```yaml
    name: Reusable Build Workflow

    on:
    workflow_call:
        inputs:
        app_name:
            required: true
            type: string
        environment:
            required: true
            type: string
            default: staging
        secrets:
        docker_token:
            required: true

        outputs:
        build_version:
            description: "Generated build version"
            value: ${{ jobs.build.outputs.version }}

    jobs:
    build:
        runs-on: ubuntu-latest

        outputs:
        version: ${{ steps.set_version.outputs.version }}

        steps:
        - name: Checkout Code
            uses: actions/checkout@v4

        - name: Print Build Info
            run: |
            echo "Building ${{ inputs.app_name }} for ${{ inputs.environment }}"

        - name: Verify Docker Token
            run: |
            if [ -n "${{ secrets.docker_token }}" ]; then
                echo "Docker token is set: true"
            else
                echo "Docker token missing"
            fi

        - name: Generate Build Version
            id: set_version
            run: |
            VERSION="v1.0-${GITHUB_SHA::7}"
            echo "version=$VERSION" >> $GITHUB_OUTPUT

# Task 3 – Creating the Caller Workflow

    File created:

    ```
    .github/workflows/call-build.yml
    ```

    This workflow triggers on push to the **main branch** and calls the reusable workflow.

    ```yaml
    name: Call Reusable Build

    on:
    push:
        branches:
        - main

    jobs:
    build:
        uses: ./.github/workflows/reusable-build.yml
        with:
        app_name: "my-web-app"
        environment: "production"
        secrets:
        docker_token: ${{ secrets.DOCKER_TOKEN }}

    print-version:
        needs: build
        runs-on: ubuntu-latest

        steps:
        - name: Print Build Version
            run: echo "Build Version is ${{ needs.build.outputs.build_version }}"
    ```

    When this workflow runs, it triggers the reusable workflow and prints the generated version.

    ---

# Task 4 – Workflow Outputs

    The reusable workflow generates a build version using the short commit SHA.

    Example output:

    ```
    Build Version is v1.0-4a3b2c1
    ```

    This value is passed from the reusable workflow to the caller workflow using outputs.

    ---

# Task 5 – Creating a Composite Action

    Composite actions allow multiple steps to be packaged as a reusable action.

    Directory created:

    ```
    .github/actions/setup-and-greet/
    ```

    File:

    action.yml

    name: Setup and Greet
    description: Custom composite action

    inputs:
    name:
        description: Name to greet
        required: true

    language:
        description: Greeting language
        required: false
        default: en

    outputs:
    greeted:
        description: Greeting completed
        value: true

    runs:
    using: "composite"

    steps:
        - name: Print Greeting
        shell: bash
        run: |
            if [ "${{ inputs.language }}" == "en" ]; then
            echo "Hello ${{ inputs.name }}"
            elif [ "${{ inputs.language }}" == "es" ]; then
            echo "Hola ${{ inputs.name }}"
            else
            echo "Hi ${{ inputs.name }}"
            fi

        - name: Print Date and Runner
        shell: bash
        run: |
            echo "Date: $(date)"
            echo "Runner OS: $RUNNER_OS"
    


Workflow Using the Composite Action

File created:

.github/workflows/greet.yml
name: Test Composite Action

on:
  workflow_dispatch:

jobs:
  greet:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Run Custom Composite Action
        uses: ./.github/actions/setup-and-greet
        with:
          name: Axata
          language: en

This workflow runs the composite action and prints a greeting.



# Task 6 – Reusable Workflow vs Composite Action

| Feature                    | Reusable Workflow    | Composite Action         |
| -------------------------- | -------------------- | ------------------------ |
| Triggered by               | `workflow_call`      | `uses:` in workflow step |
| Can contain jobs           | Yes                  | No                       |
| Can contain multiple steps | Yes                  | Yes                      |
| Location                   | `.github/workflows/` | `.github/actions/`       |
| Accept secrets directly    | Yes                  | No                       |
| Best for                   | Full CI/CD pipelines | Reusable step logic      |


