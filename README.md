# AI Templates

A collection of templates and prompts for AI-assisted development with Claude Code and other AI assistants.

## Repository Structure

```
ai-templates/
├── project-setup/                              # Project bootstrapping templates
│   ├── setup-project-python-claude.md         # Python project setup guide with uv
│   ├── setup-project-python-claude.sh         # Automated project creation script
│   ├── setup_aliases.sh                       # Automated alias installation script
│   └── README.md                              # Detailed documentation
├── justfile                                    # Quick setup commands
├── CLAUDE.md                                   # Guidance for Claude Code when working in this repo
├── README.md                                   # This file
└── .gitignore                                  # Git ignore patterns (Python, macOS)
```

## Contents

### Project Setup Templates

- **[Python Project Setup](project-setup/setup-project-python-claude.md)** - Comprehensive guide for bootstrapping Python projects with Claude Code
  - Uses `uv` for package management
  - Enforces Python 3.12+
  - Justfile-based workflow
  - Strict project structure conventions

## Prerequisites

Before installation, ensure you have the following installed:
- **git** - Version control system
- **python** - Python 3.12 or higher
- **uv** - Python package manager ([installation guide](https://docs.astral.sh/uv/getting-started/installation/))
- **just** - Command runner ([installation guide](https://github.com/casey/just#installation))
- **claude CLI** - Claude Code ([installation guide](https://claude.com/claude-code))

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
2. Read the template file (e.g., `setup-project-python-claude.md`)
3. Copy the provided prompt
4. Paste it into Claude Code with your specific requirements
5. Follow the generated project instructions

## Usage

After installation, creating a new Python project is as simple as:

```bash
newpy my-awesome-project
cd my-awesome-project
just init
just run
```

To update your templates to the latest version:

```bash
update-templates

# Or, if you're in the ai-templates directory:
just update
```

## Contributing

When adding new templates, place them in appropriate directories and maintain consistency with existing template structures.
