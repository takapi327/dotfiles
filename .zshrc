export LANG=ja_JP.UTF-8

export XDG_CONFIG_HOME=$HOME/.config
export TERM=screen-256color
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

# Python/pyenv設定
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"

# Go用
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

### テーマの設定 ###
POWERLEVEL9K_MODE="nerdfont-complete"

#### macコピペ ####
POWERLEVEL9K_CUSTOM_WIFI_SIGNAL="zsh_wifi_signal"
POWERLEVEL9K_CUSTOM_WIFI_SIGNAL_BACKGROUND="white"
POWERLEVEL9K_CUSTOM_WIFI_SIGNAL_FOREGROUND="black"

# アイコン表示
POWERLEVEL9K_OS_ICON_BACKGROUND='234'

# user情報
POWERLEVEL9K_CONTEXT_TEMPLATE='%n'
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND='013'
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND='235'

# 表示するもの
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context battery dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)

# バッテリー表示  
POWERLEVEL9K_BATTERY_ICON='\uf1e6 '
POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND='230'
POWERLEVEL9K_BATTERY_CHARGING_BACKGROUND='236'
POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND='005'
POWERLEVEL9K_BATTERY_CHARGED_BACKGROUND='236'
POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND='075'
POWERLEVEL9K_BATTERY_DISCONNECTED_BACKGROUND='236'
POWERLEVEL9K_BATTERY_LOW_THRESHOLD='10'
POWERLEVEL9K_BATTERY_LOW_COLOR='red'
POWERLEVEL9K_BATTERY_VERBOSE='false' # バッテリー横の時間を非表示

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{014}\u2570%F{cyan}\uF460%F{073}\uF460%F{109}\uF460%f "

# リポジトリ表示
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='130'
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='238'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='130'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='238'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='130'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='238'
POWERLEVEL9K_VCS_UNTRACKED_ICON='*'

# ディレクトリ表示
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_DIR_HOME_FOREGROUND='166'
POWERLEVEL9K_DIR_HOME_BACKGROUND='237'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='166'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='237'
POWERLEVEL9K_DIR_ETC_FOREGROUND='166'
POWERLEVEL9K_DIR_ETC_BACKGROUND='237'
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='001'
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='237'

# 状態表示
POWERLEVEL9K_STATUS_VERBOSE=true
POWERLEVEL9K_STATUS_CROSS=true
POWERLEVEL9K_STATUS_OK_FOREGROUND='123'
POWERLEVEL9K_STATUS_OK_BACKGROUND='234'
POWERLEVEL9K_STATUS_ERROR_BACKGROUND='234'

# 現在時刻表示
POWERLEVEL9K_TIME_FORMAT="%D{\uf017 %H:%M \uf073 %d/%m/%y}"
POWERLEVEL9K_TIME_FOREGROUND='013'
POWERLEVEL9K_TIME_BACKGROUND='235'

POWERLEVEL9K_RAM_BACKGROUND='yellow'
POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND="white"
POWERLEVEL9K_LOAD_WARNING_BACKGROUND="white"
POWERLEVEL9K_LOAD_NORMAL_BACKGROUND="white"
POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND="red"
POWERLEVEL9K_LOAD_WARNING_FOREGROUND="yellow"
POWERLEVEL9K_LOAD_NORMAL_FOREGROUND="black"
POWERLEVEL9K_LOAD_CRITICAL_VISUAL_IDENTIFIER_COLOR="red"
POWERLEVEL9K_LOAD_WARNING_VISUAL_IDENTIFIER_COLOR="yellow"
POWERLEVEL9K_LOAD_NORMAL_VISUAL_IDENTIFIER_COLOR="#FF570D"
POWERLEVEL9K_HOME_ICON=''
POWERLEVEL9K_HOME_SUB_ICON=''
POWERLEVEL9K_FOLDER_ICON=''
POWERLEVEL9K_STATUS_VERBOSE=true
POWERLEVEL9K_STATUS_CROSS=true
####
##################

#####################################################
################# ここから下はzshの設定 ################
#####################################################

# 入力した文字から始まるコマンドを履歴から検索し、上下矢印で補完
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# 他のzshと履歴を共有
setopt share_history

# 選択されたテキストの背景色を変更し、ハイライトする
zstyle ':completion:*:default' menu select=2

# パスを直接入力してもcdする
setopt AUTO_CD

# 環境変数を補完
setopt AUTO_PARAM_KEYS

### 永続的なalias ###
alias ls="gls --color=auto"
alias la="ls -la"
alias tmux="tmux -2"
alias vi='nvim'
### git コマンド ###
alias ga='git add'
alias gc-b='git checkout -b'
alias gm='git commit -m'
alias gp='git push -u origin'
alias gd='git diff'
alias gs='git status'

alias ll='ls -l'

# MySQL aliases
alias sql='mysql -u root -p'
alias mysqlsh='mysqlsh --sql'
alias msh='mysqlsh'
alias mshjs='mysqlsh --js'
alias mshpy='mysqlsh --py'
alias mshdump='mysqlsh --util dumpInstance'

# Claude Code用のalias
alias cc='claude-code'

# Docker aliases
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dimg='docker images'
alias dexec='docker exec -it'
alias dlog='docker logs -f'
alias dprune='docker system prune -a'
alias dc='docker-compose'
alias dcup='docker-compose up -d'
alias dcdown='docker-compose down'
alias dclog='docker-compose logs -f'
alias ld='lazydocker'

# AWS aliases
alias awsp='aws --profile'
alias awsl='aws configure list-profiles'
alias awsw='aws sts get-caller-identity'

### ここから下は環境設定 ###

# Powerlevel9k theme
source  ~/Development/vim/powerlevel9k/powerlevel9k.zsh-theme

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="/opt/homebrew/opt/mysql@5.7/bin:$PATH"

# Java用
export JAVA_HOME=`/usr/libexec/java_home -v "21"`
export PATH=$JAVA_HOME/bin/:$PATH

# pnpm
export PNPM_HOME="/Users/takapi327/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Node.js/nodenv設定
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

# bun completions
[ -s "/Users/takapi327/.bun/_bun" ] && source "/Users/takapi327/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# GPG
export GPG_TTY=${TTY}

# Ruby/rbenv設定
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
    . $HOME/.nix-profile/etc/profile.d/nix.sh;
fi
