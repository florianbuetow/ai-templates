# AI Templates

Copier template for Python CLI applications designed to create an AI-agent-friendly codebase with comprehensive validation checks that guide AI assistants toward writing better, more maintainable code.

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
- **Validation tools**: ruff, mypy, pyright, bandit, semgrep, deptry, codespell, pip-audit
- **Python 3.12+** with uv package management
- **Just task runner** with recipes for common tasks (init, run, test, ci, destroy)
- **Test infrastructure** with pytest, coverage thresholds, and quality gates

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

### Creating a New Project

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

## Development

### Testing the Template

From the ai-templates directory:

```bash
just test
```

This will:
1. Generate a test project from the template
2. Verify all files are created correctly
3. Run `just init`, `just run`, `just ci`, `just ci-quiet`, and `just destroy`
4. Assert each step completes successfully
5. Clean up the test project

### Updating

```bash
cd ai-templates
just update  # git pull
```

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

## Contributing

Contributions are welcome! When adding features or fixes:

1. Add tests in `tests/` directory
2. Run `just test` to verify the template works correctly
3. Update documentation as needed
4. Follow the patterns established in the existing template
