#!/bin/bash

# Dotfiles installation script for M1 Mac
# This script creates symbolic links for dotfiles and sets up development environment

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "🚀 Starting dotfiles installation..."

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Check if target already points to the correct source
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        echo "  ✓ $target already linked correctly"
        return
    fi
    
    # If target exists but is not the correct symlink, back it up
    if [ -e "$target" ] || [ -L "$target" ]; then
        # Create backup directory only when needed
        if [ -z "$BACKUP_DIR_CREATED" ]; then
            BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
            mkdir -p "$BACKUP_DIR"
            echo "📁 Backup directory created: $BACKUP_DIR"
            BACKUP_DIR_CREATED=1
        fi
        echo "  Backing up existing $target to $BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
    fi
    
    ln -sf "$source" "$target"
    echo "✅ Linked $source -> $target"
}

# Create necessary directories
echo "📁 Creating necessary directories..."
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.vim/autoload"

# Symlink dotfiles
echo "🔗 Creating symbolic links..."
create_symlink "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/.zprofile" "$HOME/.zprofile"

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "🍺 Installing Homebrew..."
    
    # Check for required tools
    if ! command -v curl &> /dev/null; then
        echo "❌ Error: curl is required to install Homebrew"
        exit 1
    fi
    
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Determine Homebrew path based on architecture
    if [ -d "/opt/homebrew" ]; then
        # Apple Silicon Mac
        BREW_PREFIX="/opt/homebrew"
    elif [ -d "/usr/local/Homebrew" ]; then
        # Intel Mac
        BREW_PREFIX="/usr/local"
    else
        echo "❌ Error: Could not find Homebrew installation"
        exit 1
    fi
    
    # Add Homebrew to PATH for current session
    eval "$($BREW_PREFIX/bin/brew shellenv)"
    
    # Add Homebrew to shell profile if not already present
    BREW_SHELLENV_CMD="eval \"\$($BREW_PREFIX/bin/brew shellenv)\""
    
    # Add to .zprofile for zsh login shells
    if ! grep -q "$BREW_PREFIX/bin/brew shellenv" "$HOME/.zprofile" 2>/dev/null; then
        echo "# Homebrew configuration" >> "$HOME/.zprofile"
        echo "$BREW_SHELLENV_CMD" >> "$HOME/.zprofile"
        echo "  ✓ Added Homebrew to .zprofile"
    fi
    
    # Add to .zshrc for interactive shells (if not sourcing .zprofile)
    if ! grep -q "$BREW_PREFIX/bin/brew shellenv" "$HOME/.zshrc" 2>/dev/null && \
       ! grep -q "source.*\.zprofile" "$HOME/.zshrc" 2>/dev/null; then
        echo "" >> "$HOME/.zshrc"
        echo "# Homebrew configuration" >> "$HOME/.zshrc"
        echo "$BREW_SHELLENV_CMD" >> "$HOME/.zshrc"
        echo "  ✓ Added Homebrew to .zshrc"
    fi
    
    echo "✅ Homebrew installed successfully"
else
    echo "✓ Homebrew already installed"
    
    # Ensure Homebrew is in current PATH even if already installed
    if [ -d "/opt/homebrew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -d "/usr/local/Homebrew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# Update Homebrew (only if not updated recently)
echo "📦 Checking Homebrew..."
BREW_UPDATE_MARKER="/tmp/.homebrew_updated_$(date +%Y%m%d)"
if [ ! -f "$BREW_UPDATE_MARKER" ]; then
    echo "  Updating Homebrew..."
    brew update
    touch "$BREW_UPDATE_MARKER"
else
    echo "  ✓ Homebrew already updated today"
fi

# Upgrade existing packages (optional, can be commented out if not desired)
# echo "📦 Upgrading Homebrew packages..."
# brew upgrade

# Install essential tools
echo "📦 Installing essential tools..."
brew_packages=(
    "neovim"
    "fzf"
    "ripgrep"
    "coreutils"
    "tmux"
    "git"
    "jq"
    "yq"
    "htop"
    "tree"
    "wget"
    "gh"
    "sbt"
    "coursier/formulas/coursier"
)

for package in "${brew_packages[@]}"; do
    if brew list "$package" &>/dev/null; then
        echo "  ✓ $package already installed"
    else
        echo "  Installing $package..."
        brew install "$package"
    fi
done

# Install Nerd Font
echo "🔤 Installing Nerd Font..."
if ! brew tap | grep -q "homebrew/cask-fonts"; then
    brew tap homebrew/cask-fonts
fi

if brew list --cask font-meslo-lg-nerd-font &>/dev/null; then
    echo "  ✓ Nerd Font already installed"
else
    echo "  Installing Nerd Font..."
    brew install --cask font-meslo-lg-nerd-font
fi

# Install Docker and related tools
echo "🐳 Installing Docker..."

# Check if Docker Desktop is installed
if [ -d "/Applications/Docker.app" ]; then
    echo "  ✓ Docker Desktop already installed"
else
    echo "  Installing Docker Desktop..."
    brew install --cask docker
    echo "  ✅ Docker Desktop installed"
    echo "  ⚠️  Please launch Docker Desktop from Applications to complete setup"
fi

# Install Docker-related CLI tools
echo "🔧 Installing Docker CLI tools..."
docker_tools=(
    "docker-compose"
    "docker-credential-helper"
    "lazydocker"
)

for tool in "${docker_tools[@]}"; do
    if brew list "$tool" &>/dev/null; then
        echo "  ✓ $tool already installed"
    else
        echo "  Installing $tool..."
        brew install "$tool"
    fi
done

# Install container-related tools
echo "📦 Installing container tools..."
container_tools=(
    "dive"
)

for tool in "${container_tools[@]}"; do
    if brew list "$tool" &>/dev/null; then
        echo "  ✓ $tool already installed"
    else
        echo "  Installing $tool..."
        brew install "$tool"
    fi
done

# Add Docker completion to zsh (if docker is running)
if command -v docker &> /dev/null; then
    # Create completion directory if it doesn't exist
    mkdir -p "$HOME/.zsh/completions"
    
    # Add Docker completions
    if [ ! -f "$HOME/.zsh/completions/_docker" ]; then
        echo "  Adding Docker zsh completions..."
        docker completion zsh > "$HOME/.zsh/completions/_docker" 2>/dev/null || true
    fi
    
    # Add docker-compose completions
    if [ ! -f "$HOME/.zsh/completions/_docker-compose" ]; then
        echo "  Adding docker-compose zsh completions..."
        curl -L https://raw.githubusercontent.com/docker/compose/master/contrib/completion/zsh/_docker-compose -o "$HOME/.zsh/completions/_docker-compose" 2>/dev/null || true
    fi
    
    # Ensure completions are loaded in zshrc
    if ! grep -q "fpath.*\.zsh/completions" "$HOME/.zshrc" 2>/dev/null; then
        echo "" >> "$HOME/.zshrc"
        echo "# Docker completions" >> "$HOME/.zshrc"
        echo "fpath=(~/.zsh/completions \$fpath)" >> "$HOME/.zshrc"
        if ! grep -q "autoload -Uz compinit && compinit" "$HOME/.zshrc" 2>/dev/null; then
            echo "autoload -Uz compinit && compinit" >> "$HOME/.zshrc"
        fi
    fi
fi

# Install productivity apps
echo "🛠️ Installing productivity apps..."

# DeepL
if [ -d "/Applications/DeepL.app" ]; then
    echo "  ✓ DeepL already installed"
else
    echo "  Installing DeepL..."
    brew install --cask deepl
    echo "  ✅ DeepL installed"
fi

# Other useful apps
productivity_apps=(
    "rectangle"  # Window management
    "alt-tab"    # Better app switcher
    "raycast"    # Spotlight replacement
    "stats"      # System monitor in menu bar
)

for app in "${productivity_apps[@]}"; do
    if brew list --cask "$app" &>/dev/null 2>&1; then
        echo "  ✓ $app already installed"
    else
        echo "  Installing $app..."
        brew install --cask "$app"
    fi
done

# Install vim-plug
echo "🔌 Installing vim-plug..."
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "  ✅ vim-plug installed"
else
    echo "  ✓ vim-plug already installed"
fi

# Install Vim plugins
echo "📦 Installing Vim plugins..."
if [ -f "$HOME/.vim/autoload/plug.vim" ] && [ -f "$HOME/.vimrc" ]; then
    vim +PlugInstall +qall 2>/dev/null || true
else
    echo "  ⚠️  Skipping Vim plugin installation (vim-plug or .vimrc not found)"
fi

# Install fzf key bindings and completion
echo "🔍 Setting up fzf..."
if [ -f "$HOME/.fzf.zsh" ]; then
    echo "  ✓ fzf key bindings already configured"
else
    if [ -f "/opt/homebrew/opt/fzf/install" ]; then
        yes | /opt/homebrew/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish 2>/dev/null || true
    elif [ -f "/usr/local/opt/fzf/install" ]; then
        yes | /usr/local/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish 2>/dev/null || true
    fi
    
    if [ -f "$HOME/.fzf.zsh" ]; then
        echo "  ✅ fzf key bindings configured"
    else
        echo "  ⚠️  fzf key bindings configuration failed"
    fi
fi

# Install Scala development tools
echo "🔧 Setting up Scala development tools..."
if command -v cs &> /dev/null; then
    if cs list | grep -q "metals" 2>/dev/null; then
        echo "  ✓ Metals already installed"
    else
        echo "  Installing Metals..."
        cs install metals
        echo "  ✅ Metals installed"
    fi
    
    # Install scalafmt
    if cs list | grep -q "scalafmt" 2>/dev/null; then
        echo "  ✓ scalafmt already installed"
    else
        echo "  Installing scalafmt..."
        cs install scalafmt
        echo "  ✅ scalafmt installed"
    fi
else
    echo "  ⚠️  Coursier not found, skipping Scala tools installation"
fi

# iTerm2 configuration
echo "🖥️  Configuring iTerm2..."

# Dynamic Profiles method - automatically loads profiles
DYNAMIC_PROFILES_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
if [ -f "$DOTFILES_DIR/iterm2/profiles.json" ]; then
    mkdir -p "$DYNAMIC_PROFILES_DIR"
    
    # Copy profile to DynamicProfiles directory
    cp "$DOTFILES_DIR/iterm2/profiles.json" "$DYNAMIC_PROFILES_DIR/dotfiles-profile.json"
    echo "  ✅ iTerm2 profile installed automatically"
    
    # Check if iTerm2 is running
    if pgrep -q "iTerm2"; then
        echo "  ℹ️  Profile 'M1 Mac Development' is now available in iTerm2"
        echo "     To set as default: Preferences → Profiles → Select 'M1 Mac Development' → Set as Default"
    else
        echo "  ℹ️  Profile will be available when you launch iTerm2"
    fi
else
    echo "  ⚠️  iTerm2 profile not found at $DOTFILES_DIR/iterm2/profiles.json"
fi

# Check Docker Desktop status
if [ -d "/Applications/Docker.app" ]; then
    if pgrep -q "Docker Desktop"; then
        echo "✅ Docker Desktop is running"
    else
        echo "⚠️  Docker Desktop is installed but not running"
        echo "   Please launch Docker Desktop from Applications"
    fi
fi

# Final instructions
echo ""
echo "✨ Dotfiles installation complete!"
echo ""
echo "📝 Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. If Docker was just installed, launch Docker Desktop from Applications"
echo "  3. Install any additional language-specific tools (pyenv, nodenv, etc.)"
echo ""
echo "💡 Tips:"
echo "  - Use 'cc' as an alias for claude-code"
echo "  - Leader key in Vim is set to <Space>"
echo "  - Use 'lazydocker' for Docker container management"
echo "  - DeepL: Set up keyboard shortcuts in System Preferences → Keyboard → Shortcuts"
echo "  - Rectangle: Use for window management (⌃⌥ + arrows)"
echo "  - Raycast: Replace Spotlight with ⌘Space"
echo "  - Check CLAUDE.md for more information about this setup"

# Make install script executable
chmod +x "$DOTFILES_DIR/install.sh"
