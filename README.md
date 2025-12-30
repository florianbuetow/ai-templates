# AI Friendly Project Templates

Copier template for Python CLI applications designed to create an AI-agent-friendly codebase with comprehensive validation checks that provide feedback to the AI to write better, more maintainable code and suppress typical antipatterns in generated code.

## Quick Start

```bash
copier copy https://github.com/florianbuetow/ai-templates/blueprints/python-cli-base my-project
cd my-project
just init
just run
```

## Features

- **11-step CI pipeline**: init → format → style → typecheck → security → deptry → spell → semgrep → audit → test → lspchecks
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
| **pytest** | Testing framework | Unit testing with fixtures, parameterization, and coverage |

See [code-validation-blueprint-guide.md](docs/code-validation-blueprint-guide.md) for detailed tool configurations and semgrep rules.

## Prerequisites

- **git** - Version control system
- **python** - Python 3.12 or higher
- **uv** - Python package manager ([installation guide](https://docs.astral.sh/uv/getting-started/installation/))
- **just** - Command runner ([installation guide](https://github.com/casey/just#installation))
- **copier** - Template engine ([installation guide](https://copier.readthedocs.io/))

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
1. Template name (e.g., `python-cli-base`)
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
│   └── python-cli-base/                       # Production-ready Python CLI template
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
