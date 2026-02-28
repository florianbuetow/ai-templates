# Go CLI Base Template

Production-ready Copier template for Go CLI applications with full validation infrastructure.

## Features

- **Go 1.23+** with standard Go modules
- **Just task runner** for all commands
- **Full validation infrastructure**:
  - golangci-lint (linting + static analysis)
  - go vet (static analysis)
  - gofumpt (formatting)
  - govulncheck (vulnerability scanning)
  - go test with coverage
- **Pre-commit hooks** with CI checks
- **Comprehensive AGENTS.md** for AI-assisted development
- **Git worktree workflow** support

## Template Structure

```
blueprints/go-cli-base/
├── copier.yml                          # Template configuration
├── README.md                           # This file
└── template/                           # Template files
    ├── go.mod.template
    ├── cmd/
    │   └── main.go.template
    ├── internal/
    │   └── app/
    │       ├── app.go.template
    │       └── app_test.go.template
    ├── scripts/
    ├── data/
    │   ├── input/
    │   └── output/
```

## Usage

### Via setup-project.sh

```bash
cd /path/to/ai-templates
./project-setup/setup-project.sh --name my-project --template go-cli-base
```

This will:
1. Create git bare repository + main worktree
2. Run Copier to generate project
3. Run `just init` to set up environment
4. Run `just run` to test
5. Run `just destroy` to clean up
6. Create initial commit

### Direct Copier usage

```bash
copier copy blueprints/go-cli-base my-project
cd my-project
just init
just run
```

## Template Questions

The template will ask:

- **project_name**: Project name (e.g., my-cli-tool)
- **module_path**: Go module path (e.g., github.com/user/project)
- **project_description**: Short description
- **go_version**: Minimum Go version (1.23 or 1.24)
- **author_name**: Author name
- **author_email**: Author email
- **coverage_threshold**: Code coverage threshold (0-100, default 80)

## Generated Project Features

Projects created from this template include:

- **Standard Go project layout**: cmd/, internal/, scripts/, data/
- **Go modules**: Dependency management via go.mod
- **Complete validation suite**: Linting, formatting, vetting, vulnerability scanning
- **Just recipes**: init, run, destroy, code-*, test, ci, ci-quiet
- **Pre-commit hooks**: Runs `just ci-quiet` on commit
- **AI agent rules**: AGENTS.md with strict development guidelines
- **Git commit rules**: No AI attribution, explicit file staging
- **Directory structure**: cmd/, internal/, scripts/, data/

## Requirements

- **Go 1.23+**
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
- [golang-standards/project-layout](https://github.com/golang-standards/project-layout)
- ai-templates/blueprints/python-cli-base
