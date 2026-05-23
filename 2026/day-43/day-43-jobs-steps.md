# Day 43 – Jobs, Steps, Env Vars & Conditionals

## 1. Multi Job Workflow

    Example:

    ```yaml
    jobs:
    build:
        runs-on: ubuntu-latest

    test:
        needs: build

    deploy:
        needs: test

    This creates a dependency chain:

    build → test → deploy

    needs: ensures that a job only runs after another job finishes successfully.

## 2. Environment Variables

GitHub Actions supports environment variables at multiple levels.

Workflow level:

env:
  APP_NAME: myapp

Job level:

env:
  ENVIRONMENT: staging

Step level:

env:
  VERSION: 1.0.0

Variables can be accessed in steps using $VARIABLE_NAME.

## 3. GitHub Context Variables

GitHub provides built-in metadata for workflows.

Examples:

${{ github.sha }}
${{ github.actor }}

These help identify who triggered the pipeline and which commit is running.

4. Job Outputs

Outputs allow passing data from one job to another.

Set output:

echo "date=$(date)" >> $GITHUB_OUTPUT

Read output:

${{ needs.generate-date.outputs.today }}

This is useful for passing generated data like build artifacts, version numbers, or timestamps.

5. Conditionals

Conditionals control when jobs or steps run.

Example:

Run only on main branch:

if: github.ref == 'refs/heads/main'

Run if previous step failed:

if: failure()

Run job only on push events:

if: github.event_name == 'push'
6. continue-on-error
continue-on-error: true

This allows a step to fail without stopping the entire workflow.