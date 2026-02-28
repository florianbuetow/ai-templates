# Elixir Template Validation Gaps — Design

Date: 2026-02-28

## Problem

The Elixir OTP template is missing three validation checks that Python, Go, and Java templates all have:
1. LSP analysis (`code-lspchecks`)
2. Dependency hygiene (`code-deptry`)
3. Custom static analysis rules (`code-semgrep`)

## Solutions

### 1. `code-lspchecks` — `mix compile --force --warnings-as-errors --all-warnings`

Catches unused variables, imports, aliases, functions, module redefinitions, deprecated calls. Analogous to pyright (Python) / staticcheck (Go). Placed after `test` in CI chain.

### 2. `code-deptry` — `mix deps.unlock --check-unused` + `mix deps.get --check-locked`

Two checks: unused deps in lock file, and lock file in sync with mix.exs. No external tools needed. Placed between `code-spell` and `code-audit` in CI chain.

### 3. `code-semgrep` — Custom Credo checks

Semgrep Elixir requires paid Pro engine. Custom Credo checks are native and free. Recipe named `code-semgrep` for uniform CI interface. Checks live in `lib/credo/` loaded via `.credo.exs` requires field.

Custom checks:
- `NoDefaultParameterValues` — bans `def foo(bar \\ "default")` in lib/
- `NoFallbackOperator` — bans `value || fallback` in lib/
- `NoMapGetDefault` — bans `Map.get(map, key, default)` in lib/
- `NoDialyzerSuppress` — bans `@dialyzer {:nowarn_function, ...}` in lib/

### 4. Supporting changes

- `.credo.exs`: add requires and enable custom checks
- `justfile.template`: add 3 recipes, update ci/ci-quiet chains
- `AGENTS.md.template`: document custom checks
- `README.md` (template + root): update validation tools tables

### CI Chain

```
init → code-format → code-style → code-lint → code-typecheck → code-security →
code-deptry → code-spell → code-semgrep → code-audit → test → code-lspchecks
```
