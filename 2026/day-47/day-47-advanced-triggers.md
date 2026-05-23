# Day 47 – Advanced Triggers in GitHub Actions

Today I explored advanced event-driven automation features in GitHub Actions including PR lifecycle events, cron scheduling, path filters, workflow chaining, and external triggers.

## PR Lifecycle Events

    The workflow triggers on multiple pull request lifecycle events:

    - opened
    - synchronize
    - reopened
    - closed

    It prints PR metadata including:

    - event type
    - PR title
    - author
    - source branch
    - target branch

    It also runs a step only when the PR is merged.

## PR Validation Checks

    Implemented real-world PR validation rules:

    - Reject files larger than 1MB
    - Enforce branch naming convention
    - Warn if PR description is empty

    These checks help maintain repository quality.

## Scheduled Workflows

    Two scheduled tasks were created:

    Every Monday at 2:30 AM UTC

    30 2 * * 1


    Every 6 hours

    0 */6 * * *


    Cron expressions:

    Every weekday at 9 AM IST

    30 3 * * 1-5


    First day of every month at midnight

    0 0 1 * *


    Scheduled workflows may be delayed because GitHub deprioritizes cron jobs on inactive repositories.

## Smart Path Filters

    Used `paths` to trigger workflows only when code changes.

    Used `paths-ignore` to skip workflows when only documentation changes.

## Workflow Chaining

    Used `workflow_run` to trigger deployment only after the test workflow completes successfully.

    workflow_run allows workflows to depend on other workflows.

    workflow_call is different — it allows one workflow to directly reuse another workflow as a function.

## External Triggers

    Used `repository_dispatch` to trigger workflows from external systems.

    Example use cases:

    - monitoring alerts
    - chat bots
    - deployment dashboards


All workflow code can be found in Repository :  https://github.com/AxataDarji/github-actions-practice