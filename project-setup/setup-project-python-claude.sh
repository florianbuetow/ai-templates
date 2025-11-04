#!/bin/bash

# Check if path parameter is provided
if [ -z "$1" ]; then
  echo "Error: Project path parameter required"
  echo "Usage: $0 <path>"
  echo "  Use '.' for current directory"
  echo "  Use a name to create a new subdirectory"
  exit 1
fi

# Check if claude CLI is available
if ! command -v claude >/dev/null 2>&1; then
  echo "✗ Error: claude CLI is not installed"
  echo "  Please install Claude Code: https://claude.com/claude-code"
  exit 1
fi

PROJECT_PATH="$1"

# If path is not current directory, create it and cd into it
if [ "$PROJECT_PATH" != "." ]; then
  mkdir -p "$PROJECT_PATH"
  if [ $? -ne 0 ]; then
    echo "✗ Failed to create directory: $PROJECT_PATH"
    exit 1
  fi
  cd "$PROJECT_PATH"
  echo "✓ Created and entered directory: $PROJECT_PATH"
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_FILE="$SCRIPT_DIR/setup-project-python-claude.md"

# Check if template file exists locally
if [ ! -f "$TEMPLATE_FILE" ]; then
  echo "✗ Template file not found: $TEMPLATE_FILE"
  echo "Please run setup_aliases.sh to install the templates repository."
  exit 1
fi

# Copy the Python setup template to current directory
echo "Copying setup template from local repository..."
cp "$TEMPLATE_FILE" setup-project-python-claude.md

if [ $? -ne 0 ]; then
  echo "✗ Failed to copy template file"
  exit 1
fi

echo "✓ Copied setup-project-python-claude.md"

# Run Claude with the setup instructions
echo "Running Claude to set up the project..."
claude "Follow the setup instructions in setup-project-python-claude.md to the teeth."

if [ $? -ne 0 ]; then
  echo "✗ Claude command failed"
  exit 1
fi

# Delete the setup file
rm setup-project-python-claude.md
if [ $? -eq 0 ]; then
  echo "✓ Cleaned up setup-project-python-claude.md"
else
  echo "⚠ Warning: Failed to delete setup-project-python-claude.md"
fi

echo "✓ Project setup complete!"
