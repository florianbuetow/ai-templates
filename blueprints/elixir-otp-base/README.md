# Elixir OTP Base Template

Production-ready Copier template for Elixir OTP applications with full validation infrastructure.

## Features

- **Elixir 1.17+** with Mix build tool
- **Just task runner** for all commands
- **Git hooks** via git_hooks hex package
- **Comprehensive AGENTS.md** for AI-assisted development

### Validation Tools

| Tool | Purpose | Why It's Used |
|------|---------|---------------|
| **mix format** | Formatting | Built-in code formatter - enforces consistent Elixir code style |
| **Credo** | Linting | Static analysis for code consistency, readability, and refactoring opportunities (strict mode) |
| **Dialyxir** | Type checking | Erlang Dialyzer wrapper - catches type errors, unreachable code, and spec violations |
| **mix compile** | LSP analysis | Compiler warnings-as-errors catches unused variables, imports, aliases, and deprecated calls |
| **Sobelow** | Security scanning | Finds security issues in Elixir code (SQL injection, XSS, directory traversal, etc.) |
| **mix deps** | Dependency hygiene | Detects unused dependencies and lock file drift |
| **codespell** | Spell checking | Catches typos in code, comments, and documentation |
| **Custom Credo checks** | Custom rules | Bans default parameters, fallback operators, Map.get defaults, and Dialyzer suppression |
| **mix_audit** | Vulnerability scanning | Scans Hex dependencies for known security vulnerabilities |
| **ExUnit** | Testing framework | Built-in testing with coverage support and async test execution |

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
