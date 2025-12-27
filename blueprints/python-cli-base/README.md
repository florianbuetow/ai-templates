# Python CLI Base Template

Production-ready Copier template for Python CLI applications with full validation infrastructure.

## Features

- **Python 3.12+** with uv package management
- **Just task runner** for all commands
- **Full validation infrastructure**:
  - ruff (linting + formatting)
  - mypy + pyright (type checking)
  - bandit (security)
  - deptry (dependency hygiene)
  - semgrep (custom static analysis)
  - pytest with coverage
  - codespell (spell checking)
  - pip-audit (vulnerability scanning)
- **Pre-commit hooks** with CI checks
- **Comprehensive AGENTS.md** for AI-assisted development
- **Git worktree workflow** support

## Template Structure

```
blueprints/python-cli-base/
├── copier.yml                          # Template configuration
├── README.md                           # This file
└── template/                           # Template files
    ├── .gitignore.template
    ├── .python-version.template
    ├── pyproject.toml.template
    ├── pyrightconfig.json.template
    ├── .pre-commit-config.yaml.template
    ├── justfile.template
    ├── README.md.template
    ├── AGENTS.md.template
    ├── CLAUDE.md -> AGENTS.md         # Symlink (created via _tasks)
    ├── src/
    │   ├── {{package_name}}/
    │   │   └── __init__.py
    │   └── main.py.template
    ├── tests/
    │   └── __init__.py
    ├── scripts/
    ├── prompts/
    ├── data/
    │   ├── input/
    │   └── output/
    └── config/
        ├── semgrep/
        │   ├── no-default-values.yml
        │   ├── no-sneaky-fallbacks.yml
        │   ├── no_type_suppression.yml
        │   ├── no-noqa.yml
        │   └── python-constants.yml
        └── codespell/
            └── ignore.txt
```

## Usage

### Via setup-project.sh

```bash
cd /path/to/ai-templates
./project-setup/setup-project.sh --name my-project
```

This will:
1. Create git bare repository + main worktree
2. Run Copier to generate project
3. Run `just init` to set up environment
4. Run `just run` to test
5. Run `just destroy` to clean up
6. Create initial commit

### Via setup-project-python-claude.sh (newpy alias)

```bash
newpy my-project
```

### Direct Copier usage

```bash
copier copy blueprints/python-cli-base my-project
cd my-project
just init
just run
```

## Template Questions

The template will ask:

- **project_name**: Project name (e.g., my-cli-tool)
- **package_name**: Python package name (e.g., my_cli_tool)
- **project_description**: Short description
- **python_version**: Minimum Python version (3.12 or 3.13)
- **author_name**: Author name
- **author_email**: Author email
- **coverage_threshold**: Code coverage threshold (0-100, default 80)

## Generated Project Features

Projects created from this template include:

- **Strict Python execution**: Only via `uv run` (never `python` directly)
- **Complete validation suite**: All tools configured in pyproject.toml
- **Just recipes**: init, run, destroy, code-*, test, ci, ci-quiet
- **Pre-commit hooks**: Runs `just ci-quiet` on commit
- **AI agent rules**: AGENTS.md with strict development guidelines
- **Git commit rules**: No AI attribution, explicit file staging
- **Semgrep rules**: Enforce explicit configuration, no defaults, no type suppression
- **Directory structure**: src/, tests/, scripts/, prompts/, data/

## Requirements

- **Python 3.12+**
- **uv** - Python package manager
- **just** - Command runner
- **copier** - Template engine
- **git** - Version control

## Testing the Template

To verify the template generates correctly:

```bash
cd /path/to/ai-templates
just test
```

This will:
1. Generate a test project in a temp directory
2. Verify all files are created
3. Verify CLAUDE.md symlink is correct
4. Run `just init`, `just run`, `just destroy` in the generated project
5. Clean up temp directory

## Updating Generated Projects

Projects can be updated when the template changes:

```bash
cd my-project/main
copier update
```

## Development

To modify this template:

1. Edit files in `template/` directory
2. Test with: `just test` (from repository root)
3. Verify generated project works
4. Commit changes

## Sources

Based on:
- [mjun0812/python-copier-template](https://github.com/mjun0812/python-copier-template)
- ai-templates/project-setup/setup-project-python.md
- ai-templates/code-validation-blueprint-guide.md
