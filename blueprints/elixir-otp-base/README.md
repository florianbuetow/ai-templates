# Elixir OTP Base Template

Production-ready Copier template for Elixir OTP applications with full validation infrastructure.

## Features

- **Elixir 1.17+** with Mix build tool
- **Just task runner** for all commands
- **Full validation infrastructure**:
  - mix format (code formatting)
  - credo (linting, strict mode)
  - dialyxir (Dialyzer type checking)
  - sobelow (security scanning)
  - mix_audit (dependency vulnerability scanning)
  - ExUnit with coverage
  - codespell (spell checking)
- **Git hooks** via git_hooks hex package
- **Comprehensive AGENTS.md** for AI-assisted development

## Usage

### Via just create

```bash
cd /path/to/ai-templates
just create elixir-otp-base ~/projects/my-elixir-app
```

### Direct Copier usage

```bash
copier copy blueprints/elixir-otp-base my-elixir-app
cd my-elixir-app
just init
just run
```

## Template Questions

The template will ask:

- **project_name**: Project name (e.g., my-otp-app)
- **app_name**: Elixir application name (e.g., my_otp_app)
- **module_name**: Module name (e.g., MyOtpApp)
- **project_description**: Short description
- **elixir_version**: Minimum Elixir version (1.17 or 1.18)
- **author_name**: Author name
- **coverage_threshold**: Code coverage threshold (0-100, default 80)

## Requirements

- **Elixir 1.17+**
- **Erlang/OTP 26+**
- **just** - Command runner
- **copier** - Template engine
- **git** - Version control
- **codespell** - Spell checker (optional)
