# Java CLI Base Template Design

## Summary

A Copier template at `blueprints/java-cli-base/` that produces Java 21+ CLI applications with Gradle (Kotlin DSL), a Justfile for unified commands, and a 12-step validation pipeline mirroring the existing Python CLI template.

## Decisions

- **Approach:** Direct mirror of the Python template (same Copier + Justfile + semgrep pattern)
- **Build tool:** Gradle with Kotlin DSL
- **Java version:** 21 (LTS) minimum
- **Testing:** JUnit 5 + AssertJ
- **Task runner:** Justfile wrapping Gradle (consistent cross-template experience)
- **Static analysis depth:** Full parity with Python template including custom semgrep rules

## Template Structure

```
blueprints/java-cli-base/
├── copier.yml
├── README.md
└── template/
    ├── .gitignore.template
    ├── justfile.template
    ├── AGENTS.md.template
    ├── README.md.template
    ├── settings.gradle.kts.template
    ├── build.gradle.kts.template
    ├── gradle.properties.template
    ├── .pre-commit-config.yaml.template
    ├── .cursor/
    │   └── commands/
    │       └── doc-statemachine.md
    ├── gradle/
    │   └── wrapper/
    ├── src/
    │   ├── main/java/{{package_path}}/
    │   │   └── Main.java.template
    │   └── test/java/{{package_path}}/
    │       └── MainTest.java.template
    ├── config/
    │   ├── checkstyle/
    │   │   └── checkstyle.xml
    │   ├── semgrep/
    │   │   ├── no-default-values.yml
    │   │   ├── no-sneaky-fallbacks.yml
    │   │   └── no-suppression.yml
    │   └── codespell/
    │       └── ignore.txt
    ├── scripts/
    ├── prompts/
    └── data/
        ├── input/
        └── output/
```

## CI Pipeline (12 Steps)

| Step | Recipe | Tool | Purpose |
|---|---|---|---|
| 1 | `init` | Gradle wrapper | Download dependencies |
| 2 | `code-format` | Spotless (google-java-format) | Auto-format Java files |
| 3 | `code-style` | Checkstyle | Google Java Style enforcement |
| 4 | `code-typecheck` | javac + Error Prone | Compile with enhanced diagnostics |
| 5 | `code-security` | SpotBugs + Find Security Bugs | Security scanning |
| 6 | `code-deptry` | Dependency Analysis plugin | Unused/undeclared deps |
| 7 | `code-spell` | codespell | Spell checking |
| 8 | `code-semgrep` | Semgrep | Custom Java antipattern rules |
| 9 | `code-audit` | OWASP Dependency-Check | CVE scanning |
| 10 | `test` | JUnit 5 + AssertJ | Unit tests |
| 11 | `code-architecture` | ArchUnit | Import/layer boundary enforcement |
| 12 | `ci` / `ci-quiet` | All above | Full pipeline (verbose / silent) |

## Copier Questions

| Question | Type | Default |
|---|---|---|
| `project_name` | str | — |
| `group_id` | str | `com.example` |
| `package_name` | str | derived from group_id + project_name |
| `project_description` | str | `A Java CLI application` |
| `java_version` | choice | `21` (options: 21, 23) |
| `author_name` | str | `""` |
| `author_email` | str | `""` |
| `coverage_threshold` | int | `80` |

## Gradle Plugins

```kotlin
plugins {
    java
    application
    id("com.diffplug.spotless")                    // google-java-format
    checkstyle                                      // Style enforcement
    id("com.github.spotbugs")                      // Bug + security scanning
    id("net.ltgt.errorprone")                      // Enhanced compiler checks
    jacoco                                          // Coverage
    id("org.owasp.dependencycheck")                // CVE scanning
    id("com.autonomousapps.dependency-analysis")   // Unused deps
}
```

## Dependencies

- `junit-jupiter` (JUnit 5)
- `assertj-core` (fluent assertions)
- `archunit-junit5` (architecture tests)
- `spotbugs-annotations` (SpotBugs annotations)
- `find-sec-bugs` (SpotBugs security plugin)
- `error_prone_core` (Error Prone)

## Semgrep Rules (Java)

### no-default-values.yml
- Ban `Optional.orElse(defaultValue)`
- Ban `Optional.orElseGet(() -> ...)`
- Ban method parameters with inline null-coalescing

### no-sneaky-fallbacks.yml
- Ban `Objects.requireNonNullElse(x, fallback)`
- Ban `Objects.requireNonNullElseGet(x, supplier)`
- Ban ternary null checks: `x != null ? x : fallback`
- Ban `Map.getOrDefault(key, default)`

### no-suppression.yml
- Ban `@SuppressWarnings(...)` (all variants)
- Ban `//noinspection` comments (IntelliJ)
- Ban `NOSONAR` comments

## AGENTS.md Content

Java-specific rules:
- Always use `./gradlew` (never `java` or `javac` directly)
- Never modify Gradle wrapper files
- Dependencies managed exclusively through `build.gradle.kts`
- No `@SuppressWarnings`, no `Optional.orElse()` with defaults
- No raw types, no `System.out.println` (use a logger)
- After every change, run `just test`
- Use AssertJ for assertions, not JUnit built-in
- Source in `src/main/java/`, tests in `src/test/java/`
- Same git commit rules as Python template (no AI attribution, explicit staging, push after commit)

## Testing the Template

The existing `tests/test-template.sh` should be extended (or a parallel test created) to:
1. Generate a test project from `java-cli-base`
2. Verify all files are created correctly
3. Run `just init`, `just run`, `just ci`, `just ci-quiet`, `just destroy`
4. Assert each step completes successfully
5. Clean up

## Repository Updates

- Update root `README.md` to list both templates
- Update root `justfile` to support `just create java-cli-base <path>`
- Add Java template to `tests/test-template.sh`
