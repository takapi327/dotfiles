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
# Create Neovim config directory
mkdir -p "$HOME/.config/nvim"
create_symlink "$DOTFILES_DIR/.vimrc" "$HOME/.config/nvim/init.vim"
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/.zprofile" "$HOME/.zprofile"
# Zellij config
mkdir -p "$HOME/.config/zellij"
if [ -f "$DOTFILES_DIR/zellij/config.kdl" ]; then
    cp "$DOTFILES_DIR/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"
    echo "✅ Zellij config installed"
fi

# Zellij layouts
if [ -d "$DOTFILES_DIR/zellij/layouts" ]; then
    mkdir -p "$HOME/.config/zellij/layouts"
    for layout in "$DOTFILES_DIR/zellij/layouts/"*; do
        if [ -f "$layout" ]; then
            layout_name=$(basename "$layout")
            # __HOME__ プレースホルダーを実際のホームディレクトリに置換
            sed "s|__HOME__|$HOME|g" "$layout" > "$HOME/.config/zellij/layouts/$layout_name"
        fi
    done
    echo "✅ Zellij layouts installed"
fi

# Custom scripts (bin directory)
if [ -d "$DOTFILES_DIR/bin" ]; then
    mkdir -p "$HOME/.local/bin"
    for script in "$DOTFILES_DIR/bin/"*; do
        if [ -f "$script" ]; then
            script_name=$(basename "$script")
            ln -sf "$script" "$HOME/.local/bin/$script_name"
            chmod +x "$HOME/.local/bin/$script_name"
        fi
    done
    echo "✅ Custom scripts installed to ~/.local/bin"
fi

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
    "zellij"
    "git"
    "jq"
    "yq"
    "htop"
    "tree"
    "wget"
    "gh"
    "lazygit"
    "k1LoW/tap/git-wt"
    "sbt"
    "coursier/formulas/coursier"
    "pyenv"
    "pyenv-virtualenv"
    "rbenv"
    "ruby-build"
    "nodenv"
    "node-build"
    "awscli"
    "aws-sam-cli"
    "mysql-shell"
    "mysql-client"
    "mkcert"
    "nss"
    "tfenv"
    "hashicorp/tap/terraform-ls"
)

# Handle coursier version conflict
if brew list coursier &>/dev/null 2>&1; then
    # Check if it's the old version (not from coursier/formulas)
    if ! brew list coursier/formulas/coursier &>/dev/null 2>&1; then
        echo "  Uninstalling old coursier version..."
        brew uninstall coursier 2>/dev/null || true
    fi
fi

for package in "${brew_packages[@]}"; do
    if brew list "$package" &>/dev/null; then
        echo "  ✓ $package already installed"
    else
        echo "  Installing $package..."
        brew install "$package"
    fi
done

# Ensure tfenv is properly linked
if brew list tfenv &>/dev/null; then
    if ! command -v tfenv &> /dev/null; then
        echo "  Linking tfenv..."
        # Unlink conflicting packages if they exist
        if brew list terraform &>/dev/null 2>&1; then
            echo "  Unlinking conflicting terraform package..."
            brew unlink terraform 2>/dev/null || true
        fi
        brew link tfenv
        echo "  ✅ tfenv linked successfully"
    fi
fi

# Configure git-wt
if command -v git-wt &> /dev/null; then
    echo "🌳 Configuring git-wt..."
    # worktreeをプロジェクト内の.worktreesディレクトリに格納
    git config --global wt.basedir ".worktrees"

    # グローバルgitignoreで.worktreesを除外
    GLOBAL_GITIGNORE="$HOME/.config/git/ignore"
    mkdir -p "$(dirname "$GLOBAL_GITIGNORE")"
    git config --global core.excludesfile "$GLOBAL_GITIGNORE"
    if ! grep -q "^\.worktrees/$" "$GLOBAL_GITIGNORE" 2>/dev/null; then
        echo ".worktrees/" >> "$GLOBAL_GITIGNORE"
        echo "  ✅ Added .worktrees/ to global gitignore"
    fi

    echo "  ✅ git-wt configured (basedir: .worktrees)"
fi

# Install Nerd Font
echo "🔤 Installing Nerd Font..."

# Check if MesloLGS Nerd Font is already installed (file-based check)
NERD_FONT_INSTALLED=false
if ls "$HOME/Library/Fonts/"*"MesloLGS"*"Nerd"* 2>/dev/null | head -1 >/dev/null; then
    echo "  ✓ MesloLGS Nerd Font already installed"
    NERD_FONT_INSTALLED=true
elif brew list --cask font-meslo-lg-nerd-font &>/dev/null; then
    echo "  ✓ Nerd Font already installed via Homebrew"
    NERD_FONT_INSTALLED=true
fi

if [ "$NERD_FONT_INSTALLED" = false ]; then
    echo "  Installing MesloLGS Nerd Font..."
    if brew install --cask font-meslo-lg-nerd-font; then
        echo "  ✅ MesloLGS Nerd Font installed successfully"
    else
        echo "  ⚠️  Failed to install via Homebrew, trying direct download..."
        
        # Fallback: Direct download from Nerd Fonts repository
        NERD_FONT_DIR="$HOME/Library/Fonts"
        mkdir -p "$NERD_FONT_DIR"
        
        echo "  Downloading MesloLGS Nerd Font files..."
        NERD_FONT_BASE_URL="https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Meslo/S/Regular/MesloLGSNerdFont-Regular.ttf"
        
        if curl -fL "$NERD_FONT_BASE_URL" -o "$NERD_FONT_DIR/MesloLGSNerdFont-Regular.ttf"; then
            echo "  ✅ MesloLGS Nerd Font downloaded and installed"
        else
            echo "  ⚠️  Failed to download Nerd Font. Powerlevel9k will use Powerline mode."
        fi
    fi
fi

# Install Powerline Source Code Pro font
echo "🔤 Installing Powerline Source Code Pro font..."
POWERLINE_FONT_URL="https://raw.githubusercontent.com/Falkor/dotfiles/master/fonts/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf"
FONT_NAME="SourceCodePro+Powerline+Awesome+Regular.ttf"
FONT_DIR="$HOME/Library/Fonts"
FONT_PATH="$FONT_DIR/$FONT_NAME"

if [ -f "$FONT_PATH" ]; then
    echo "  ✓ Powerline Source Code Pro font already installed"
else
    echo "  Downloading and installing Powerline Source Code Pro font..."
    mkdir -p "$FONT_DIR"
    
    if curl -fL "$POWERLINE_FONT_URL" -o "$FONT_PATH"; then
        echo "  ✅ Powerline Source Code Pro font installed"
        echo "    Font location: $FONT_PATH"
    else
        echo "  ⚠️  Failed to download Powerline Source Code Pro font"
    fi
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

# Install Claude Code
echo "🤖 Installing Claude Code..."
if command -v claude &> /dev/null; then
    echo "  ✓ Claude Code already installed"
    echo "  Version: $(claude --version 2>/dev/null || echo 'Unknown')"
else
    echo "  Installing Claude Code via Homebrew..."
    if brew install --cask claude-code; then
        echo "  ✅ Claude Code installed successfully"
        echo "  To get started: Run 'claude doctor' to verify installation"
        echo "  Authentication: Run 'claude' in any project directory to set up"
    else
        echo "  ⚠️  Homebrew installation failed, trying universal installer..."
        if curl -fsSL https://claude.ai/install.sh | bash; then
            echo "  ✅ Claude Code installed via universal installer"
        else
            echo "  ❌ Failed to install Claude Code"
            echo "     Please visit https://code.claude.com/docs/ja/setup for manual installation"
        fi
    fi
fi

# Install claude-dev wrapper script
echo "🔧 Installing Claude Code wrapper script..."
if [ -f "$DOTFILES_DIR/bin/claude-dev" ]; then
    mkdir -p "$HOME/.local/bin"
    cp "$DOTFILES_DIR/bin/claude-dev" "$HOME/.local/bin/claude-dev"
    chmod +x "$HOME/.local/bin/claude-dev"
    echo "  ✅ claude-dev wrapper installed to ~/.local/bin"

    # Ensure ~/.local/bin is in PATH
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        if ! grep -q 'export PATH="$PATH:.*\.local/bin"' "$HOME/.zshrc" 2>/dev/null; then
            echo "" >> "$HOME/.zshrc"
            echo '# User local bin' >> "$HOME/.zshrc"
            echo 'export PATH="$PATH:$HOME/.local/bin"' >> "$HOME/.zshrc"
            echo "  ✅ Added ~/.local/bin to PATH in .zshrc"
        fi
    fi
else
    echo "  ⚠️  bin/claude-dev not found, skipping wrapper installation"
fi

# Install Claude Code Hooks
echo "🪝 Installing Claude Code Hooks..."
if [ -d "$DOTFILES_DIR/.claude" ]; then
    # Create ~/.claude directory if it doesn't exist
    mkdir -p "$HOME/.claude"

    # Copy hooks directory
    if [ -d "$DOTFILES_DIR/.claude/hooks" ]; then
        mkdir -p "$HOME/.claude/hooks"
        cp -r "$DOTFILES_DIR/.claude/hooks/"* "$HOME/.claude/hooks/"
        chmod +x "$HOME/.claude/hooks/"*.sh
        echo "  ✅ Claude Code hooks installed to ~/.claude/hooks"
    fi

    # Merge settings.json
    if [ -f "$DOTFILES_DIR/.claude/settings.json" ]; then
        if [ -f "$HOME/.claude/settings.json" ]; then
            echo "  ℹ️  Existing ~/.claude/settings.json found"
            echo "  Merging hooks configuration..."

            # Backup existing settings
            cp "$HOME/.claude/settings.json" "$HOME/.claude/settings.json.backup"

            # Merge using jq if available
            if command -v jq &> /dev/null; then
                jq -s '.[0] * .[1]' "$HOME/.claude/settings.json" "$DOTFILES_DIR/.claude/settings.json" > "$HOME/.claude/settings.json.tmp"
                mv "$HOME/.claude/settings.json.tmp" "$HOME/.claude/settings.json"
                echo "  ✅ Settings merged (backup saved as settings.json.backup)"
            else
                echo "  ⚠️  jq not available, copying settings directly (existing settings backed up)"
                cp "$DOTFILES_DIR/.claude/settings.json" "$HOME/.claude/settings.json"
            fi
        else
            cp "$DOTFILES_DIR/.claude/settings.json" "$HOME/.claude/settings.json"
            echo "  ✅ Claude Code settings installed to ~/.claude/settings.json"
        fi
    fi

    echo "  ℹ️  Claude Code Hooks configured:"
    echo "     - Notification: Desktop notifications for permission prompts and idle states"
    echo "     - Stop: Notification when Claude finishes a task"
else
    echo "  ⚠️  .claude directory not found, skipping hooks installation"
fi

# Other useful apps
productivity_apps=()

for app in "${productivity_apps[@]}"; do
    if brew list --cask "$app" &>/dev/null 2>&1; then
        echo "  ✓ $app already installed"
    else
        echo "  Installing $app..."
        brew install --cask "$app"
    fi
done

# Install vim-plug for Neovim
echo "🔌 Installing vim-plug for Neovim..."
NVIM_AUTOLOAD_DIR="$HOME/.local/share/nvim/site/autoload"
if [ ! -f "$NVIM_AUTOLOAD_DIR/plug.vim" ]; then
    curl -fLo "$NVIM_AUTOLOAD_DIR/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "  ✅ vim-plug for Neovim installed"
else
    echo "  ✓ vim-plug for Neovim already installed"
fi

# Install Neovim plugins
echo "📦 Installing Neovim plugins..."
if [ -f "$NVIM_AUTOLOAD_DIR/plug.vim" ] && [ -f "$HOME/.vimrc" ]; then
    echo "  Installing plugins with nvim..."
    nvim +PlugInstall +qall 2>/dev/null || true
    
    # Install CoC extensions for TypeScript and Svelte
    echo "  Installing CoC extensions..."
    nvim -c "CocInstall -sync coc-tsserver coc-eslint coc-prettier coc-json coc-svelte" -c "qall" 2>/dev/null || true
    echo "  ✅ CoC TypeScript and Svelte extensions installed"
else
    echo "  ⚠️  Skipping Neovim plugin installation (vim-plug or .vimrc not found)"
fi

# Install Powerlevel9k theme
echo "🎨 Setting up Powerlevel9k theme..."
POWERLEVEL9K_DIR="$HOME/Development/vim/powerlevel9k"

# Use Git clone method (official recommended way for vanilla zsh)
if [ ! -d "$POWERLEVEL9K_DIR" ]; then
    echo "  Installing Powerlevel9k via Git clone (official method)..."
    mkdir -p "$HOME/Development/vim"
    git clone https://github.com/bhilburn/powerlevel9k.git "$POWERLEVEL9K_DIR"
    echo "  ✅ Powerlevel9k installed from official repository"
else
    echo "  ✓ Powerlevel9k already installed"
    
    # Update existing installation
    echo "  Updating Powerlevel9k..."
    cd "$POWERLEVEL9K_DIR"
    git pull origin master 2>/dev/null || true
    echo "  ✅ Powerlevel9k updated"
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

# Install Java (Amazon Corretto)
echo "☕ Installing Java (Amazon Corretto)..."
if ! java -version &>/dev/null || ! java -version 2>&1 | grep -q "Corretto.*21"; then
    if brew list --cask corretto@21 &>/dev/null; then
        echo "  ✓ Amazon Corretto 21 already installed"
    else
        echo "  Installing Amazon Corretto 21..."
        brew install --cask corretto@21
        echo "  ✅ Amazon Corretto 21 installed"
    fi
    
    # Set JAVA_HOME for current session
    if JAVA_HOME_TEMP=$(/usr/libexec/java_home -v 21 2>/dev/null); then
        export JAVA_HOME="$JAVA_HOME_TEMP"
        export PATH="$JAVA_HOME/bin:$PATH"
        echo "  ✅ Java 21 configured: $JAVA_HOME"
        echo "  Java version: $(java -version 2>&1 | head -n 1)"
    else
        echo "  ⚠️  Failed to configure Java 21"
    fi
else
    echo "  ✓ Amazon Corretto 21 already installed"
    echo "  Java version: $(java -version 2>&1 | head -n 1)"
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

# Setup Python with pyenv
echo "🐍 Setting up Python development environment..."
if command -v pyenv &> /dev/null; then
    echo "  ✓ pyenv is installed"
    
    # Install Python build dependencies
    echo "  Installing Python build dependencies..."
    python_deps=(
        "openssl"
        "readline"
        "sqlite3"
        "xz"
        "zlib"
        "tcl-tk"
    )
    
    for dep in "${python_deps[@]}"; do
        if brew list "$dep" &>/dev/null 2>&1; then
            echo "    ✓ $dep already installed"
        else
            echo "    Installing $dep..."
            brew install "$dep"
        fi
    done
    
    # Install latest stable Python versions
    PYTHON_LATEST_38=$(pyenv install -l | grep -E "^\s*3\.8\.[0-9]+$" | tail -1 | xargs)
    PYTHON_LATEST_39=$(pyenv install -l | grep -E "^\s*3\.9\.[0-9]+$" | tail -1 | xargs)
    PYTHON_LATEST_310=$(pyenv install -l | grep -E "^\s*3\.10\.[0-9]+$" | tail -1 | xargs)
    PYTHON_LATEST_311=$(pyenv install -l | grep -E "^\s*3\.11\.[0-9]+$" | tail -1 | xargs)
    PYTHON_LATEST_312=$(pyenv install -l | grep -E "^\s*3\.12\.[0-9]+$" | tail -1 | xargs)
    
    # Install Python 3.11 as default (stable for most projects)
    if [ ! -z "$PYTHON_LATEST_311" ]; then
        if pyenv versions | grep -q "$PYTHON_LATEST_311"; then
            echo "  ✓ Python $PYTHON_LATEST_311 already installed"
        else
            echo "  Installing Python $PYTHON_LATEST_311..."
            pyenv install "$PYTHON_LATEST_311"
            echo "  ✅ Python $PYTHON_LATEST_311 installed"
        fi
        
        # Set global Python version
        echo "  Setting Python $PYTHON_LATEST_311 as global version..."
        pyenv global "$PYTHON_LATEST_311"
        
        # Upgrade pip and install essential packages
        echo "  Upgrading pip and installing essential packages..."
        eval "$(pyenv init -)"
        pip install --upgrade pip
        pip install pipenv poetry virtualenv black flake8 pylint mypy
        echo "  ✅ Python development tools installed"
    else
        echo "  ⚠️  Could not find Python 3.11 version to install"
    fi
else
    echo "  ⚠️  pyenv not found, skipping Python setup"
fi

# Setup Ruby with rbenv
echo "💎 Setting up Ruby development environment..."
if command -v rbenv &> /dev/null; then
    echo "  ✓ rbenv is installed"
    
    # Install Ruby build dependencies
    echo "  Installing Ruby build dependencies..."
    ruby_deps=(
        "openssl@3"
        "readline"
        "libyaml"
        "gmp"
    )
    
    for dep in "${ruby_deps[@]}"; do
        if brew list "$dep" &>/dev/null 2>&1; then
            echo "    ✓ $dep already installed"
        else
            echo "    Installing $dep..."
            brew install "$dep"
        fi
    done
    
    # Install additional build dependencies for macOS
    echo "  Installing additional build dependencies..."
    build_deps=(
        "pkg-config"
        "autoconf"
        "automake"
        "libtool"
    )
    
    for dep in "${build_deps[@]}"; do
        if brew list "$dep" &>/dev/null 2>&1; then
            echo "    ✓ $dep already installed"
        else
            echo "    Installing $dep..."
            brew install "$dep"
        fi
    done
    
    # Use a stable Ruby version that works well with current macOS
    RUBY_TARGET_VERSION="3.1.6"
    
    # Check if target Ruby version is available
    if rbenv install -l | grep -q "^\s*$RUBY_TARGET_VERSION\s*$"; then
        if rbenv versions | grep -q "$RUBY_TARGET_VERSION"; then
            echo "  ✓ Ruby $RUBY_TARGET_VERSION already installed"
        else
            echo "  Installing Ruby $RUBY_TARGET_VERSION (stable version for macOS)..."
            
            # Set build flags for macOS compatibility
            export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3) --with-readline-dir=$(brew --prefix readline) --with-libyaml-dir=$(brew --prefix libyaml) --with-gmp-dir=$(brew --prefix gmp) --disable-install-doc"
            
            if rbenv install "$RUBY_TARGET_VERSION"; then
                echo "  ✅ Ruby $RUBY_TARGET_VERSION installed"
            else
                echo "  ⚠️  Failed to install Ruby $RUBY_TARGET_VERSION"
                echo "  Trying with system Ruby..."
                RUBY_TARGET_VERSION="system"
            fi
        fi
        
        if [ "$RUBY_TARGET_VERSION" != "system" ]; then
            # Set global Ruby version
            echo "  Setting Ruby $RUBY_TARGET_VERSION as global version..."
            rbenv global "$RUBY_TARGET_VERSION"
            
            # Install essential Ruby gems
            echo "  Installing essential Ruby gems..."
            eval "$(rbenv init -)"
            gem install bundler
            gem install rails
            gem install rubocop
            gem install solargraph
            gem install pry
            gem install rspec
            rbenv rehash
            echo "  ✅ Ruby development tools installed"
        fi
    else
        echo "  ⚠️  Ruby $RUBY_TARGET_VERSION not available in rbenv"
    fi
else
    echo "  ⚠️  rbenv not found, skipping Ruby setup"
fi

# Setup Node.js with nodenv
echo "🟢 Setting up Node.js development environment..."
if command -v nodenv &> /dev/null; then
    echo "  ✓ nodenv is installed"
    
    # Install latest stable Node.js versions
    NODE_LATEST_18=$(nodenv install -l | grep -E "^\s*18\.[0-9]+\.[0-9]+$" | grep -v - | tail -1 | xargs)
    NODE_LATEST_20=$(nodenv install -l | grep -E "^\s*20\.[0-9]+\.[0-9]+$" | grep -v - | tail -1 | xargs)
    NODE_LATEST_22=$(nodenv install -l | grep -E "^\s*22\.[0-9]+\.[0-9]+$" | grep -v - | tail -1 | xargs)
    
    # Install Node.js 22 as default (latest)
    if [ ! -z "$NODE_LATEST_22" ]; then
        if nodenv versions | grep -q "$NODE_LATEST_22"; then
            echo "  ✓ Node.js $NODE_LATEST_22 already installed"
        else
            echo "  Installing Node.js $NODE_LATEST_22..."
            nodenv install "$NODE_LATEST_22"
            echo "  ✅ Node.js $NODE_LATEST_22 installed"
        fi
        
        # Set global Node.js version
        echo "  Setting Node.js $NODE_LATEST_22 as global version..."
        nodenv global "$NODE_LATEST_22"
        
        # Install global npm packages
        echo "  Installing essential npm packages..."
        eval "$(nodenv init -)"
        
        # Update npm itself
        npm install -g npm@latest
        
        # Install common global packages
        npm install -g yarn
        npm install -g pnpm
        npm install -g typescript
        npm install -g ts-node
        npm install -g nodemon
        npm install -g eslint
        npm install -g prettier
        npm install -g npm-check-updates
        
        # Rehash to register new executables
        nodenv rehash
        
        echo "  ✅ Node.js development tools installed"
    else
        echo "  ⚠️  Could not find Node.js 22 version to install"
    fi
else
    echo "  ⚠️  nodenv not found, skipping Node.js setup"
fi

# Install Ghostty
echo "👻 Installing Ghostty..."
if [ -d "/Applications/Ghostty.app" ]; then
    echo "  ✓ Ghostty already installed"
else
    echo "  Installing Ghostty..."
    brew install --cask ghostty
    echo "  ✅ Ghostty installed"
fi

# Ghostty configuration
echo "👻 Configuring Ghostty..."

# Ghostty config directory
GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
if [ -f "$DOTFILES_DIR/ghostty/config" ]; then
    mkdir -p "$GHOSTTY_CONFIG_DIR"

    # Copy config file
    cp "$DOTFILES_DIR/ghostty/config" "$GHOSTTY_CONFIG_DIR/config"
    echo "  ✅ Ghostty config installed"
    echo "  ℹ️  Config location: $GHOSTTY_CONFIG_DIR/config"
    echo "  ℹ️  Reload config with Cmd+Shift+, or restart Ghostty"
else
    echo "  ⚠️  Ghostty config not found at $DOTFILES_DIR/ghostty/config"
fi
# Claude Code configuration
echo "🤖 Configuring Claude Code hooks..."
CLAUDE_CONFIG_DIR="$HOME/.claude"
CLAUDE_HOOKS_SRC="$DOTFILES_DIR/.claude/hooks"
CLAUDE_HOOKS_DST="$CLAUDE_CONFIG_DIR/hooks"
CLAUDE_SETTINGS_SRC="$DOTFILES_DIR/.claude/settings.json"
CLAUDE_SETTINGS_DST="$CLAUDE_CONFIG_DIR/settings.json"

if [ -d "$CLAUDE_HOOKS_SRC" ]; then
    # Create Claude config directory
    mkdir -p "$CLAUDE_CONFIG_DIR"

    # Copy hooks directory
    mkdir -p "$CLAUDE_HOOKS_DST"
    cp -r "$CLAUDE_HOOKS_SRC/"* "$CLAUDE_HOOKS_DST/"
    chmod +x "$CLAUDE_HOOKS_DST/"*.sh 2>/dev/null || true
    echo "  ✅ Claude Code hooks installed to $CLAUDE_HOOKS_DST"

    # Merge settings.json
    if [ -f "$CLAUDE_SETTINGS_SRC" ]; then
        if [ -f "$CLAUDE_SETTINGS_DST" ]; then
            # Existing settings found - merge with jq
            echo "  Merging Claude Code settings..."

            # Create backup
            cp "$CLAUDE_SETTINGS_DST" "$CLAUDE_SETTINGS_DST.bak"

            # Deep merge: existing settings + new hooks
            # This preserves existing keys and adds/updates hooks
            if command -v jq &> /dev/null; then
                jq -s '.[0] * .[1]' "$CLAUDE_SETTINGS_DST.bak" "$CLAUDE_SETTINGS_SRC" > "$CLAUDE_SETTINGS_DST.tmp"
                mv "$CLAUDE_SETTINGS_DST.tmp" "$CLAUDE_SETTINGS_DST"
                echo "  ✅ Claude Code settings merged (backup: $CLAUDE_SETTINGS_DST.bak)"
            else
                echo "  ⚠️  jq not found, copying settings (may overwrite existing)"
                cp "$CLAUDE_SETTINGS_SRC" "$CLAUDE_SETTINGS_DST"
            fi
        else
            # No existing settings - just copy
            cp "$CLAUDE_SETTINGS_SRC" "$CLAUDE_SETTINGS_DST"
            echo "  ✅ Claude Code settings installed"
        fi

        # Update hook paths to use home directory
        if command -v jq &> /dev/null; then
            # Use jq to update command paths to absolute paths
            jq --arg hooks_dir "$CLAUDE_HOOKS_DST" '
              .hooks.Notification[0].hooks[0].command = ($hooks_dir + "/ghostty-notify.sh") |
              .hooks.Stop[0].hooks[0].command = ($hooks_dir + "/ghostty-stop-notify.sh")
            ' "$CLAUDE_SETTINGS_DST" > "$CLAUDE_SETTINGS_DST.tmp" && mv "$CLAUDE_SETTINGS_DST.tmp" "$CLAUDE_SETTINGS_DST"
            echo "  ✅ Hook paths updated for global use"
        fi
    fi

    echo "  ℹ️  Hooks will be active on next Claude Code session"
    echo "  ℹ️  View hooks with: claude then /hooks"
else
    echo "  ⚠️  Claude Code hooks not found at $CLAUDE_HOOKS_SRC"
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
echo "  1. Launch Ghostty from Applications folder"
echo "  2. Restart your terminal or run: source ~/.zshrc"
echo "  3. Set up Claude Code authentication: Run 'claude' in any project directory"
echo "  4. If Docker was just installed, launch Docker Desktop from Applications"
echo "  5. Install any additional language-specific tools (pyenv, nodenv, etc.)"
echo ""
echo "💡 Tips:"
echo "  - Use 'claude' command to start Claude Code in any project"
echo "  - Run 'claude doctor' to verify installation and check health"
echo "  - Leader key in Neovim is set to <Space>"
echo "  - Use 'lazygit' for Git operations in terminal UI"
echo "  - Use 'lazydocker' for Docker container management"
echo "  - DeepL: Set up keyboard shortcuts in System Preferences → Keyboard → Shortcuts"
echo "  - zellij: Press Ctrl+p then d for pane mode, Ctrl+t for tab mode"
echo "  - zellij: Mouse support enabled, copy on select enabled"
echo "  - Check CLAUDE.md for more information about this setup"
echo ""
echo "🔤 Font Setup:"
echo "  - Ghostty has built-in Nerd Font support"
echo "  - For full Powerlevel9k icon support, add 'font-family = MesloLGS NF' to Ghostty config"
echo "  - Config location: ~/.config/ghostty/config"

# Setup AWS CLI
echo "☁️  Setting up AWS CLI..."
if command -v aws &> /dev/null; then
    echo "  ✓ AWS CLI is installed"
    echo "  Version: $(aws --version)"
    
    # Check if AWS credentials are configured
    if [ -d "$HOME/.aws" ] && [ -f "$HOME/.aws/credentials" ]; then
        echo "  ✓ AWS credentials already configured"
    else
        echo "  ℹ️  AWS credentials not configured"
        echo "     Run 'aws configure' to set up your credentials"
    fi
else
    echo "  ⚠️  AWS CLI not found"
fi

# Check SAM CLI
if command -v sam &> /dev/null; then
    echo "  ✓ AWS SAM CLI is installed"
    echo "  Version: $(sam --version)"
else
    echo "  ⚠️  AWS SAM CLI not found"
fi

# Install AWS Session Manager Plugin
echo "🔌 Installing AWS Session Manager Plugin..."
if command -v session-manager-plugin &> /dev/null; then
    echo "  ✓ AWS Session Manager Plugin is already installed"
    echo "  Version: $(session-manager-plugin --version 2>&1 | head -n 1)"
else
    echo "  Downloading AWS Session Manager Plugin..."

    # Create temporary directory for download
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"

    # Download the plugin
    if curl -fL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "sessionmanager-bundle.zip"; then
        echo "  Download completed"

        # Unzip the bundle
        echo "  Extracting files..."
        if unzip -q sessionmanager-bundle.zip; then
            echo "  Installing Session Manager Plugin (requires sudo)..."

            # Run the installer with sudo
            if sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin; then
                echo "  ✅ AWS Session Manager Plugin installed successfully"

                # Verify installation
                if command -v session-manager-plugin &> /dev/null; then
                    echo "  Version: $(session-manager-plugin --version 2>&1 | head -n 1)"
                fi
            else
                echo "  ⚠️  Failed to install Session Manager Plugin"
            fi
        else
            echo "  ⚠️  Failed to extract sessionmanager-bundle.zip"
        fi
    else
        echo "  ⚠️  Failed to download Session Manager Plugin"
    fi

    # Clean up temporary files
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
    echo "  Cleaned up temporary files"
fi

echo "  ℹ️  To use AWS Session Manager:"
echo "     aws ssm start-session --target <instance-id>"
echo "     aws ssm start-session --target <instance-id> --document-name AWS-StartPortForwardingSession --parameters 'portNumber=3306,localPortNumber=13306'"

# Setup MySQL Shell
echo "🗄️  Setting up MySQL Shell..."
if command -v mysqlsh &> /dev/null; then
    echo "  ✓ MySQL Shell is installed"
    echo "  Version: $(mysqlsh --version)"
    
    # Create MySQL Shell config directory if it doesn't exist
    MYSQLSH_CONFIG_DIR="$HOME/.mysqlsh"
    if [ ! -d "$MYSQLSH_CONFIG_DIR" ]; then
        mkdir -p "$MYSQLSH_CONFIG_DIR"
        echo "  Created MySQL Shell config directory: $MYSQLSH_CONFIG_DIR"
    fi
    
    echo "  ℹ️  To connect to MySQL:"
    echo "     mysqlsh -u username -h hostname -P port"
    echo "     or use: mysqlsh --uri username@hostname:port/database"
else
    echo "  ⚠️  MySQL Shell not found"
fi

# Setup MySQL CLI
echo "🗄️  Setting up MySQL CLI..."
if brew list mysql-client &>/dev/null; then
    echo "  ✓ MySQL CLI is installed"

    # mysql-client is keg-only, so we need to add it to PATH
    MYSQL_CLIENT_PATH="$(brew --prefix)/opt/mysql-client/bin"

    # Check if mysql command is available
    if command -v mysql &> /dev/null; then
        echo "  ✓ mysql command is already available in PATH"
        echo "  Version: $(mysql --version)"
    else
        echo "  ⚠️  mysql command not in PATH, adding to shell configuration..."

        # Add MySQL client to PATH in .zshrc if not already present
        if ! grep -q "mysql-client/bin" "$HOME/.zshrc" 2>/dev/null; then
            echo "" >> "$HOME/.zshrc"
            echo "# MySQL Client configuration" >> "$HOME/.zshrc"
            echo "export PATH=\"$MYSQL_CLIENT_PATH:\$PATH\"" >> "$HOME/.zshrc"
            echo "  ✅ Added MySQL client to .zshrc"
        fi

        # Add to current session
        export PATH="$MYSQL_CLIENT_PATH:$PATH"

        if command -v mysql &> /dev/null; then
            echo "  ✅ mysql command is now available"
            echo "  Version: $(mysql --version)"
        fi
    fi

    echo "  ℹ️  To connect to MySQL:"
    echo "     mysql -u username -h hostname -P port -p"
    echo "     or use: mysql --host=hostname --port=port --user=username --password database"
else
    echo "  ⚠️  MySQL CLI not found"
fi

# Setup mkcert for local HTTPS development
echo "🔒 Setting up mkcert for local HTTPS development..."
if command -v mkcert &> /dev/null; then
    echo "  ✓ mkcert is installed"
    echo "  Version: $(mkcert -version 2>&1 | head -n 1)"

    # Check if local CA is already installed
    if mkcert -CAROOT &> /dev/null; then
        CA_ROOT=$(mkcert -CAROOT)
        if [ -f "$CA_ROOT/rootCA.pem" ]; then
            echo "  ✓ Local CA already installed at: $CA_ROOT"
        else
            echo "  Installing local CA for mkcert..."
            mkcert -install
            echo "  ✅ Local CA installed successfully"
            echo "  CA Root: $(mkcert -CAROOT)"
        fi
    else
        echo "  Installing local CA for mkcert..."
        mkcert -install
        echo "  ✅ Local CA installed successfully"
        echo "  CA Root: $(mkcert -CAROOT)"
    fi

    echo "  ℹ️  To create a certificate for localhost:"
    echo "     mkcert localhost 127.0.0.1 ::1"
    echo "  ℹ️  To create a certificate for a custom domain:"
    echo "     mkcert example.test '*.example.test'"
else
    echo "  ⚠️  mkcert not found"
fi

# Setup Terraform with tfenv
echo "🏗️  Setting up Terraform with tfenv..."
if command -v tfenv &> /dev/null; then
    echo "  ✓ tfenv is installed"

    # Check if any Terraform version is installed
    if tfenv list 2>/dev/null | grep -q "No versions"; then
        echo "  Installing latest Terraform version..."
        tfenv install latest
        tfenv use latest
        echo "  ✅ Terraform installed via tfenv"
    elif tfenv list 2>/dev/null | grep -q "*"; then
        echo "  ✓ Terraform already installed via tfenv"
        CURRENT_VERSION=$(tfenv list 2>/dev/null | grep "*" | awk '{print $2}')
        echo "  Current version: $CURRENT_VERSION"
    else
        # tfenv is installed but no version is set as current
        INSTALLED_VERSIONS=$(tfenv list 2>/dev/null | head -1 | awk '{print $1}')
        if [ ! -z "$INSTALLED_VERSIONS" ]; then
            echo "  Setting Terraform version..."
            tfenv use $INSTALLED_VERSIONS
            echo "  ✅ Terraform version set: $INSTALLED_VERSIONS"
        else
            echo "  Installing latest Terraform version..."
            tfenv install latest
            tfenv use latest
            echo "  ✅ Terraform installed via tfenv"
        fi
    fi

    # Verify terraform command is available
    if command -v terraform &> /dev/null; then
        echo "  Terraform version: $(terraform version | head -n 1)"
    fi

    # Check if Terraform plugins directory exists
    TERRAFORM_PLUGIN_DIR="$HOME/.terraform.d/plugins"
    if [ ! -d "$TERRAFORM_PLUGIN_DIR" ]; then
        mkdir -p "$TERRAFORM_PLUGIN_DIR"
        echo "  Created Terraform plugins directory: $TERRAFORM_PLUGIN_DIR"
    fi

    echo "  ℹ️  tfenv commands:"
    echo "     tfenv list              - List installed Terraform versions"
    echo "     tfenv list-remote       - List available Terraform versions"
    echo "     tfenv install <version> - Install a specific Terraform version"
    echo "     tfenv use <version>     - Switch to a specific Terraform version"
    echo ""
    echo "  ℹ️  Terraform commands:"
    echo "     terraform init          - Initialize a Terraform working directory"
    echo "     terraform plan          - Generate and show an execution plan"
    echo "     terraform apply         - Build or change infrastructure"
    echo "     terraform destroy       - Destroy Terraform-managed infrastructure"
    echo "     terraform validate      - Validate the Terraform files"
else
    echo "  ⚠️  tfenv not found"
fi

# Install Nix
echo "❄️  Installing Nix..."
if command -v nix &> /dev/null; then
    echo "  ✓ Nix already installed"
    echo "  Version: $(nix --version)"
else
    echo "  Installing Nix (multi-user/daemon mode)..."

    # Nix公式インストーラ（macOSではマルチユーザーモードが推奨）
    if sh <(curl -L https://nixos.org/nix/install) --daemon; then
        # 現在のセッションでNixを有効化
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
            . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi

        if command -v nix &> /dev/null; then
            echo "  ✅ Nix installed successfully"
            echo "  Version: $(nix --version)"
        else
            echo "  ✅ Nix installed (restart terminal to use)"
        fi
    else
        echo "  ⚠️  Failed to install Nix"
        echo "     Please visit https://nixos.org/download for manual installation"
    fi
fi

echo "  ℹ️  Nix commands:"
echo "     nix-env -iA nixpkgs.<package>  - Install a package"
echo "     nix-env -q                     - List installed packages"
echo "     nix-env -e <package>           - Uninstall a package"
echo "     nix-channel --update           - Update channels"
echo "     nix-shell -p <package>         - Temporary shell with package"

# Make install script executable
chmod +x "$DOTFILES_DIR/install.sh"
