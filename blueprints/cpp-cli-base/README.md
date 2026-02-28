# C++ CLI Base Template

Production-ready Copier template for C++ CLI applications with full validation infrastructure.

## Features

- **C++20/C++23** with CMake build system
- **Just task runner** for all commands
- **Pre-commit hooks** with CI checks
- **Comprehensive AGENTS.md** for AI-assisted development
- **Git worktree workflow** support

### Validation Tools

| Tool | Purpose | Why It's Used |
|------|---------|---------------|
| **clang-format** | Formatting | Industry-standard formatter, auto-fix, C++23 support |
| **clang-tidy** | Linting/static analysis | Massive check catalog (bugprone, modernize, cert, cppcoreguidelines). WarningsAsErrors |
| **cppcheck** | Deep static analysis | Finds bugs compilers miss: null derefs, memory leaks, UB. Low false positives |
| **flawfinder** | Security scanning | C/C++ vulnerability scanner (buffer overflows, format strings, race conditions) |
| **include-what-you-use** | Dependency hygiene | Detects unused and missing `#include` directives |
| **semgrep** | Custom static analysis | Pattern-based rules banning unsafe patterns (raw new/delete, C casts, warning suppression) |
| **codespell** | Spell checking | Catches typos in code, comments, and documentation |
| **GoogleTest + lcov** | Testing and coverage | Unit testing with coverage thresholds |
| **ASan + UBSan** | Runtime sanitizers | Catches memory errors and undefined behavior at runtime |

## Template Structure

```
blueprints/cpp-cli-base/
├── copier.yml                          # Template configuration
├── README.md                           # This file
└── template/                           # Template files
    ├── .gitignore.template
    ├── .clang-format.template
    ├── .clang-tidy.template
    ├── CMakeLists.txt.template
    ├── .pre-commit-config.yaml.template
    ├── justfile.template
    ├── README.md.template
    ├── AGENTS.md.template
    ├── CLAUDE.md -> AGENTS.md         # Symlink (created via _tasks)
    ├── src/
    │   └── main.cpp.template
    ├── include/
    │   └── {{project_name}}/
    ├── tests/
    │   └── test_main.cpp.template
    ├── scripts/
    ├── data/
    │   ├── input/
    │   └── output/
    └── config/
        ├── semgrep/
        │   ├── no-raw-new-delete.yml
        │   ├── no-c-style-casts.yml
        │   └── no-warning-suppression.yml
        └── codespell/
            └── ignore.txt
```

## Usage

### Via just create

```bash
cd /path/to/ai-templates
just create cpp my-project
```

### Direct Copier usage

```bash
copier copy blueprints/cpp-cli-base my-project
cd my-project
just init
just run
```

## Template Questions

The template will ask:

- **project_name**: Project name (e.g., my-cli-tool)
- **project_description**: Short description
- **cpp_standard**: C++ standard version (20 or 23)
- **author_name**: Author name
- **author_email**: Author email
- **coverage_threshold**: Code coverage threshold (0-100, default 80)

## Generated Project Features

Projects created from this template include:

- **CMake build system**: Modern CMake with presets, C++20/C++23 support
- **Complete validation suite**: clang-format, clang-tidy, cppcheck, flawfinder, IWYU, semgrep, codespell
- **Runtime sanitizers**: AddressSanitizer and UndefinedBehaviorSanitizer
- **Just recipes**: init, run, destroy, code-*, test, ci, ci-quiet
- **Pre-commit hooks**: Runs `just ci-quiet` on commit
- **AI agent rules**: AGENTS.md with strict development guidelines
- **Git commit rules**: No AI attribution, explicit file staging
- **Semgrep rules**: Ban raw new/delete, C-style casts, warning suppression
- **Directory structure**: src/, include/, tests/, scripts/, data/

## Requirements

- **cmake 3.25+** - Build system
- **C++23 compiler** - GCC 14+ or Clang 18+
- **clang-format** - Code formatter
- **clang-tidy** - Static analysis
- **cppcheck** - Deep static analysis
- **flawfinder** - Security scanner
- **include-what-you-use** - Include hygiene
- **codespell** - Spell checker
- **semgrep** - Pattern-based analysis
- **lcov** - Coverage reporting
- **just** - Command runner
- **copier** - Template engine
- **git** - Version control

## Testing the Template

To verify the template generates correctly:

```bash
cd /path/to/ai-templates
just test-cpp
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
2. Test with: `just test-cpp` (from repository root)
3. Verify generated project works
4. Commit changes
