# AGENTS.md

This file provides guidance to AI agents and AI-assisted development tools when working with code in this repository. This includes Claude Code, Cursor IDE, GitHub Copilot, Windsurf, and any other AI coding assistants.

## Repository Overview

This repository contains templates for working with AI. Currently it has one project setup template for Python projects.

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

### The Python Setup Template

This file contains:
- A complete prompt for creating Python projects with specific requirements
- Instructions on project structure (src/, scripts/, data/)
- Requirements for using `uv` exclusively (never pip or python directly)
- A template for what should go in AGENTS.md and CLAUDE.md files for generated projects
- Conventions: Python 3.12+, Justfile workflow, strict directory organization

The template emphasizes creating immediately runnable projects with no placeholders, explicit forbidden patterns (like using `pip install`), and testing after every change.
