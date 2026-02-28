# Java CLI Base Template Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create a Copier template at `blueprints/java-cli-base/` that generates Java 21+ CLI projects with Gradle (Kotlin DSL), Justfile, and a 12-step validation pipeline mirroring `blueprints/python-cli-base/`.

**Architecture:** Copier template with `.template` suffix convention. Gradle Kotlin DSL for build, Justfile wrapping Gradle commands for user-facing interface, semgrep for custom static analysis. All validation tools configured as Gradle plugins except codespell and semgrep which run standalone.

**Tech Stack:** Java 21+, Gradle 8.x (Kotlin DSL), JUnit 5, AssertJ, ArchUnit, Checkstyle, SpotBugs, Error Prone, Spotless, JaCoCo, OWASP Dependency-Check, codespell, semgrep.

**Design doc:** `docs/plans/2026-02-28-java-cli-template-design.md`

---

### Task 1: Create Copier configuration and directory skeleton

**Files:**
- Create: `blueprints/java-cli-base/copier.yml`
- Create: `blueprints/java-cli-base/template/` (empty dirs for scripts/, prompts/, data/input/, data/output/)

**Step 1: Create the copier.yml**

Reference the Python version at `blueprints/python-cli-base/copier.yml` for structure. Key differences:
- `package_name` derives from `group_id` + project name (dots to slashes for directory path)
- Add `group_id` question (default `com.example`)
- Add `java_version` choice (21 or 23)
- `_templates_suffix: ".template"` (same as Python)
- `_subdirectory: template` (same as Python)
- `_tasks` should create the `CLAUDE.md` symlink (same as Python)
- `_skip_if_exists` should include `src/main/java/`, `src/test/java/`, `scripts/`, `prompts/`, `data/`
- `_exclude` should include `.gradle`, `build/`, `CLAUDE.md`
- Add a computed `package_path` variable that converts dots to slashes (e.g. `com.example.myapp` -> `com/example/myapp`)

```yaml
_min_copier_version: "9.0.0"
_subdirectory: template
_templates_suffix: ".template"
_answers_file: .copier-answers.yml

_exclude:
  - ".gradle"
  - "build"
  - ".git"
  - "CLAUDE.md"

_skip_if_exists:
  - "src/main/java/"
  - "src/test/java/"
  - "data/input/"
  - "data/output/"
  - "scripts/"
  - "prompts/"

_message_before_copy: |
  Creating Java CLI project with full validation infrastructure.
  This will set up a production-ready project following strict conventions.

_message_after_copy: |
  Project {{project_name}} created successfully!

  Next steps:
    cd {{project_name}}
    just init    # Initialize and download dependencies
    just run     # Test the project
    just help    # See all available commands

_tasks:
  - "ln -s AGENTS.md CLAUDE.md"

project_name:
  type: str
  help: Project name (e.g., my-cli-tool)?
  validator: >-
    {% if not (project_name | regex_search('^[a-zA-Z0-9]([a-zA-Z0-9_.-]*[a-zA-Z0-9])?$')) %}
    Invalid project name. Use letters, digits, -, _, . only.
    {% endif %}

group_id:
  type: str
  help: Maven group ID (e.g., com.mycompany)?
  default: "com.example"
  validator: >-
    {% if not (group_id | regex_search('^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)*$')) %}
    Invalid group ID. Must be dot-separated lowercase identifiers.
    {% endif %}

package_name:
  type: str
  help: Java package name (e.g., com.example.myapp)?
  default: "{{group_id}}.{{project_name | replace('-', '') | replace('_', '') | replace('.', '') | lower}}"
  validator: >-
    {% if not (package_name | regex_search('^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)*$')) %}
    Invalid package name. Must be dot-separated lowercase identifiers.
    {% endif %}

package_path:
  type: str
  help: Package directory path (auto-generated from package_name)
  default: "{{package_name | replace('.', '/')}}"
  when: false

project_description:
  type: str
  help: Short description?
  default: "A Java CLI application"

java_version:
  type: str
  help: Minimum Java version?
  default: "21"
  choices:
    - "21"
    - "23"

author_name:
  type: str
  help: Author name?
  default: ""

author_email:
  type: str
  help: Author email?
  default: ""

coverage_threshold:
  type: int
  help: Code coverage threshold (%)?
  default: 80
  validator: >-
    {% if coverage_threshold < 0 or coverage_threshold > 100 %}
    Must be 0-100
    {% endif %}
```

**Step 2: Create empty placeholder directories**

Create `.gitkeep` files in:
- `blueprints/java-cli-base/template/scripts/.gitkeep`
- `blueprints/java-cli-base/template/prompts/.gitkeep`
- `blueprints/java-cli-base/template/data/input/.gitkeep`
- `blueprints/java-cli-base/template/data/output/.gitkeep`

**Step 3: Commit**

```bash
git add blueprints/java-cli-base/copier.yml blueprints/java-cli-base/template/scripts/.gitkeep blueprints/java-cli-base/template/prompts/.gitkeep blueprints/java-cli-base/template/data/input/.gitkeep blueprints/java-cli-base/template/data/output/.gitkeep
git commit -m "Add copier.yml and directory skeleton for java-cli-base template"
git push
```

---

### Task 2: Create Gradle build files

**Files:**
- Create: `blueprints/java-cli-base/template/settings.gradle.kts.template`
- Create: `blueprints/java-cli-base/template/build.gradle.kts.template`
- Create: `blueprints/java-cli-base/template/gradle.properties.template`

**Step 1: Create settings.gradle.kts.template**

```kotlin
rootProject.name = "{{project_name}}"
```

**Step 2: Create build.gradle.kts.template**

This is the central build file. Include all Gradle plugins from the design:

```kotlin
plugins {
    java
    application
    checkstyle
    jacoco
    id("com.diffplug.spotless") version "7.0.2"
    id("com.github.spotbugs") version "6.1.2"
    id("net.ltgt.errorprone") version "4.1.0"
    id("org.owasp.dependencycheck") version "12.1.0"
    id("com.autonomousapps.dependency-analysis") version "2.7.0"
}

group = "{{group_id}}"
version = "0.0.1"
description = "{{project_description}}"

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of({{java_version}})
    }
}

application {
    mainClass = "{{package_name}}.Main"
}

repositories {
    mavenCentral()
}

dependencies {
    // Error Prone
    errorprone("com.google.errorprone:error_prone_core:2.36.0")

    // Testing
    testImplementation(platform("org.junit:junit-bom:5.11.4"))
    testImplementation("org.junit.jupiter:junit-jupiter")
    testImplementation("org.assertj:assertj-core:3.27.3")
    testImplementation("com.tngtech.archunit:archunit-junit5:1.4.0")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")

    // SpotBugs annotations (compile-only)
    compileOnly("com.github.spotbugs:spotbugs-annotations:4.9.1")

    // Find Security Bugs plugin for SpotBugs
    spotbugsPlugins("com.h3xstream.findsecbugs:findsecbugs-plugin:1.13.0")
}

// --- Testing ---
tasks.test {
    useJUnitPlatform()
    finalizedBy(tasks.jacocoTestReport)
}

// --- Coverage ---
tasks.jacocoTestReport {
    dependsOn(tasks.test)
    reports {
        xml.required = true
        html.required = true
        html.outputLocation = layout.buildDirectory.dir("reports/jacoco/html")
        xml.outputLocation = layout.buildDirectory.file("reports/jacoco/coverage.xml")
    }
}

tasks.jacocoTestCoverageVerification {
    violationRules {
        rule {
            limit {
                minimum = java.math.BigDecimal("{{coverage_threshold}}").divide(java.math.BigDecimal("100"))
            }
        }
    }
}

// --- Checkstyle ---
checkstyle {
    toolVersion = "10.21.4"
    configFile = file("config/checkstyle/checkstyle.xml")
    isIgnoreFailures = false
    maxWarnings = 0
}

// --- Spotless (google-java-format) ---
spotless {
    java {
        googleJavaFormat()
        removeUnusedImports()
        trimTrailingWhitespace()
        endWithNewline()
    }
}

// --- SpotBugs ---
spotbugs {
    effort = com.github.spotbugs.snom.Effort.MAX
    reportLevel = com.github.spotbugs.snom.Confidence.MEDIUM
}

tasks.withType<com.github.spotbugs.snom.SpotBugsTask>().configureEach {
    reports.create("html") {
        required = true
    }
    reports.create("xml") {
        required = false
    }
}

// --- Error Prone ---
tasks.withType<JavaCompile>().configureEach {
    options.errorprone {
        allErrorsAsWarnings = false
        disableWarningsInGeneratedCode = true
    }
}

// --- OWASP Dependency Check ---
dependencyCheck {
    failBuildOnCVSS = 7.0f
    formats = listOf("HTML", "JSON")
}

// --- Dependency Analysis ---
dependencyAnalysis {
    issues {
        all {
            onUsedTransitiveDependencies { severity("fail") }
            onUnusedDependencies { severity("fail") }
            onRedundantPlugins { severity("fail") }
        }
    }
}
```

**Step 3: Create gradle.properties.template**

```properties
# Project settings
org.gradle.jvmargs=-Xmx1g
org.gradle.parallel=true
org.gradle.caching=true
```

**Step 4: Commit**

```bash
git add blueprints/java-cli-base/template/settings.gradle.kts.template blueprints/java-cli-base/template/build.gradle.kts.template blueprints/java-cli-base/template/gradle.properties.template
git commit -m "Add Gradle build configuration for java-cli-base template"
git push
```

---

### Task 3: Add Gradle wrapper

The Gradle wrapper should be checked into the template so generated projects work without requiring a pre-installed Gradle.

**Step 1: Generate the Gradle wrapper**

```bash
cd blueprints/java-cli-base/template
gradle wrapper --gradle-version 8.12
```

This creates `gradlew`, `gradlew.bat`, `gradle/wrapper/gradle-wrapper.jar`, `gradle/wrapper/gradle-wrapper.properties`.

Note: These files should NOT have the `.template` suffix — they are copied verbatim by Copier.

**Step 2: Verify the wrapper files exist**

Confirm these files were created:
- `gradlew` (executable)
- `gradlew.bat`
- `gradle/wrapper/gradle-wrapper.jar`
- `gradle/wrapper/gradle-wrapper.properties`

**Step 3: Commit**

```bash
git add blueprints/java-cli-base/template/gradlew blueprints/java-cli-base/template/gradlew.bat blueprints/java-cli-base/template/gradle/wrapper/
git commit -m "Add Gradle 8.12 wrapper to java-cli-base template"
git push
```

---

### Task 4: Create Java source files

**Files:**
- Create: `blueprints/java-cli-base/template/src/main/java/{{package_path}}/Main.java.template`
- Create: `blueprints/java-cli-base/template/src/test/java/{{package_path}}/MainTest.java.template`

**Step 1: Create Main.java.template**

```java
package {{package_name}};

/** {{project_description}}. */
public final class Main {

  private Main() {}

  /** Main entry point. */
  public static void main(String[] args) {
    System.out.println("Hello from {{project_name}}!");
  }
}
```

Note: For a CLI starter, `System.out.println` is acceptable in `main()`. The AGENTS.md rule about using loggers applies to application logic, not the hello-world entry point.

**Step 2: Create MainTest.java.template**

```java
package {{package_name}};

import static org.assertj.core.api.Assertions.assertThatCode;

import org.junit.jupiter.api.Test;

/** Tests for {@link Main}. */
class MainTest {

  @Test
  void mainRunsWithoutError() {
    assertThatCode(() -> Main.main(new String[] {})).doesNotThrowAnyException();
  }
}
```

**Step 3: Commit**

```bash
git add blueprints/java-cli-base/template/src/
git commit -m "Add Main.java and MainTest.java templates"
git push
```

---

### Task 5: Create architecture test with ArchUnit

**Files:**
- Create: `blueprints/java-cli-base/template/src/test/java/{{package_path}}/architecture/ArchitectureTest.java.template`

**Step 1: Create ArchitectureTest.java.template**

```java
package {{package_name}}.architecture;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses;

import com.tngtech.archunit.core.importer.ImportOption;
import com.tngtech.archunit.junit.AnalyzeClasses;
import com.tngtech.archunit.junit.ArchTest;
import com.tngtech.archunit.lang.ArchRule;

/**
 * Architecture import rule tests for {{project_name}}.
 *
 * <p>Add architectural boundary rules here as the project grows. Each test enforces one invariant
 * about the import graph.
 *
 * <p>Example rules to add as your project develops layers:
 *
 * <pre>{@code
 * // Business logic must not import HTTP framework
 * @ArchTest
 * static final ArchRule services_must_not_import_http =
 *     noClasses()
 *         .that().resideInAPackage("..services..")
 *         .should().dependOnClassesThat()
 *         .resideInAnyPackage("..http..", "..web..");
 * }</pre>
 *
 * @see <a href="https://www.archunit.org/userguide/html/000_Index.html">ArchUnit User Guide</a>
 */
@AnalyzeClasses(
    packages = "{{package_name}}",
    importOptions = ImportOption.DoNotIncludeTests.class)
class ArchitectureTest {

  /** Smoke test: verify ArchUnit can scan the codebase without errors. */
  @ArchTest
  static final ArchRule no_classes_should_depend_on_test_classes =
      noClasses()
          .that()
          .resideOutsideOfPackage("..test..")
          .should()
          .dependOnClassesThat()
          .resideInAPackage("..test..");
}
```

**Step 2: Commit**

```bash
git add blueprints/java-cli-base/template/src/test/java/
git commit -m "Add ArchUnit architecture test template"
git push
```

---

### Task 6: Create Checkstyle configuration

**Files:**
- Create: `blueprints/java-cli-base/template/config/checkstyle/checkstyle.xml`

**Step 1: Create checkstyle.xml**

Use the Google Java Style Checkstyle configuration. Download or inline the standard Google checks configuration from `https://raw.githubusercontent.com/checkstyle/checkstyle/master/src/main/resources/google_checks.xml`.

This file is static (no Copier templating needed), so no `.template` suffix.

**Step 2: Commit**

```bash
git add blueprints/java-cli-base/template/config/checkstyle/checkstyle.xml
git commit -m "Add Google Java Style checkstyle configuration"
git push
```

---

### Task 7: Create semgrep rules for Java

**Files:**
- Create: `blueprints/java-cli-base/template/config/semgrep/no-default-values.yml`
- Create: `blueprints/java-cli-base/template/config/semgrep/no-sneaky-fallbacks.yml`
- Create: `blueprints/java-cli-base/template/config/semgrep/no-suppression.yml`

**Step 1: Create no-default-values.yml**

```yaml
rules:
  - id: java.no-optional-or-else
    languages: [java]
    message: >
      Optional.orElse() with a default value hides missing data.
      Use Optional.orElseThrow() to fail explicitly when the value is absent,
      or handle the empty case with explicit logic.
    severity: ERROR
    pattern: $OPT.orElse($DEFAULT)
    paths:
      include:
        - src/main/
      exclude:
        - src/test/

  - id: java.no-optional-or-else-get
    languages: [java]
    message: >
      Optional.orElseGet() with a supplier hides missing data.
      Use Optional.orElseThrow() to fail explicitly when the value is absent,
      or handle the empty case with explicit logic.
    severity: ERROR
    pattern: $OPT.orElseGet($SUPPLIER)
    paths:
      include:
        - src/main/
      exclude:
        - src/test/
```

**Step 2: Create no-sneaky-fallbacks.yml**

```yaml
rules:
  - id: java.no-objects-require-non-null-else
    languages: [java]
    message: >
      Objects.requireNonNullElse() hides null values with a fallback.
      Use Objects.requireNonNull() to fail explicitly, or add proper null checks
      with clear error messages.
    severity: ERROR
    pattern: Objects.requireNonNullElse($OBJ, $DEFAULT)
    paths:
      include:
        - src/main/
      exclude:
        - src/test/

  - id: java.no-objects-require-non-null-else-get
    languages: [java]
    message: >
      Objects.requireNonNullElseGet() hides null values with a lazy fallback.
      Use Objects.requireNonNull() to fail explicitly, or add proper null checks
      with clear error messages.
    severity: ERROR
    pattern: Objects.requireNonNullElseGet($OBJ, $SUPPLIER)
    paths:
      include:
        - src/main/
      exclude:
        - src/test/

  - id: java.no-map-get-or-default
    languages: [java]
    message: >
      Map.getOrDefault() hides missing configuration values.
      Access the key directly and handle the missing case explicitly,
      or use Map.get() with a null check and error.
    severity: ERROR
    pattern: $MAP.getOrDefault($KEY, $DEFAULT)
    paths:
      include:
        - src/main/
      exclude:
        - src/test/

  - id: java.no-ternary-null-fallback
    languages: [java]
    message: >
      Ternary null check with fallback hides missing data.
      Use explicit null checks with clear error messages instead.
    severity: ERROR
    pattern: $VAR != null ? $VAR : $DEFAULT
    paths:
      include:
        - src/main/
      exclude:
        - src/test/
```

**Step 3: Create no-suppression.yml**

```yaml
rules:
  - id: java.no-suppress-warnings
    languages: [java]
    message: >
      @SuppressWarnings is not allowed. Fix the underlying issue instead of suppressing it.
      If you believe suppression is required, explain why and propose a fix that avoids suppression.
    severity: ERROR
    pattern: "@SuppressWarnings(...)"
    paths:
      include:
        - src/main/
      exclude:
        - src/test/

  - id: java.no-noinspection-comment
    languages: [java]
    message: >
      //noinspection comments are not allowed. Fix the underlying issue instead of suppressing it.
    severity: ERROR
    pattern-regex: '//\s*noinspection\b'
    paths:
      include:
        - src/main/
      exclude:
        - src/test/

  - id: java.no-nosonar-comment
    languages: [java]
    message: >
      NOSONAR comments are not allowed. Fix the underlying issue instead of suppressing it.
    severity: ERROR
    pattern-regex: 'NOSONAR'
    paths:
      include:
        - src/main/
      exclude:
        - src/test/
```

**Step 4: Commit**

```bash
git add blueprints/java-cli-base/template/config/semgrep/
git commit -m "Add custom semgrep rules for Java antipatterns"
git push
```

---

### Task 8: Create codespell and semgrepignore config

**Files:**
- Create: `blueprints/java-cli-base/template/config/codespell/ignore.txt`
- Create: `blueprints/java-cli-base/template/.semgrepignore.template`

**Step 1: Create codespell ignore.txt**

```
# Domain-specific terms that codespell should ignore
# One word per line, case-insensitive

# Java & Build tools
gradle
junit
jacoco
checkstyle
spotbugs
archunit
assertj
errorprone

# Project-specific
# Add domain terms as false positives are discovered
```

**Step 2: Create .semgrepignore.template**

```
:include .gitignore

# Gradle build directory
build/
.gradle/

# Reports
reports/
```

**Step 3: Commit**

```bash
git add blueprints/java-cli-base/template/config/codespell/ignore.txt blueprints/java-cli-base/template/.semgrepignore.template
git commit -m "Add codespell and semgrepignore configuration"
git push
```

---

### Task 9: Create .gitignore.template

**Files:**
- Create: `blueprints/java-cli-base/template/.gitignore.template`

**Step 1: Create .gitignore.template**

```
# Gradle
.gradle/
build/
!gradle/wrapper/gradle-wrapper.jar

# Java
*.class
*.jar
*.war
*.ear
hs_err_pid*
replay_pid*

# IDE - IntelliJ
.idea/
*.iml
*.iws
*.ipr
out/

# IDE - Eclipse
.classpath
.project
.settings/

# IDE - VS Code
.vscode/

# Reports
reports/

# macOS
.DS_Store
.AppleDouble
.LSOverride

# Copier answers file
.copier-answers.yml
```

**Step 2: Commit**

```bash
git add blueprints/java-cli-base/template/.gitignore.template
git commit -m "Add .gitignore template for Java projects"
git push
```

---

### Task 10: Create .pre-commit-config.yaml.template

**Files:**
- Create: `blueprints/java-cli-base/template/.pre-commit-config.yaml.template`

**Step 1: Create .pre-commit-config.yaml.template**

```yaml
# Pre-commit hooks configuration
# Install: pip install pre-commit && pre-commit install
# Run manually: pre-commit run --all-files
# Skip temporarily: git commit --no-verify

repos:
  - repo: local
    hooks:
      - id: run-just-ci-quiet
        name: Run just ci-quiet
        entry: just ci-quiet
        language: system
        pass_filenames: false
        always_run: true
        verbose: true
```

**Step 2: Commit**

```bash
git add blueprints/java-cli-base/template/.pre-commit-config.yaml.template
git commit -m "Add pre-commit hooks configuration for Java template"
git push
```

---

### Task 11: Create justfile.template

**Files:**
- Create: `blueprints/java-cli-base/template/justfile.template`

**Step 1: Create justfile.template**

Mirror the Python justfile structure exactly. Every recipe starts/ends with `@echo ""`. The CI pipeline order is: init, code-format, code-style, code-typecheck, code-security, code-deptry, code-spell, code-semgrep, code-audit, test, code-architecture.

```just
# Default recipe: show available commands
_default:
    @just --list

# Show help information
help:
    @echo ""
    @clear
    @echo ""
    @echo "\033[0;34m=== {{project_name}} ===\033[0m"
    @echo ""
    @echo "Available commands:"
    @just --list
    @echo ""

# Initialize the development environment
init:
    @echo ""
    @echo "\033[0;34m=== Initializing Development Environment ===\033[0m"
    @echo "Downloading dependencies..."
    @./gradlew dependencies --quiet
    @echo "\033[0;32m✓ Development environment ready\033[0m"
    @echo ""

# Run the main application
run:
    @echo ""
    @echo "\033[0;34m=== Running Application ===\033[0m"
    @./gradlew run --quiet --console=plain
    @echo ""

# Clean build artifacts
destroy:
    @echo ""
    @echo "\033[0;34m=== Cleaning Build Artifacts ===\033[0m"
    @./gradlew clean --quiet
    @rm -rf .gradle
    @echo "\033[0;32m✓ Build artifacts removed\033[0m"
    @echo ""

# Auto-format code with google-java-format (via Spotless)
code-format:
    @echo ""
    @echo "\033[0;34m=== Formatting Code ===\033[0m"
    @./gradlew spotlessApply --quiet
    @echo "\033[0;32m✓ Code formatted\033[0m"
    @echo ""

# Check code style with Checkstyle (read-only)
code-style:
    @echo ""
    @echo "\033[0;34m=== Checking Code Style ===\033[0m"
    @./gradlew checkstyleMain checkstyleTest --quiet
    @echo "\033[0;32m✓ Style checks passed\033[0m"
    @echo ""

# Compile with Error Prone for enhanced type/bug checking
code-typecheck:
    @echo ""
    @echo "\033[0;34m=== Running Type Checks (Error Prone) ===\033[0m"
    @./gradlew compileJava compileTestJava --quiet
    @echo "\033[0;32m✓ Type checks passed\033[0m"
    @echo ""

# Run security checks with SpotBugs + Find Security Bugs
code-security:
    @echo ""
    @echo "\033[0;34m=== Running Security Checks ===\033[0m"
    @./gradlew spotbugsMain --quiet
    @echo "\033[0;32m✓ Security checks passed\033[0m"
    @echo ""

# Check dependency hygiene
code-deptry:
    @echo ""
    @echo "\033[0;34m=== Checking Dependencies ===\033[0m"
    @./gradlew buildHealth --quiet
    @echo "\033[0;32m✓ Dependency checks passed\033[0m"
    @echo ""

# Check spelling in code and documentation
code-spell:
    @echo ""
    @echo "\033[0;34m=== Checking Spelling ===\033[0m"
    @codespell src config scripts prompts *.md *.kts *.properties --ignore-words=config/codespell/ignore.txt
    @echo "\033[0;32m✓ Spelling checks passed\033[0m"
    @echo ""

# Run Semgrep static analysis with custom rules
code-semgrep:
    @echo ""
    @echo "\033[0;34m=== Running Semgrep Static Analysis ===\033[0m"
    @semgrep --config config/semgrep/ --error src/main/
    @echo "\033[0;32m✓ Semgrep checks passed\033[0m"
    @echo ""

# Scan dependencies for known vulnerabilities (OWASP)
code-audit:
    @echo ""
    @echo "\033[0;34m=== Scanning Dependencies for Vulnerabilities ===\033[0m"
    @./gradlew dependencyCheckAnalyze --quiet
    @echo "\033[0;32m✓ No critical vulnerabilities found\033[0m"
    @echo ""

# Run unit tests
test:
    @echo ""
    @echo "\033[0;34m=== Running Unit Tests ===\033[0m"
    @./gradlew test --quiet
    @echo ""

# Run unit tests with coverage report and threshold check
test-coverage: init
    @echo ""
    @echo "\033[0;34m=== Running Unit Tests with Coverage ===\033[0m"
    @./gradlew test jacocoTestReport jacocoTestCoverageVerification --quiet
    @echo ""
    @echo "\033[0;32m✓ Coverage threshold met\033[0m"
    @echo ""

# Run architecture import rule tests
code-architecture:
    @echo ""
    @echo "\033[0;34m=== Running Architecture Tests ===\033[0m"
    @./gradlew test --tests '*architecture*' --quiet
    @echo "\033[0;32m✓ Architecture checks passed\033[0m"
    @echo ""

# Run ALL validation checks (verbose)
ci:
    #!/usr/bin/env bash
    set -e
    echo ""
    echo "\033[0;34m=== Running CI Checks ===\033[0m"
    echo ""
    just init
    just code-format
    just code-style
    just code-typecheck
    just code-security
    just code-deptry
    just code-spell
    just code-semgrep
    just code-audit
    just test
    just code-architecture
    echo ""
    echo "\033[0;32m✓ All CI checks passed\033[0m"
    echo ""

# Run ALL validation checks silently (only show output on errors)
ci-quiet:
    #!/usr/bin/env bash
    set -e
    echo "\033[0;34m=== Running CI Checks (Quiet Mode) ===\033[0m"
    TMPFILE=$(mktemp)
    trap "rm -f $TMPFILE" EXIT

    just init > $TMPFILE 2>&1 || { echo "\033[0;31m✗ Init failed\033[0m"; cat $TMPFILE; exit 1; }
    echo "\033[0;32m✓ Init passed\033[0m"

    just code-format > $TMPFILE 2>&1 || { echo "\033[0;31m✗ Code-format failed\033[0m"; cat $TMPFILE; exit 1; }
    echo "\033[0;32m✓ Code-format passed\033[0m"

    just code-style > $TMPFILE 2>&1 || { echo "\033[0;31m✗ Code-style failed\033[0m"; cat $TMPFILE; exit 1; }
    echo "\033[0;32m✓ Code-style passed\033[0m"

    just code-typecheck > $TMPFILE 2>&1 || { echo "\033[0;31m✗ Code-typecheck failed\033[0m"; cat $TMPFILE; exit 1; }
    echo "\033[0;32m✓ Code-typecheck passed\033[0m"

    just code-security > $TMPFILE 2>&1 || { echo "\033[0;31m✗ Code-security failed\033[0m"; cat $TMPFILE; exit 1; }
    echo "\033[0;32m✓ Code-security passed\033[0m"

    just code-deptry > $TMPFILE 2>&1 || { echo "\033[0;31m✗ Code-deptry failed\033[0m"; cat $TMPFILE; exit 1; }
    echo "\033[0;32m✓ Code-deptry passed\033[0m"

    just code-spell > $TMPFILE 2>&1 || { echo "\033[0;31m✗ Code-spell failed\033[0m"; cat $TMPFILE; exit 1; }
    echo "\033[0;32m✓ Code-spell passed\033[0m"

    just code-semgrep > $TMPFILE 2>&1 || { echo "\033[0;31m✗ Code-semgrep failed\033[0m"; cat $TMPFILE; exit 1; }
    echo "\033[0;32m✓ Code-semgrep passed\033[0m"

    just code-audit > $TMPFILE 2>&1 || { echo "\033[0;31m✗ Code-audit failed\033[0m"; cat $TMPFILE; exit 1; }
    echo "\033[0;32m✓ Code-audit passed\033[0m"

    just test > $TMPFILE 2>&1 || { echo "\033[0;31m✗ Test failed\033[0m"; cat $TMPFILE; exit 1; }
    echo "\033[0;32m✓ Test passed\033[0m"

    just code-architecture > $TMPFILE 2>&1 || { echo "\033[0;31m✗ Code-architecture failed\033[0m"; cat $TMPFILE; exit 1; }
    echo "\033[0;32m✓ Code-architecture passed\033[0m"

    echo ""
    echo "\033[0;32m✓ All CI checks passed\033[0m"
    echo ""
```

**Step 2: Commit**

```bash
git add blueprints/java-cli-base/template/justfile.template
git commit -m "Add justfile with 12-step CI pipeline for Java template"
git push
```

---

### Task 12: Create AGENTS.md.template

**Files:**
- Create: `blueprints/java-cli-base/template/AGENTS.md.template`

**Step 1: Create AGENTS.md.template**

Mirror the Python AGENTS.md structure, with Java-specific rules:

```markdown
# Development Rules for {{project_name}}

This file provides guidance to AI agents and AI-assisted development tools when working with this project. This includes Claude Code, Cursor IDE, GitHub Copilot, Windsurf, and any other AI coding assistants.

## General Coding Principles
- **Never assume any default values anywhere**
- Always be explicit about values, paths, and configurations
- If a value is not provided, handle it explicitly (throw exception, use Optional properly, or prompt for input)

## Git Commit Guidelines

**IMPORTANT:** When creating git commits in this repository:
- **NEVER include AI attribution in commit messages**
- **NEVER add "Generated with [AI tool name]" or similar phrases**
- **NEVER add "Co-Authored-By: [AI name]" or similar attribution**
- **NEVER run `git add -A` or `git add .` - always stage files explicitly**
- Keep commit messages professional and focused on the changes made
- Commit messages should describe what changed and why, without mentioning AI assistance
- **ALWAYS run `git push` after creating a commit to push changes to the remote repository**

## Testing
- After **every change** to the code, the tests must be executed
- Always verify the program runs correctly with `just run` after modifications
- Use **AssertJ** for all assertions, never JUnit's built-in assertEquals/assertTrue
- Use **ArchUnit** for architecture constraint tests

## Java Execution Rules
- Java code must be built and executed **only** via `./gradlew`
  - Example: `./gradlew run` to run, `./gradlew test` to test
  - **Never** use: `java`, `javac`, or `jar` directly
- Dependencies must be managed **only** through `build.gradle.kts`
  - **Never** download JARs manually or add them to the classpath
- **Never** modify the Gradle wrapper files (`gradlew`, `gradlew.bat`, `gradle/wrapper/`)

## Justfile Rules
- All Java execution in the justfile uses `./gradlew`, never `java` directly
- Use `just init` to set up the project
- Use `just run` to execute the main program
- Use `just destroy` to clean build artifacts
- Use `just help` to see all available recipes with descriptions
- Use `just` (with no arguments) to see a list of all recipes
- Use `just ci` to run all validation checks (verbose)
- Use `just ci-quiet` to run all validation checks (silent, fail-fast)

## Forbidden Patterns
- **No `@SuppressWarnings`** - Fix the underlying issue instead
- **No `//noinspection`** - Fix the underlying issue instead
- **No `NOSONAR`** - Fix the underlying issue instead
- **No `Optional.orElse()` with default values** - Use `orElseThrow()` or explicit handling
- **No `Map.getOrDefault()`** - Access keys directly with null checks
- **No `Objects.requireNonNullElse()`** - Use `Objects.requireNonNull()` with explicit errors
- **No raw types** - Always use parameterized types
- **No `System.out.println`** in application logic - Use a proper logger (java.util.logging or SLF4J)

## Project Structure
- Source code in `src/main/java/`
- Test code in `src/test/java/`
- Architecture tests in `src/test/java/{{package_path}}/architecture/`
- Utility scripts in `scripts/`
- Prompt templates in `prompts/`
- Input data in `data/input/`
- Output data in `data/output/`
- **Never create Java files in the project root directory**
  - Wrong: `./Helper.java`, `./Test.java`
  - Correct: `./src/main/java/{{package_path}}/Helper.java`

## Error Handling
- Use checked exceptions for recoverable errors
- Use unchecked exceptions (IllegalArgumentException, IllegalStateException) for programming errors
- Never catch and swallow exceptions silently
- Always include meaningful error messages in exceptions
- Exit with code 1 on failure, 0 on success

## Optimization
- **Skip processing if output already exists** - Don't reprocess unnecessarily
- Check if output file exists before starting expensive operations
```

**Step 2: Commit**

```bash
git add blueprints/java-cli-base/template/AGENTS.md.template
git commit -m "Add AGENTS.md template with Java-specific development rules"
git push
```

---

### Task 13: Create README.md.template

**Files:**
- Create: `blueprints/java-cli-base/template/README.md.template`

**Step 1: Create README.md.template**

Mirror the Python README structure:

```markdown
# {{project_name}}

{{project_description}}

## Repository Structure

\```
{{project_name}}/
├── build.gradle.kts        # Build configuration and plugins
├── settings.gradle.kts     # Gradle project settings
├── gradle.properties       # Gradle properties
├── gradlew                 # Gradle wrapper (Unix)
├── gradlew.bat             # Gradle wrapper (Windows)
├── .pre-commit-config.yaml # Pre-commit hooks configuration
├── .gitignore              # Git ignore patterns
├── justfile                # Task runner with build/test/validation commands
├── AGENTS.md               # AI agent development rules
├── CLAUDE.md               # Claude Code compatibility (symlink to AGENTS.md)
├── README.md               # This file
├── .cursor/                # Cursor IDE configuration
│   └── commands/           # Cursor AI commands
│       └── doc-statemachine.md  # Generate state machine diagrams
├── gradle/                 # Gradle wrapper files
│   └── wrapper/
├── src/
│   ├── main/java/          # Source code
│   │   └── {{package_path}}/
│   │       └── Main.java   # Main entry point
│   └── test/java/          # Test code
│       └── {{package_path}}/
│           ├── MainTest.java              # Unit tests
│           └── architecture/
│               └── ArchitectureTest.java  # ArchUnit tests
├── config/                 # Configuration files
│   ├── checkstyle/
│   │   └── checkstyle.xml  # Google Java Style rules
│   ├── semgrep/            # Custom static analysis rules
│   │   ├── no-default-values.yml
│   │   ├── no-sneaky-fallbacks.yml
│   │   └── no-suppression.yml
│   └── codespell/
│       └── ignore.txt      # Spell-check ignore list
├── scripts/                # Utility scripts
├── prompts/                # LLM prompt templates
└── data/                   # Data files
    ├── input/              # Input data files
    └── output/             # Generated output files
\```

## Prerequisites

- **Java {{java_version}}+** - JDK ([Adoptium](https://adoptium.net/), [Oracle](https://www.oracle.com/java/technologies/downloads/))
- **just** - Command runner ([installation guide](https://github.com/casey/just#installation))
- **codespell** - Spell checker (`pip install codespell`)
- **semgrep** - Static analysis (`pip install semgrep`)

## Setup

Initialize the project environment:

\```bash
just init
\```

This will download all dependencies via the Gradle wrapper.

## Usage

Run the main application:

\```bash
just run
\```

See all available commands:

\```bash
just help
\```

Or simply:

\```bash
just
\```

## Development

### Available Commands

- `just init` - Initialize development environment
- `just run` - Run the main application
- `just destroy` - Clean build artifacts
- `just help` - Show available commands

### Code Quality

- `just code-format` - Auto-format code (google-java-format via Spotless)
- `just code-style` - Check code style (Checkstyle)
- `just code-typecheck` - Compile with Error Prone checks
- `just code-security` - Run security checks (SpotBugs + Find Security Bugs)
- `just code-deptry` - Check dependency hygiene
- `just code-spell` - Check spelling (codespell)
- `just code-semgrep` - Run custom static analysis
- `just code-audit` - Scan for CVEs (OWASP Dependency-Check)

### Testing

- `just test` - Run unit tests
- `just test-coverage` - Run tests with coverage ({{coverage_threshold}}% threshold)
- `just code-architecture` - Run ArchUnit architecture tests

### CI

- `just ci` - Run all validation checks (verbose)
- `just ci-quiet` - Run all checks (silent, fail-fast)

The CI pipeline runs the following steps in order:
1. `init` - Initialize environment
2. `code-format` - Auto-format code
3. `code-style` - Verify formatting (Checkstyle)
4. `code-typecheck` - Compile with Error Prone
5. `code-security` - Security scan (SpotBugs)
6. `code-deptry` - Dependency hygiene
7. `code-spell` - Spell checking
8. `code-semgrep` - Custom static analysis
9. `code-audit` - CVE scanning (OWASP)
10. `test` - Unit tests
11. `code-architecture` - ArchUnit tests

## Project Rules

See [AGENTS.md](AGENTS.md) for detailed development guidelines including:
- Java execution rules (use `./gradlew` exclusively)
- Git commit guidelines (no AI attribution)
- Forbidden patterns (no @SuppressWarnings, no default values)
- Testing requirements
- Project structure conventions

## License

<!-- Add your license here -->
```

Note: The triple backticks inside the template need to be escaped for Copier. Check how the Python template handles this — the Python README.md.template uses actual backticks. If Copier passes them through, do the same. Otherwise use `{% raw %}` blocks.

**Step 2: Commit**

```bash
git add blueprints/java-cli-base/template/README.md.template
git commit -m "Add README.md template for Java projects"
git push
```

---

### Task 14: Copy doc-statemachine.md from Python template

**Files:**
- Create: `blueprints/java-cli-base/template/.cursor/commands/doc-statemachine.md`

**Step 1: Copy the file**

```bash
mkdir -p blueprints/java-cli-base/template/.cursor/commands/
cp blueprints/python-cli-base/template/.cursor/commands/doc-statemachine.md blueprints/java-cli-base/template/.cursor/commands/doc-statemachine.md
```

**Step 2: Commit**

```bash
git add blueprints/java-cli-base/template/.cursor/commands/doc-statemachine.md
git commit -m "Add Cursor IDE statemachine command to Java template"
git push
```

---

### Task 15: Create template README.md

**Files:**
- Create: `blueprints/java-cli-base/README.md`

**Step 1: Create README.md**

This is the template's own documentation (not the generated project's README). Mirror the structure of `blueprints/python-cli-base/README.md`, adapted for Java.

Cover:
- Features (Java 21+, Gradle, full validation infrastructure)
- Template structure (directory listing)
- Usage (via setup-project.sh, direct copier, just create)
- Template questions
- Generated project features
- Requirements (Java 21+, just, copier, git, codespell, semgrep)
- Testing instructions

**Step 2: Commit**

```bash
git add blueprints/java-cli-base/README.md
git commit -m "Add README documentation for java-cli-base template"
git push
```

---

### Task 16: Create test script for Java template

**Files:**
- Create: `tests/test-java-template.sh`

**Step 1: Create test-java-template.sh**

Mirror `tests/test-template.sh` structure. Key differences:
- Template path: `blueprints/java-cli-base`
- Check for `java` and `gradle` prerequisites instead of `uv` and `python`
- Copier data uses `group_id`, `package_name`, `java_version` instead of `python_version`, `package_name`
- File existence checks: `build.gradle.kts`, `settings.gradle.kts`, `gradlew`, `src/main/java/...`, etc.
- CLAUDE.md symlink check (same as Python)
- Run `just init`, `just run`, `just ci`, `just ci-quiet`, `just destroy`
- Check output contains "Hello from test-cli-project!"

```bash
#!/usr/bin/env bash
# Test script for Java CLI template
# Tests the complete workflow: generate project, init, run, ci, ci-quiet, destroy

set -euo pipefail

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test configuration
PROJECT_NAME="test-cli-project"
GROUP_ID="com.example"
PACKAGE_NAME="com.example.testcliproject"
PACKAGE_PATH="com/example/testcliproject"

# Script directory and repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_PATH="$REPO_ROOT/blueprints/java-cli-base"

TEMP_DIR=""

cleanup() {
    local exit_code=$?
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        echo ""
        echo -e "${BLUE}=== Cleaning up ===${NC}"
        rm -rf "$TEMP_DIR"
        echo -e "${GREEN}✓ Removed temp directory${NC}"
        echo ""
    fi
    exit $exit_code
}

trap cleanup EXIT INT TERM

assert_success() {
    local step_name="$1"
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓ $step_name succeeded${NC}"
    else
        echo -e "${RED}✗ $step_name failed (exit code: $exit_code)${NC}"
        exit 1
    fi
}

assert_file_exists() {
    local file_path="$1"
    local description="$2"
    if [ -f "$file_path" ] || [ -L "$file_path" ]; then
        echo -e "${GREEN}✓ $description exists${NC}"
    else
        echo -e "${RED}✗ $description does not exist: $file_path${NC}"
        exit 1
    fi
}

assert_dir_exists() {
    local dir_path="$1"
    local description="$2"
    if [ -d "$dir_path" ]; then
        echo -e "${GREEN}✓ $description exists${NC}"
    else
        echo -e "${RED}✗ $description does not exist: $dir_path${NC}"
        exit 1
    fi
}

assert_output_contains() {
    local output="$1"
    local expected="$2"
    local description="$3"
    if echo "$output" | grep -q "$expected"; then
        echo -e "${GREEN}✓ $description${NC}"
    else
        echo -e "${RED}✗ $description${NC}"
        echo -e "${RED}  Expected to find: '$expected'${NC}"
        echo -e "${RED}  In output: '$output'${NC}"
        exit 1
    fi
}

main() {
    echo ""
    echo -e "${BLUE}=== Testing Java CLI Template ===${NC}"
    echo ""

    # Check prerequisites
    echo -e "${BLUE}=== Checking Prerequisites ===${NC}"

    if ! command -v copier >/dev/null 2>&1; then
        echo -e "${RED}✗ Error: copier is not installed${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ copier is installed${NC}"

    if ! command -v just >/dev/null 2>&1; then
        echo -e "${RED}✗ Error: just is not installed${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ just is installed${NC}"

    if ! command -v java >/dev/null 2>&1; then
        echo -e "${RED}✗ Error: java is not installed${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ java is installed${NC}"

    if ! command -v codespell >/dev/null 2>&1; then
        echo -e "${RED}✗ Error: codespell is not installed${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ codespell is installed${NC}"

    if ! command -v semgrep >/dev/null 2>&1; then
        echo -e "${RED}✗ Error: semgrep is not installed${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ semgrep is installed${NC}"
    echo ""

    # Create temp directory
    TEMP_DIR=$(mktemp -d)
    echo -e "${GREEN}✓ Created temp directory: $TEMP_DIR${NC}"
    echo ""

    # Generate project
    echo -e "${BLUE}=== Step 1: Generating Project from Template ===${NC}"
    cd "$TEMP_DIR"

    copier copy --trust --defaults \
        --data project_name="$PROJECT_NAME" \
        --data group_id="$GROUP_ID" \
        --data package_name="$PACKAGE_NAME" \
        --data package_path="$PACKAGE_PATH" \
        --data project_description="Test CLI application" \
        --data java_version="21" \
        --data author_name="Test Author" \
        --data author_email="test@example.com" \
        --data coverage_threshold=80 \
        "$TEMPLATE_PATH" "$PROJECT_NAME" 2>&1

    assert_success "Project generation"
    echo ""

    # Verify files
    echo -e "${BLUE}=== Verifying Generated Files ===${NC}"
    cd "$PROJECT_NAME"

    assert_file_exists "build.gradle.kts" "build.gradle.kts"
    assert_file_exists "settings.gradle.kts" "settings.gradle.kts"
    assert_file_exists "gradle.properties" "gradle.properties"
    assert_file_exists "gradlew" "gradlew"
    assert_file_exists "gradlew.bat" "gradlew.bat"
    assert_file_exists ".pre-commit-config.yaml" ".pre-commit-config.yaml"
    assert_file_exists ".gitignore" ".gitignore"
    assert_file_exists "justfile" "justfile"
    assert_file_exists "README.md" "README.md"
    assert_file_exists "AGENTS.md" "AGENTS.md"
    assert_file_exists "CLAUDE.md" "CLAUDE.md (symlink)"
    assert_file_exists "src/main/java/$PACKAGE_PATH/Main.java" "Main.java"
    assert_file_exists "src/test/java/$PACKAGE_PATH/MainTest.java" "MainTest.java"
    assert_file_exists "src/test/java/$PACKAGE_PATH/architecture/ArchitectureTest.java" "ArchitectureTest.java"
    assert_file_exists "config/checkstyle/checkstyle.xml" "checkstyle.xml"
    assert_file_exists "config/semgrep/no-default-values.yml" "semgrep no-default-values"
    assert_file_exists "config/semgrep/no-sneaky-fallbacks.yml" "semgrep no-sneaky-fallbacks"
    assert_file_exists "config/semgrep/no-suppression.yml" "semgrep no-suppression"
    assert_file_exists "config/codespell/ignore.txt" "codespell ignore.txt"
    assert_dir_exists "gradle/wrapper" "gradle/wrapper directory"

    # Verify CLAUDE.md symlink
    if [ -L "CLAUDE.md" ]; then
        TARGET=$(readlink CLAUDE.md)
        if [ "$TARGET" = "AGENTS.md" ]; then
            echo -e "${GREEN}✓ CLAUDE.md correctly symlinked to AGENTS.md${NC}"
        else
            echo -e "${RED}✗ CLAUDE.md symlink points to wrong target: $TARGET${NC}"
            exit 1
        fi
    else
        echo -e "${RED}✗ CLAUDE.md is not a symlink${NC}"
        exit 1
    fi
    echo ""

    # Step 2: just init
    echo -e "${BLUE}=== Step 2: Running 'just init' ===${NC}"
    just init
    assert_success "just init"
    echo ""

    # Step 3: just run
    echo -e "${BLUE}=== Step 3: Running 'just run' ===${NC}"
    OUTPUT=$(just run 2>&1)
    assert_success "just run"
    assert_output_contains "$OUTPUT" "Hello from $PROJECT_NAME" "Correct output from Main.java"
    echo ""

    # Step 4: just ci
    echo -e "${BLUE}=== Step 4: Running 'just ci' (verbose) ===${NC}"
    just ci
    assert_success "just ci"
    echo ""

    # Step 5: just ci-quiet
    echo -e "${BLUE}=== Step 5: Running 'just ci-quiet' (silent) ===${NC}"
    just ci-quiet
    assert_success "just ci-quiet"
    echo ""

    # Step 6: just destroy
    echo -e "${BLUE}=== Step 6: Running 'just destroy' ===${NC}"
    just destroy
    assert_success "just destroy"

    if [ ! -d "build" ]; then
        echo -e "${GREEN}✓ build directory was removed${NC}"
    else
        echo -e "${RED}✗ build directory still exists after destroy${NC}"
        exit 1
    fi
    echo ""

    echo -e "${GREEN}=== All Tests Passed! ===${NC}"
    echo ""
}

main "$@"
```

**Step 2: Make it executable**

```bash
chmod +x tests/test-java-template.sh
```

**Step 3: Commit**

```bash
git add tests/test-java-template.sh
git commit -m "Add integration test script for Java CLI template"
git push
```

---

### Task 17: Update root justfile and README

**Files:**
- Modify: `justfile` (root)
- Modify: `README.md` (root)

**Step 1: Update root justfile**

Add `java-cli-base` to the help message under "Available templates". The `create` recipe already works generically (it takes `template-name` as a parameter).

Add a `test-java` recipe:

```just
# Test the Java CLI template
test-java:
    @./tests/test-java-template.sh
```

Update the existing `test` recipe to mention both, or rename to `test-python`. Alternatively, keep `test` running just the Python test and add `test-java` separately, plus a `test-all` recipe.

**Step 2: Update root README.md**

- Add `java-cli-base` to the template listing
- Add Java prerequisites (JDK 21+)
- Update the repository structure tree to show the java-cli-base directory
- Update the Quick Start to mention both templates

**Step 3: Commit**

```bash
git add justfile README.md
git commit -m "Update root justfile and README to include Java template"
git push
```

---

### Task 18: End-to-end test

**Step 1: Run the test script**

```bash
./tests/test-java-template.sh
```

Expected: All steps pass (generate, init, run, ci, ci-quiet, destroy).

**Step 2: Fix any issues**

If any step fails, read the error output, identify the root cause, fix the relevant template file, and re-run the test.

Common issues to watch for:
- Copier template variable resolution (especially `package_path` with dots-to-slashes)
- Gradle plugin version compatibility
- Checkstyle configuration compatibility with google-java-format output
- Semgrep rule syntax for Java patterns
- codespell/semgrep not being installed in the test environment

**Step 3: Final commit (if fixes were needed)**

```bash
git add -p  # Stage fixes selectively
git commit -m "Fix template issues found during integration testing"
git push
```
