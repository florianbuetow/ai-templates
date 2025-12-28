# AI Templates

Production-ready Copier template for Python CLI applications with comprehensive validation infrastructure.

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
├── code-validation-blueprint-guide.md          # Validation infrastructure guide
├── justfile                                    # Quick setup commands
├── AGENTS.md                                   # Guidance for AI agents
├── CLAUDE.md                                   # Redirects to AGENTS.md
├── README.md                                   # This file
└── .gitignore                                  # Git ignore patterns
```

## Features

- **Full validation infrastructure**: ruff, mypy, pyright, bandit, semgrep, deptry, codespell, pip-audit
- **11-step CI pipeline**: auto-format → style check → type check → security → tests
- **Pre-commit hooks**: Automatically format and validate code before commits
- **Custom semgrep rules**: Enforce explicit configuration, ban default values and type suppressions
- **AI-ready**: Comprehensive AGENTS.md with development guidelines for AI assistants
- **Python 3.12+** with **uv** package management
- **Just task runner**: Simple commands for all development tasks
- **Git worktree workflow**: Support for parallel development branches

See [code-validation-blueprint-guide.md](code-validation-blueprint-guide.md) for detailed tool configurations and semgrep rules.

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

### Creating a New Python CLI Project

Using Copier (recommended):

```bash
copier copy blueprints/python-cli-base my-awesome-project
cd my-awesome-project
just init
just run
```

Or using the convenience script:

```bash
cd ai-templates
just create python-cli-base my-project
```

### Development Commands

From the ai-templates directory:

```bash
just test           # Test the template (generate, init, run, ci, destroy)
just update         # Update to latest version (git pull)
```

### What You Get

Projects created from this template include:

- **Full CI/CD pipeline** with 11 validation steps (format, style, typecheck, security, etc.)
- **Pre-commit hooks** that auto-format and validate code before commits
- **Comprehensive AGENTS.md** with development rules for AI assistants
- **Custom semgrep rules** to enforce code quality (no defaults, no type suppressions)
- **Just recipes** for all common tasks (init, run, test, ci, destroy)
- **Complete test infrastructure** with pytest, coverage, and quality gates

## Contributing

Contributions are welcome! When adding features or fixes:

1. Add tests in `tests/` directory
2. Run `just test` to verify the template works correctly
3. Update documentation as needed
4. Follow the patterns established in the existing template
