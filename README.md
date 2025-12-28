# AI Templates

A collection of templates and prompts for AI-assisted development with Claude Code and other AI assistants.

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
├── project-setup/                              # Legacy project bootstrapping
│   ├── setup-project-python.md                # Python project setup guide
│   ├── setup-project.sh                       # General project creation script
│   ├── setup-project-python-claude.sh         # Claude-specific automation
│   ├── setup_aliases.sh                       # Alias installation script
│   └── README.md                              # Detailed documentation
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

## Contents

### 1. Blueprints (Copier Templates)

#### Python CLI Base Template
- **Location:** `blueprints/python-cli-base/`
- **Description:** Production-ready Copier template for Python CLI applications
- **Features:**
  - Full validation infrastructure (ruff, mypy, pyright, bandit, semgrep, etc.)
  - Pre-configured custom semgrep rules (no defaults, no type suppression, etc.)
  - Pre-commit hooks with CI checks
  - Comprehensive AGENTS.md for AI-assisted development
  - Git worktree workflow support
  - Python 3.12+ with uv package management
  - Just task runner for all commands

### 2. Project Setup Templates (Legacy)

- **[Python Project Setup](project-setup/setup-project-python.md)** - Comprehensive guide for bootstrapping Python projects using AI agents
  - Uses `uv` for package management
  - Enforces Python 3.12+
  - Justfile-based workflow
  - Strict project structure conventions

### 3. Validation Infrastructure

- **[Code Validation Blueprint](code-validation-blueprint-guide.md)** - Complete validation infrastructure reference
  - Make/Just targets for all validation tools
  - Tool configurations (ruff, mypy, pyright, bandit, deptry, semgrep, etc.)
  - Custom semgrep rules with examples
  - Pre-commit hook setup

## Prerequisites

Before installation, ensure you have the following installed:
- **git** - Version control system
- **python** - Python 3.12 or higher
- **uv** - Python package manager ([installation guide](https://docs.astral.sh/uv/getting-started/installation/))
- **just** - Command runner ([installation guide](https://github.com/casey/just#installation))
- **copier** - Template engine ([installation guide](https://copier.readthedocs.io/))
- **claude CLI** - Claude Code (optional, for Claude-specific automation) ([installation guide](https://claude.com/claude-code))

The `just init` command will check for these prerequisites automatically.

## Installation

### Quick Setup (Recommended)

1. Clone this repository:
```bash
# Option 1: Clone to the standard location (recommended)
mkdir -p ~/scripts
cd ~/scripts
git clone https://github.com/florianbuetow/ai-templates.git
cd ai-templates

# Option 2: Clone anywhere (setup will ensure it's in the right place)
git clone https://github.com/florianbuetow/ai-templates.git
cd ai-templates
```

2. Run the setup:
```bash
just init
```

This will:
- Check prerequisites (git, python, uv, just, claude CLI)
- Ensure the repository is at `~/scripts/ai-templates` (clones or updates as needed)
- Set up shell aliases in your RC file

3. Reload your shell:
```bash
source ~/.zshrc  # or ~/.bashrc for bash
```

You'll now have two aliases:
- `newpy <project-name>` - Create a new Python project
- `update-templates` - Update templates to the latest version

### Manual Usage

If you prefer not to install aliases, you can use the templates directly:

1. Navigate to the template directory
2. Read the template file (e.g., `setup-project-python.md`)
3. Copy the provided prompt
4. Paste it into Claude Code with your specific requirements
5. Follow the generated project instructions

## Usage

### Creating Projects from Blueprints

#### Using Copier Directly (Recommended)

```bash
# Create a new Python CLI project
copier copy blueprints/python-cli-base my-awesome-project
cd my-awesome-project
just init
just run
```

#### Using the setup-project.sh Script

```bash
# From anywhere
/path/to/ai-templates/project-setup/setup-project.sh --template python-cli-base --target my-project

# Or use the just command from the ai-templates directory
cd ai-templates
just create python-cli-base my-project
```

#### Using the newpy Alias (Legacy)

After installation, you can also use the legacy method:

```bash
newpy my-awesome-project
cd my-awesome-project
just init
just run
```

### Available Commands (from ai-templates directory)

```bash
just init           # Install templates and set up aliases
just update         # Update templates to latest version
just create <template> <target-dir>  # Create project from template
just test           # Run template integration tests
```

### Updating Templates

```bash
update-templates

# Or, if you're in the ai-templates directory:
just update
```

### Testing

To verify the template works correctly:

```bash
cd ai-templates
just test
```

This will:
1. Generate a test project from the template
2. Verify all files are created correctly
3. Run `just init`, `just run`, `just ci`, `just ci-quiet`, and `just destroy`
4. Assert each step completes successfully
5. Clean up the test project

## Contributing

When adding new templates:
1. Place them in `blueprints/` directory
2. Use Copier template format with `copier.yml`
3. Add comprehensive `README.md` to the template
4. Update this main `README.md` to document the new template
5. Add tests in `tests/` directory
6. Maintain consistency with existing template structures
