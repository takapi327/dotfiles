# Claude Code設定情報

このプロジェクトはM1 Mac用のdotfiles管理リポジトリです。

## プロジェクト構成

- `.vimrc` - Neovim設定ファイル（プラグイン管理、キーマッピング、UI設定、~/.config/nvim/init.vimとしてシンボリックリンク）
- `.zshrc` - Zsh設定ファイル（既存設定を保持）
- `.zprofile` - Zshプロファイル設定
- `ghostty/` - Ghostty用設定ディレクトリ
  - `config` - Ghostty設定ファイル（Arthurテーマ、透過背景、画面分割キーバインド）
- `zellij/` - Zellij用設定ディレクトリ
  - `config.kdl` - Zellij設定ファイル（マウス対応、copy-on-select、キーバインド）
- `install.sh` - 自動インストールスクリプト

## 開発環境

- **OS**: macOS (M1 Mac)
- **Shell**: Zsh (Powerlevel9k theme)
- **エディタ**: Neovim (vim-plug)
- **ターミナル**: Ghostty
- **フォント**: Nerd Fonts (MesloLGS NF)
- **Python**: pyenv + pyenv-virtualenv
- **Node.js**: nodenv
- **Ruby**: rbenv
- **Scala**: sbt + Metals

## 主要な設定内容

### Neovim
- プラグイン管理: vim-plug
- ファイルエクスプローラー: nvim-tree
- ファジーファインダー: fzf, Telescope
- Git統合: fugitive, gitgutter
- 自動補完: nvim-cmp + nvim-lspconfig
- LSPサーバー管理: Mason (TypeScript, Terraform, JSON, Svelte, ESLint, SQL)
- Scala LSP: nvim-metals
- スニペット: LuaSnip + friendly-snippets
- カラースキーム: Gruvbox

### Zsh
- テーマ: Powerlevel9k
- プラグイン: git, zsh-syntax-highlighting, zsh-autosuggestions
- エイリアス: `claude` (claude-code), git shortcuts

## インストール手順

```bash
cd ~/Development/dotfiles
./install.sh
```

## 注意事項

- 既存のzsh設定は保持されています
- Homebrew、pyenv、nodenv、rbenvなどの設定も含まれています
- Ghostty設定は ~/.config/ghostty/config にコピーされます
- Zellij設定は ~/.config/zellij/config.kdl にコピーされます
- pyenvはPython 3.11を自動的にインストールし、グローバルバージョンとして設定します
- rbenvはRuby 3.2を自動的にインストールし、グローバルバージョンとして設定します
- nodenvはNode.js 22（最新版）を自動的にインストールし、グローバルバージョンとして設定します
