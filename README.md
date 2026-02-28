# AI Friendly Project Templates

![Made with AI](https://img.shields.io/badge/Made%20with-AI-333333?labelColor=f00) ![Verified by Humans](https://img.shields.io/badge/Verified%20by-Humans-333333?labelColor=brightgreen)

Copier templates for Python CLI and Elixir OTP applications designed to create AI-agent-friendly codebases with comprehensive validation checks that provide feedback to the AI to write better, more maintainable code and suppress typical antipatterns in generated code.

## Quick Start

```bash
copier copy https://github.com/florianbuetow/ai-templates/blueprints/python-cli-base my-project
cd my-project
just init
just run
```

**Elixir OTP:**

```bash
copier copy https://github.com/florianbuetow/ai-templates/blueprints/elixir-otp-base my-elixir-project
cd my-elixir-project
just init
just run
```

## Features

- **12-step CI pipeline**: init → format → style → typecheck → security → deptry → spell → semgrep → audit → test → architecture → lspchecks
- **Pre-commit hooks** run full CI validation automatically before each commit
- **Custom semgrep rules** ban default values, type suppressions, and sneaky fallback patterns
- **AGENTS.md** provides AI assistants with project conventions and development rules
- **Python 3.12+** with uv package management
- **Just task runner** with recipes for common tasks (init, run, test, ci, destroy)
- **Test infrastructure** with pytest, coverage thresholds, and quality gates

### Validation Tools

| Tool | Purpose | Why It's Used |
|------|---------|---------------|
| **ruff** | Linting and formatting | Fast Python linter and formatter - replaces flake8, isort, and black |
| **mypy** | Type checking | Static type checker for gradual typing - catches type errors before runtime |
| **pyright** | Strict type checking | Microsoft's LSP-based type checker - stricter than mypy, catches more edge cases |
| **bandit** | Security scanning | Finds common security issues in Python code (SQL injection, hardcoded passwords, etc.) |
| **semgrep** | Custom static analysis | Pattern-based code scanning - enforces project-specific rules |
| **deptry** | Dependency hygiene | Finds unused dependencies and missing imports |
| **codespell** | Spell checking | Catches typos in code, comments, and documentation |
| **pip-audit** | Vulnerability scanning | Scans dependencies for known security vulnerabilities |
| **pytestarch** | Architecture constraints | Enforces import boundaries between layers - prevents architectural erosion |
| **pytest** | Testing framework | Unit testing with fixtures, parameterization, and coverage |

See [code-validation-blueprint-guide.md](docs/code-validation-blueprint-guide.md) for detailed tool configurations and semgrep rules.

## Highly Recommended Companion Tools

These two tools complement AI Templates and are strongly recommended for any AI-assisted development workflow.

### [Guard](https://github.com/florianbuetow/guard) — Protect Files from AI Modifications

When AI agents work on your codebase, they sometimes modify unrelated files in an attempt to "fix" cascading issues. Guard lets you lock down file permissions so that the AI simply cannot touch files you want left alone. Toggle protection on individual files, collections, or use interactive mode for a fast workflow.

Use Guard alongside AI Templates to keep your project structure, configuration files, and critical modules safe while the AI works on the parts you want changed.

### [Claude Code Plugins](https://github.com/florianbuetow/claude-code) — Code Quality and Project Planning Skills

A collection of three Claude Code plugins that bring automated design analysis and specification writing into your workflow:

- **SOLID Principles** — Audit any class or module against all five SOLID principles (SRP, OCP, LSP, ISP, DIP) with severity-rated findings and concrete refactoring suggestions.
- **Beyond SOLID Principles** — Architecture-level analysis covering ten principles (Separation of Concerns, DRY, Law of Demeter, Loose Coupling, KISS, YAGNI, and more) for catching structural rot across module and service boundaries.
- **Spec Writer** — Guided specification writing that produces five layered documents (Vision, Business Requirements, Software Requirements, Architecture, and Test Verification) through an interactive interview process.

Use these plugins after scaffolding a project with AI Templates to maintain code quality as the codebase grows and to plan new features with proper specifications before writing code.

## Prerequisites

- **git** - Version control system
- **python** - Python 3.12 or higher
- **uv** - Python package manager ([installation guide](https://docs.astral.sh/uv/getting-started/installation/))
- **just** - Command runner ([installation guide](https://github.com/casey/just#installation))
- **copier** - Template engine ([installation guide](https://copier.readthedocs.io/))
- **elixir** - Elixir 1.17+ (for Elixir templates)
- **erlang** - Erlang/OTP 26+ (for Elixir templates)

## Installation

Clone this repository:

```bash
git clone https://github.com/florianbuetow/ai-templates.git
cd ai-templates
```

## Usage

### Creating a New Project

**Method 1: Using the just command (recommended)**

```bash
cd ai-templates
just create python-cli-base ~/projects/my-awesome-project
cd ~/projects/my-awesome-project
just init
just run
```

The `just create` command takes two arguments:
1. Template name (e.g., `python-cli-base` or `elixir-otp-base`)
2. Target directory (absolute or relative path where the project will be created)

**Method 2: Using Copier directly**

```bash
copier copy /path/to/ai-templates/blueprints/python-cli-base my-awesome-project
cd my-awesome-project
just init
just run
```

## Development

### Run Tests

```bash
cd ai-templates
just test
```

This will:
1. Generate a test project from each available template
2. Verify all files are created correctly
3. Run `just init`, `just run`, `just ci`, `just ci-quiet`, and `just destroy`
4. Assert each step completes successfully
5. Clean up the test project

### Updating the Template Repository

To get the latest template features, configurations, and fixes:

```bash
cd ai-templates
just update
```

This updates the ai-templates repository itself (via `git pull`). Existing projects created from the template are not affected.

## Repository Structure

```
ai-templates/
├── blueprints/                                 # Copier-based project templates
│   ├── python-cli-base/                       # Production-ready Python CLI template
│   └── elixir-otp-base/                       # Production-ready Elixir OTP template
│       ├── copier.yml                         # Template configuration
│       ├── README.md                          # Template documentation
│       └── template/                          # Template files
│           ├── .semgrepignore.template        # Semgrep ignore patterns
│           ├── .gitignore.template            # Git ignore patterns
│           ├── justfile.template              # Just command runner config
│           ├── pyproject.toml.template        # Python project config
│           ├── AGENTS.md.template             # AI agent guidelines
│           ├── config/                        # Validation configurations
│           │   ├── semgrep/                   # Custom semgrep rules
│           │   └── codespell/                 # Spell check config
│           ├── src/                           # Source code directory
│           └── tests/                         # Test directory
├── tests/                                      # Repository test suite
│   └── test-template.sh                       # Template integration tests
├── config/                                     # Shared validation configs
│   ├── semgrep/                               # Custom semgrep rules
│   └── codespell/                             # Spell check config
├── docs/                                       # Documentation
│   └── code-validation-blueprint-guide.md     # Validation infrastructure guide
├── justfile                                    # Quick setup commands
├── AGENTS.md                                   # Guidance for AI agents
├── CLAUDE.md                                   # Redirects to AGENTS.md
├── README.md                                   # This file
└── .gitignore                                  # Git ignore patterns
```

## Contributing

Contributions are welcome! When adding features or fixes:

1. Add tests in `tests/` directory
2. Run `just test` to verify the template works correctly
3. Update documentation as needed
4. Follow the patterns established in the existing template
