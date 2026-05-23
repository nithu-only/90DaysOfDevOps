Day 38 – YAML Basics
Overview

Today I focused on learning YAML (YAML Ain’t Markup Language) — the configuration language used by most DevOps tools like GitHub Actions, Kubernetes, Docker Compose, Ansible, and CI/CD pipelines.

The goal was to understand YAML syntax, create YAML files manually, and validate them.

Task 1 – Key Value Pairs

Created a file person.yaml describing myself.

name: Axata Darji
role: DevOps Learner
experience_years: 7.5
learning: true
Notes

YAML uses key: value pairs

Booleans are written as true / false

YAML does not use tabs — only spaces

Task 2 – Lists

Added lists for tools and hobbies.

name: Axata Darji
role: DevOps Learner
experience_years: 7.5
learning: true

tools:
  - docker
  - kubernetes
  - terraform
  - aws
  - github-actions

hobbies: [reading, travelling, cooking]
Two ways to write lists in YAML

Block format

tools:
  - docker
  - kubernetes

Inline format

tools: [docker, kubernetes]
Task 3 – Nested Objects

Created server.yaml

server:
  name: web-server
  ip: 192.168.1.10
  port: 8080

database:
  host: db.local
  name: production_db
  credentials:
    user: admin
    password: secret123
Key Concept

YAML supports nested objects using indentation.

database
 └── credentials
      ├── user
      └── password
Experiment

When I replaced spaces with tabs, the validator returned:

Error: Tabs are not allowed in YAML indentation

YAML strictly requires spaces only.

Task 4 – Multi-line Strings

Added startup scripts using YAML block styles.

startup_script_literal: |
  echo "Starting server..."
  npm install
  npm start

startup_script_folded: >
  echo "Starting server..."
  npm install
  npm start
Difference Between | and >
Symbol	Behavior
`	`
>	Folds multiple lines into a single line

Example:

| output

echo "Starting server..."
npm install
npm start

> output

echo "Starting server..." npm install npm start
When to Use

Use | for:

scripts

configuration files

multiline commands

Use > for:

long text paragraphs

descriptions

Task 5 – YAML Validation

I validated my YAML using yamllint.

Example command:

yamllint person.yaml
yamllint server.yaml
Intentional Error

Broken indentation:

server:
 name: web-server
   ip: 192.168.1.10

Error returned:

syntax error: mapping values are not allowed here

After fixing indentation, validation succeeded.

Task 6 – Spot the Difference
Block 1 (Correct)
name: devops
tools:
  - docker
  - kubernetes
Block 2 (Broken)
name: devops
tools:
- docker
  - kubernetes
What is Wrong?

The list indentation is inconsistent.

Correct indentation requires the list items to align properly under tools.

Correct version:

tools:
  - docker
  - kubernetes

What I Learned (Key Takeaways)
1️⃣ Indentation is Critical

YAML structure depends entirely on spaces. Even one wrong indentation breaks the file.

2️⃣ YAML Uses Spaces Only

Tabs are not allowed in YAML files.

3️⃣ YAML Supports Clean Data Structures

YAML easily represents:

lists
nested objects
multiline strings

This is why it's widely used in CI/CD pipelines, Kubernetes manifests, and Docker Compose files.