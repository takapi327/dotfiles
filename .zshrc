export PATH=$HOME/.nodebrew/current/bin:$PATH

export ZSH="/Users/takapi327/.oh-my-zsh"

ZSH_THEME="powerlevel9k/powerlevel9k"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source ~/.zplug/init.zsh

# cdを強化する
# https://github.com/b4b4r07/enhancd
zplug "b4b4r07/enhancd", use:init.sh


# zshテーマの設定
# powerline-fontを導入するのを忘れずに
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme, as:theme

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

# 補完の強化
zplug "zsh-users/zsh-completions"

# 履歴補完の強化
zplug ""

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# ここまでに書いたプラグインのロード
zplug load --verbose

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

### ここから下は環境設定 ###

### なんかiTerm2が勝手に書いたやつ ###
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
source  ~/powerlevel9k/powerlevel9k.zsh-theme

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
