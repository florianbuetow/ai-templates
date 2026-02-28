#!/usr/bin/env bash
# Test script for Go CLI template
# Tests the complete workflow: generate project, init, run, ci, ci-quiet, destroy

set -euo pipefail

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test configuration
PROJECT_NAME="test-go-project"

# Script directory and repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_PATH="$REPO_ROOT/blueprints/go-cli-base"

# Temp directory for test
TEMP_DIR=""

# Cleanup function
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

# Assertion helper
assert_success() {
    local step_name="$1"
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓ $step_name succeeded${NC}"
        return 0
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
        return 0
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
        return 0
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
        return 0
    else
        echo -e "${RED}✗ $description${NC}"
        echo -e "${RED}  Expected to find: '$expected'${NC}"
        echo -e "${RED}  In output: '$output'${NC}"
        exit 1
    fi
}

# Main test flow
main() {
    echo ""
    echo -e "${BLUE}=== Testing Go CLI Template ===${NC}"
    echo ""

    # Check prerequisites
    echo -e "${BLUE}=== Checking Prerequisites ===${NC}"

    if ! command -v copier >/dev/null 2>&1; then
        echo -e "${RED}✗ Error: copier is not installed${NC}"
        echo "  Install with: pip install copier"
        echo ""
        exit 1
    fi
    echo -e "${GREEN}✓ copier is installed${NC}"

    if ! command -v just >/dev/null 2>&1; then
        echo -e "${RED}✗ Error: just is not installed${NC}"
        echo "  Install from: https://github.com/casey/just#installation"
        echo ""
        exit 1
    fi
    echo -e "${GREEN}✓ just is installed${NC}"

    if ! command -v go >/dev/null 2>&1; then
        echo -e "${RED}✗ Error: go is not installed${NC}"
        echo "  Install from: https://go.dev/dl/"
        echo ""
        exit 1
    fi
    echo -e "${GREEN}✓ go is installed${NC}"
    echo ""

    # Create temp directory
    TEMP_DIR=$(mktemp -d)
    echo -e "${GREEN}✓ Created temp directory: $TEMP_DIR${NC}"
    echo ""

    # Generate project with copier
    echo -e "${BLUE}=== Step 1: Generating Project from Template ===${NC}"
    cd "$TEMP_DIR"

    copier copy --trust --defaults \
        --data project_name="$PROJECT_NAME" \
        --data module_path="github.com/test/test-go-project" \
        --data project_description="Test Go CLI application" \
        --data go_version=1.23 \
        --data author_name="Test Author" \
        --data author_email="test@example.com" \
        --data coverage_threshold=80 \
        "$TEMPLATE_PATH" "$PROJECT_NAME" 2>&1

    assert_success "Project generation"
    echo ""

    # Verify expected files exist
    echo -e "${BLUE}=== Verifying Generated Files ===${NC}"
    cd "$PROJECT_NAME"

    assert_file_exists "go.mod" "go.mod file"
    assert_file_exists ".golangci.yml" ".golangci.yml file"
    assert_file_exists "cmd/main.go" "cmd/main.go file"
    assert_file_exists "internal/app/app.go" "internal/app/app.go file"
    assert_file_exists "internal/app/app_test.go" "internal/app/app_test.go file"
    assert_file_exists "config/semgrep/no-error-swallowing.yml" "semgrep no-error-swallowing rule"
    assert_file_exists "config/semgrep/no-nolint-without-justification.yml" "semgrep no-nolint-without-justification rule"
    assert_file_exists "config/semgrep/no-init-functions.yml" "semgrep no-init-functions rule"
    assert_file_exists "config/semgrep/no-bare-return-in-error-func.yml" "semgrep no-bare-return-in-error-func rule"
    assert_file_exists "config/semgrep/no-build-ignore.yml" "semgrep no-build-ignore rule"
    assert_file_exists "config/codespell/ignore.txt" "codespell ignore.txt"
    assert_file_exists "justfile" "justfile"
    assert_file_exists "README.md" "README.md"
    assert_file_exists "AGENTS.md" "AGENTS.md"
    assert_file_exists "CLAUDE.md" "CLAUDE.md (symlink)"
    assert_file_exists ".gitignore" ".gitignore file"
    assert_file_exists ".semgrepignore" ".semgrepignore file"
    assert_file_exists ".pre-commit-config.yaml" ".pre-commit-config.yaml file"

    # Verify CLAUDE.md is a symlink to AGENTS.md
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

    # Step 2: Run just init
    echo -e "${BLUE}=== Step 2: Running 'just init' ===${NC}"
    just init
    assert_success "just init"
    echo ""

    # Step 3: Run just run
    echo -e "${BLUE}=== Step 3: Running 'just run' ===${NC}"
    OUTPUT=$(just run 2>&1)
    assert_success "just run"
    assert_output_contains "$OUTPUT" "Hello from $PROJECT_NAME!" "Correct output from main"
    echo ""

    # Step 4: Run just ci (verbose)
    echo -e "${BLUE}=== Step 4: Running 'just ci' (verbose) ===${NC}"
    just ci
    assert_success "just ci"
    echo ""

    # Step 5: Run just ci-quiet (silent)
    echo -e "${BLUE}=== Step 5: Running 'just ci-quiet' (silent) ===${NC}"
    just ci-quiet
    assert_success "just ci-quiet"
    echo ""

    # Step 6: Run just destroy
    echo -e "${BLUE}=== Step 6: Running 'just destroy' ===${NC}"
    just destroy
    assert_success "just destroy"

    # Verify reports/ was removed
    if [ ! -d "reports" ]; then
        echo -e "${GREEN}✓ reports/ directory was removed${NC}"
    else
        echo -e "${RED}✗ reports/ directory still exists after destroy${NC}"
        exit 1
    fi
    echo ""

    # Success!
    echo -e "${GREEN}=== All Tests Passed! ===${NC}"
    echo ""
}

# Run main function
main "$@"
