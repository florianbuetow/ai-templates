#!/bin/bash

set -e  # Exit on error

echo ""
echo "Setting up Python project setup alias..."
echo ""

# Repository configuration
REPO_URL="https://github.com/florianbuetow/ai-templates.git"
TEMPLATES_DIR="$HOME/scripts/ai-templates"
SETUP_SCRIPT="$TEMPLATES_DIR/project-setup/setup-project-python-claude.sh"

# Create ~/scripts directory if it doesn't exist
echo "Creating ~/scripts directory..."
mkdir -p ~/scripts
echo "✓ Directory created/verified: ~/scripts"
echo ""

# Clone or update the repository
if [ -d "$TEMPLATES_DIR/.git" ]; then
  echo "Updating existing ai-templates repository..."
  cd "$TEMPLATES_DIR"
  git pull --quiet
  echo "✓ Repository updated"
  echo ""
else
  echo "Cloning ai-templates repository to ~/scripts/ai-templates..."
  git clone --quiet "$REPO_URL" "$TEMPLATES_DIR"
  echo "✓ Repository cloned"
  echo ""
fi

# Verify the setup script exists
if [ ! -f "$SETUP_SCRIPT" ]; then
  echo "✗ Error: setup-project-python-claude.sh not found in cloned repository"
  exit 1
fi

# Make the setup script executable
chmod +x "$SETUP_SCRIPT"

# Detect the user's shell
USER_SHELL=$(basename "$SHELL")
echo "Detected shell: $USER_SHELL"
echo ""

# Determine the correct RC file based on shell
RC_FILE=""
case "$USER_SHELL" in
  zsh)
    RC_FILE="$HOME/.zshrc"
    ;;
  bash)
    # Prefer .bashrc, fall back to .bash_profile
    if [ -f "$HOME/.bashrc" ]; then
      RC_FILE="$HOME/.bashrc"
    else
      RC_FILE="$HOME/.bash_profile"
    fi
    ;;
  fish)
    RC_FILE="$HOME/.config/fish/config.fish"
    ;;
  *)
    echo "✗ Unsupported shell: $USER_SHELL"
    echo "Please manually add the following aliases to your shell configuration:"
    echo ""
    echo "alias newpy='~/scripts/ai-templates/project-setup/setup-project-python-claude.sh'"
    echo "alias update-templates='cd ~/scripts/ai-templates && git pull && cd - > /dev/null'"
    echo ""
    exit 1
    ;;
esac

echo "Using RC file: $RC_FILE"
echo ""

# Check if alias already exists
if grep -q "alias newpy=" "$RC_FILE" 2>/dev/null; then
  echo "⚠ Alias 'newpy' already exists in $RC_FILE"
  echo "Skipping alias addition to avoid duplicates."
  echo ""
  echo "If you want to update it, please edit $RC_FILE manually."
  echo ""
else
  # Add alias to RC file
  echo "Adding 'newpy' alias to $RC_FILE..."

  # Add a newline before the comment if the file exists and doesn't end with a newline
  if [ -f "$RC_FILE" ] && [ -n "$(tail -c 1 "$RC_FILE")" ]; then
    echo "" >> "$RC_FILE"
  fi

  cat >> "$RC_FILE" << 'EOF'
# Aliases for AI project templates
alias newpy='~/scripts/ai-templates/project-setup/setup-project-python-claude.sh'
alias update-templates='cd ~/scripts/ai-templates && git pull && cd - > /dev/null'
EOF

  echo "✓ Aliases added successfully"
  echo ""
fi

echo "================================================"
echo "Setup complete!"
echo "================================================"
echo ""
echo "To start using the aliases:"
echo ""
echo "  1. Reload your shell configuration:"
echo "     source $RC_FILE"
echo ""
echo "  2. Create a new Python project:"
echo "     newpy my-project-name"
echo ""
echo "  3. Update templates to latest version:"
echo "     update-templates"
echo ""
echo "Or simply open a new terminal window."
echo ""
