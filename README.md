# AI Templates

Copier template for Python CLI applications designed to create an AI-agent-friendly codebase with comprehensive validation checks that guide AI assistants toward writing better, more maintainable code.

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

## Features: Guiding AI Agents to Better Code

This template creates a development environment that actively guides AI assistants through:

### Validation Guardrails
- **11-step CI pipeline**: Auto-format → style → typecheck → security → tests
  *Catches issues immediately and teaches patterns through fast feedback*
- **Custom semgrep rules**: Ban default values, type suppressions, and fallback patterns
  *Forces explicit configuration and proper error handling*
- **Pre-commit hooks**: Auto-format and validate before every commit
  *Prevents bad code from entering the repository*

### AI-Specific Guidance
- **Comprehensive AGENTS.md**: Development rules specifically written for AI assistants
  *Teaches project conventions, forbidden patterns, and testing requirements*
- **Explicit validation tools**: ruff, mypy, pyright, bandit, semgrep, deptry, codespell, pip-audit
  *Each tool provides specific feedback to guide improvements*

### Developer Experience
- **Just task runner**: Simple commands for all development tasks (`just ci`, `just test`)
  *AI agents can easily run validation and get immediate feedback*
- **Python 3.12+** with **uv** package management
  *Modern tooling with clear conventions*

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

**Method 1: Using Copier directly (recommended)**

```bash
copier copy /path/to/ai-templates/blueprints/python-cli-base my-awesome-project
cd my-awesome-project
just init
just run
```

**Method 2: Using the just command**

From the ai-templates directory:

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
