#!/bin/bash

# Dotfiles uninstallation script for M1 Mac
# This script removes symbolic links, packages, and configurations installed by install.sh

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "🗑️  Starting dotfiles uninstallation..."
echo ""
echo "⚠️  WARNING: This script will:"
echo "  - Remove dotfile symbolic links"
echo "  - Uninstall Homebrew packages"
echo "  - Remove development tools and environments"
echo "  - Remove application configurations"
echo ""
read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Uninstallation cancelled"
    exit 1
fi

# Function to remove symlink and restore backup if exists
remove_symlink() {
    local target="$1"
    local backup_pattern="$2"
    
    if [ -L "$target" ]; then
        echo "  🔗 Removing symlink: $target"
        rm -f "$target"
        
        # Look for most recent backup to restore
        if [ ! -z "$backup_pattern" ]; then
            LATEST_BACKUP=$(find "$HOME" -maxdepth 1 -name ".dotfiles_backup_*" -type d | sort | tail -1)
            if [ -d "$LATEST_BACKUP" ]; then
                BACKUP_FILE="$LATEST_BACKUP/$(basename "$target")"
                if [ -f "$BACKUP_FILE" ]; then
                    echo "    📁 Restoring backup: $BACKUP_FILE -> $target"
                    mv "$BACKUP_FILE" "$target"
                fi
            fi
        fi
    else
        echo "  ✓ $target is not a symlink or doesn't exist"
    fi
}

# Remove symlinks
echo "🔗 Removing dotfile symbolic links..."
remove_symlink "$HOME/.config/nvim/init.vim" ".vimrc"
remove_symlink "$HOME/.zshrc" ".zshrc"
remove_symlink "$HOME/.zprofile" ".zprofile"
remove_symlink "$HOME/.tmux.conf" ".tmux.conf"

# Remove empty directories
if [ -d "$HOME/.config/nvim" ] && [ -z "$(ls -A "$HOME/.config/nvim")" ]; then
    echo "  📁 Removing empty directory: $HOME/.config/nvim"
    rmdir "$HOME/.config/nvim"
fi

# Remove Neovim plugin directories
echo "📦 Removing Neovim plugins and configurations..."
if [ -d "$HOME/.local/share/nvim" ]; then
    echo "  🗑️  Removing $HOME/.local/share/nvim"
    rm -rf "$HOME/.local/share/nvim"
fi

if [ -d "$HOME/.vim" ]; then
    echo "  🗑️  Removing $HOME/.vim"
    rm -rf "$HOME/.vim"
fi

if [ -d "$HOME/.cache/nvim" ]; then
    echo "  🗑️  Removing $HOME/.cache/nvim"
    rm -rf "$HOME/.cache/nvim"
fi

# Remove version manager directories and configurations
echo "🐍 Cleaning up Python environment (pyenv)..."
if command -v pyenv &> /dev/null; then
    echo "  📂 Removing pyenv Python installations..."
    rm -rf "$HOME/.pyenv/versions"
    mkdir -p "$HOME/.pyenv/versions"
fi

echo "💎 Cleaning up Ruby environment (rbenv)..."
if command -v rbenv &> /dev/null; then
    echo "  📂 Removing rbenv Ruby installations..."
    rm -rf "$HOME/.rbenv/versions"
    mkdir -p "$HOME/.rbenv/versions"
fi

echo "🟢 Cleaning up Node.js environment (nodenv)..."
if command -v nodenv &> /dev/null; then
    echo "  📂 Removing nodenv Node.js installations..."
    rm -rf "$HOME/.nodenv/versions"
    mkdir -p "$HOME/.nodenv/versions"
fi

echo "🏗️  Cleaning up Terraform environment (tfenv)..."
if command -v tfenv &> /dev/null; then
    echo "  📂 Removing tfenv Terraform installations..."
    if [ -d "$HOME/.tfenv/versions" ]; then
        rm -rf "$HOME/.tfenv/versions"
        mkdir -p "$HOME/.tfenv/versions"
    fi
fi

# Remove Scala tools
echo "🔧 Removing Scala development tools..."
if command -v cs &> /dev/null; then
    echo "  🗑️  Removing Coursier applications..."
    if cs list | grep -q "metals" 2>/dev/null; then
        cs uninstall metals 2>/dev/null || true
    fi
    if cs list | grep -q "scalafmt" 2>/dev/null; then
        cs uninstall scalafmt 2>/dev/null || true
    fi
fi

# Remove Powerlevel9k theme
echo "🎨 Removing Powerlevel9k theme..."
POWERLEVEL9K_DIR="$HOME/Development/vim/powerlevel9k"
if [ -d "$POWERLEVEL9K_DIR" ]; then
    echo "  🗑️  Removing Powerlevel9k installation at $POWERLEVEL9K_DIR"
    rm -rf "$POWERLEVEL9K_DIR"
    echo "  ✅ Powerlevel9k removed"
else
    echo "  ✓ Powerlevel9k not found (already removed)"
fi

# Remove completions and configurations
echo "🔧 Removing shell completions and configurations..."
if [ -d "$HOME/.zsh/completions" ]; then
    echo "  🗑️  Removing $HOME/.zsh/completions"
    rm -rf "$HOME/.zsh/completions"
fi

if [ -f "$HOME/.fzf.zsh" ]; then
    echo "  🗑️  Removing $HOME/.fzf.zsh"
    rm -f "$HOME/.fzf.zsh"
fi

# Remove Ghostty config
echo "👻 Removing Ghostty configuration..."
GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
if [ -f "$GHOSTTY_CONFIG_DIR/config" ]; then
    echo "  🗑️  Removing Ghostty config"
    rm -f "$GHOSTTY_CONFIG_DIR/config"
    # Remove directory if empty
    if [ -d "$GHOSTTY_CONFIG_DIR" ] && [ -z "$(ls -A "$GHOSTTY_CONFIG_DIR")" ]; then
        rmdir "$GHOSTTY_CONFIG_DIR"
    fi
fi

# Remove MySQL Shell config directory (if empty)
if [ -d "$HOME/.mysqlsh" ] && [ -z "$(ls -A "$HOME/.mysqlsh")" ]; then
    echo "  📁 Removing empty MySQL Shell config directory"
    rmdir "$HOME/.mysqlsh"
fi

# Remove AWS Session Manager Plugin
echo "🔌 Removing AWS Session Manager Plugin..."
if command -v session-manager-plugin &> /dev/null; then
    echo "  Found Session Manager Plugin: $(session-manager-plugin --version 2>&1 | head -n 1)"
    echo "  This requires sudo access to remove system-level installation"

    # Remove the installation directory
    if [ -d "/usr/local/sessionmanagerplugin" ]; then
        echo "  🗑️  Removing /usr/local/sessionmanagerplugin (requires sudo)..."
        sudo rm -rf /usr/local/sessionmanagerplugin
        echo "  ✅ Removed installation directory"
    fi

    # Remove the binary symlink
    if [ -L "/usr/local/bin/session-manager-plugin" ] || [ -f "/usr/local/bin/session-manager-plugin" ]; then
        echo "  🗑️  Removing /usr/local/bin/session-manager-plugin (requires sudo)..."
        sudo rm -f /usr/local/bin/session-manager-plugin
        echo "  ✅ Removed binary"
    fi

    # Verify removal
    if ! command -v session-manager-plugin &> /dev/null; then
        echo "  ✅ AWS Session Manager Plugin successfully removed"
    else
        echo "  ⚠️  Session Manager Plugin may still be accessible from PATH"
    fi
else
    echo "  ✓ AWS Session Manager Plugin not found (already removed or not installed)"
fi

# Remove Terraform plugins directory (if empty)
if [ -d "$HOME/.terraform.d/plugins" ] && [ -z "$(ls -A "$HOME/.terraform.d/plugins")" ]; then
    echo "  📁 Removing empty Terraform plugins directory"
    rmdir "$HOME/.terraform.d/plugins"
fi
if [ -d "$HOME/.terraform.d" ] && [ -z "$(ls -A "$HOME/.terraform.d")" ]; then
    echo "  📁 Removing empty Terraform config directory"
    rmdir "$HOME/.terraform.d"
fi

# Remove mkcert local CA
echo "🔒 Removing mkcert local CA..."
if command -v mkcert &> /dev/null; then
    if mkcert -CAROOT &> /dev/null; then
        CA_ROOT=$(mkcert -CAROOT)
        if [ -d "$CA_ROOT" ]; then
            echo "  Found local CA at: $CA_ROOT"
            echo "  Uninstalling mkcert local CA..."
            mkcert -uninstall 2>/dev/null || true
            if [ -d "$CA_ROOT" ]; then
                echo "  🗑️  Removing CA directory..."
                rm -rf "$CA_ROOT"
            fi
            echo "  ✅ mkcert local CA removed"
        else
            echo "  ✓ mkcert local CA not found (already removed)"
        fi
    fi
else
    echo "  ✓ mkcert not found (already removed or not installed)"
fi

# Homebrew package removal
echo ""
echo "📦 Homebrew package removal options:"
echo "  1. Remove all packages installed by dotfiles"
echo "  2. Keep packages (manual cleanup required)"
echo "  3. Remove Homebrew entirely"
echo ""
read -p "Choose option (1/2/3): " -n 1 -r
echo

case $REPLY in
    1)
        echo "🗑️  Removing Homebrew packages..."
        
        # Essential tools
        brew_packages=(
            "neovim" "fzf" "ripgrep" "coreutils" "tmux" "git" "jq" "yq"
            "htop" "tree" "wget" "gh" "sbt" "coursier/formulas/coursier"
            "pyenv" "pyenv-virtualenv" "rbenv" "ruby-build" "nodenv" "node-build"
            "awscli" "aws-sam-cli" "mysql-shell" "mysql-client" "mkcert" "nss" "tfenv"
        )
        
        # Docker tools
        docker_tools=("docker-compose" "docker-credential-helper" "lazydocker" "dive")
        
        # Productivity apps
        productivity_apps=("deepl" "claude-code")
        
        all_packages=("${brew_packages[@]}" "${docker_tools[@]}")
        
        for package in "${all_packages[@]}"; do
            if brew list "$package" &>/dev/null; then
                echo "  🗑️  Uninstalling $package..."
                brew uninstall "$package" 2>/dev/null || true
            fi
        done
        
        # Remove cask applications
        for app in "${productivity_apps[@]}"; do
            if brew list --cask "$app" &>/dev/null 2>&1; then
                echo "  🗑️  Uninstalling cask $app..."
                brew uninstall --cask "$app" 2>/dev/null || true
            fi
        done
        
        # Remove Docker Desktop
        if [ -d "/Applications/Docker.app" ]; then
            echo "  🗑️  Uninstalling Docker Desktop..."
            brew uninstall --cask docker 2>/dev/null || true
        fi
        
        # Remove Java (Amazon Corretto)
        if brew list --cask corretto@21 &>/dev/null; then
            echo "  🗑️  Uninstalling Amazon Corretto 21..."
            brew uninstall --cask corretto@21 2>/dev/null || true
        fi
        
        # Remove Ghostty
        if brew list --cask ghostty &>/dev/null; then
            echo "  🗑️  Uninstalling Ghostty..."
            brew uninstall --cask ghostty 2>/dev/null || true
        fi
        
        # Remove Nerd Font
        if brew list --cask font-meslo-lg-nerd-font &>/dev/null; then
            echo "  🗑️  Uninstalling Nerd Font..."
            brew uninstall --cask font-meslo-lg-nerd-font 2>/dev/null || true
        fi
        
        # Remove Powerline Source Code Pro font
        POWERLINE_FONT_PATH="$HOME/Library/Fonts/SourceCodePro+Powerline+Awesome+Regular.ttf"
        if [ -f "$POWERLINE_FONT_PATH" ]; then
            echo "  🗑️  Removing Powerline Source Code Pro font..."
            rm -f "$POWERLINE_FONT_PATH"
        fi
        
        # Clean up Homebrew
        echo "  🧹 Running Homebrew cleanup..."
        brew cleanup 2>/dev/null || true
        brew autoremove 2>/dev/null || true
        ;;
    2)
        echo "  ✓ Keeping Homebrew packages (you can remove them manually later)"
        ;;
    3)
        echo "🗑️  Removing Homebrew entirely..."
        if command -v brew &> /dev/null; then
            echo "  This will remove Homebrew and all installed packages!"
            read -p "Are you sure? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
                echo "  ✅ Homebrew removed"
            else
                echo "  ❌ Homebrew removal cancelled"
            fi
        else
            echo "  ✓ Homebrew not found"
        fi
        ;;
    *)
        echo "  ✓ Keeping Homebrew packages"
        ;;
esac

# Clean up shell configurations
echo ""
echo "🐚 Cleaning up shell configurations..."
echo "  ℹ️  Manually remove the following lines from your shell configuration files:"
echo ""
echo "From ~/.zshrc or ~/.zprofile:"
echo "  - Homebrew configuration lines"
echo "  - pyenv, rbenv, nodenv initialization lines"
echo "  - Docker completion lines" 
echo "  - Custom aliases added by dotfiles"
echo ""

# Remove backup directories
echo "📁 Cleaning up backup directories..."
BACKUP_DIRS=$(find "$HOME" -maxdepth 1 -name ".dotfiles_backup_*" -type d 2>/dev/null || true)
if [ ! -z "$BACKUP_DIRS" ]; then
    echo "  Found backup directories:"
    echo "$BACKUP_DIRS" | while read -r backup_dir; do
        echo "    📁 $backup_dir"
    done
    echo ""
    read -p "Remove all backup directories? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "$BACKUP_DIRS" | while read -r backup_dir; do
            echo "  🗑️  Removing $backup_dir"
            rm -rf "$backup_dir"
        done
        echo "  ✅ Backup directories removed"
    else
        echo "  ✓ Keeping backup directories"
    fi
else
    echo "  ✓ No backup directories found"
fi

# Final cleanup
echo ""
echo "🧹 Final cleanup..."

# Remove temporary files
rm -f "/tmp/.homebrew_updated_"* 2>/dev/null || true

echo ""
echo "✨ Uninstallation complete!"
echo ""
echo "📝 Manual cleanup required:"
echo "  1. Review and clean up ~/.zshrc and ~/.zprofile manually"
echo "  2. Remove any remaining configuration directories you don't need"
echo "  3. Restart your terminal to reload shell configuration"
echo ""
echo "💡 Note:"
echo "  - Your original dotfiles have been restored from backup where possible"
echo "  - Language runtime versions have been removed but tools remain installed"
echo "  - Some system configurations may need manual reset"
echo ""

# Make uninstall script executable
chmod +x "$DOTFILES_DIR/uninstall.sh"