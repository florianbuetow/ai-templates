# AGENTS.md

This file provides guidance to AI agents and AI-assisted development tools when working with code in this repository. This includes Claude Code, Cursor IDE, GitHub Copilot, Windsurf, and any other AI coding assistants.

## Repository Overview

This repository contains Copier templates for AI-agent-friendly project scaffolding across multiple languages: Python, Java, Go, and Elixir.

## Git Commit Guidelines

**IMPORTANT:** When creating git commits in this repository:
- NEVER include AI attribution in commit messages
- NEVER add "Generated with [AI tool name]" or similar phrases
- NEVER add "Co-Authored-By: [AI name]" or similar attribution
- NEVER run `git add -A` or `git add .` - always stage files explicitly
- Keep commit messages professional and focused on the changes made
- Commit messages should describe what changed and why, without mentioning AI assistance
- ALWAYS run `git push` after creating a commit to push changes to the remote repository

## Current Contents

- `project-setup/setup-project-python.md` - A comprehensive guide for bootstrapping Python projects using AI agents

### The Python CLI Template (`blueprints/python-cli-base`)

- Python 3.12+ with uv package management
- Project structure: src/, scripts/, data/
- Validation: ruff, mypy, pyright, bandit, semgrep, deptry, codespell, pip-audit, pytestarch, pytest
- Conventions: Justfile workflow, strict directory organization, no pip or python directly

### The Java CLI Template (`blueprints/java-cli-base`)

- Java 21+ with Gradle Kotlin DSL
- Validation: Spotless, Checkstyle, Error Prone, SpotBugs, semgrep, codespell, OWASP, ArchUnit, JUnit 5

### The Go CLI Template (`blueprints/go-cli-base`)

- Go 1.23+ with Go modules
- Project structure: cmd/, internal/, scripts/, data/
- Validation: gofumpt, go vet, staticcheck, golangci-lint, gosec, semgrep, codespell, govulncheck, go test
- Conventions: Justfile workflow, strict error handling, no init functions, no bare returns in error funcs

### The Elixir OTP Template (`blueprints/elixir-otp-base`)

- Elixir 1.17+ with Mix build tool
- Validation: mix format, Credo, Dialyxir, semgrep, codespell, mix audit, ExUnit

All templates emphasize creating immediately runnable projects with no placeholders, comprehensive CI pipelines, and AGENTS.md/CLAUDE.md files for AI agent guidance.
