# Default recipe: list all available recipes
_default:
    @just --list

# Show help message
help:
	@clear
	@echo ""
	@echo "Available recipes:"
	@echo "  just help    - Show this help message"
	@echo "  just init    - Install templates and set up aliases"
	@echo "  just update  - Update templates to latest version"
	@echo ""

# Install templates and set up aliases
init:
	@echo ""
	@echo "Checking prerequisites..."
	@echo ""
	@# Check for git
	@if ! command -v git >/dev/null 2>&1; then \
		echo "✗ Error: git is not installed"; \
		echo "  Please install git first: https://git-scm.com/downloads"; \
		echo ""; \
		exit 1; \
	fi
	@echo "✓ git is installed"
	@# Check for python
	@if ! command -v python3 >/dev/null 2>&1 && ! command -v python >/dev/null 2>&1; then \
		echo "✗ Error: python is not installed"; \
		echo "  Please install Python 3.12 or higher: https://www.python.org/downloads/"; \
		echo ""; \
		exit 1; \
	fi
	@echo "✓ python is installed"
	@# Check for uv
	@if ! command -v uv >/dev/null 2>&1; then \
		echo "✗ Error: uv is not installed"; \
		echo "  Please install uv: https://docs.astral.sh/uv/getting-started/installation/"; \
		echo "  Quick install: curl -LsSf https://astral.sh/uv/install.sh | sh"; \
		echo ""; \
		exit 1; \
	fi
	@echo "✓ uv is installed"
	@# Check for just
	@if ! command -v just >/dev/null 2>&1; then \
		echo "✗ Error: just is not installed"; \
		echo "  Please install just: https://github.com/casey/just#installation"; \
		echo ""; \
		exit 1; \
	fi
	@echo "✓ just is installed"
	@# Check for claude CLI
	@if ! command -v claude >/dev/null 2>&1; then \
		echo "✗ Error: claude CLI is not installed"; \
		echo "  Please install Claude Code: https://claude.com/claude-code"; \
		echo ""; \
		exit 1; \
	fi
	@echo "✓ claude CLI is installed"
	@echo ""
	@echo "All prerequisites met! Installing AI Templates..."
	@echo ""
	@./project-setup/setup_aliases.sh

# Update templates to latest version
update:
	@echo ""
	@echo "Updating AI Templates to latest version..."
	@echo ""
	@if ! command -v git >/dev/null 2>&1; then \
		echo "✗ Error: git is not installed"; \
		echo ""; \
		exit 1; \
	fi
	@git pull
	@if [ $$? -eq 0 ]; then \
		echo ""; \
		echo "✓ Templates updated successfully!"; \
		echo ""; \
	else \
		echo ""; \
		echo "✗ Failed to update templates"; \
		echo ""; \
		exit 1; \
	fi
