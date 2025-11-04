#!/bin/bash

# Check if path parameter is provided
if [ -z "$1" ]; then
  echo "Error: Project path parameter required"
  echo "Usage: $0 <path>"
  echo "  Use '.' for current directory"
  echo "  Use a name to create a new subdirectory"
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

# Download the Python setup template
echo "Downloading setup template..."
curl -o setup-project-python-claude.md \
  https://raw.githubusercontent.com/florianbuetow/ai-templates/main/project-setup/setup-project-python-claude.md

if [ $? -ne 0 ]; then
  echo "✗ Failed to download file"
  exit 1
fi

# Check if file exists
if [ ! -f setup-project-python-claude.md ]; then
  echo "✗ File does not exist after download"
  exit 1
fi

echo "✓ Downloaded setup-project-python-claude.md"

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
