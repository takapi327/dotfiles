# Claude Code設定情報

このプロジェクトはM1 Mac用のdotfiles管理リポジトリです。

## プロジェクト構成

- `.vimrc` - Vim設定ファイル（プラグイン管理、キーマッピング、UI設定）
- `.zshrc` - Zsh設定ファイル（既存設定を保持）
- `.zprofile` - Zshプロファイル設定
- `iterm2/` - iTerm2用設定ディレクトリ
  - `profiles.json` - iTerm2プロファイル（Gruvboxテーマ、Nerd Font設定）
  - `README.md` - iTerm2設定手順
- `install.sh` - 自動インストールスクリプト

## 開発環境

- **OS**: macOS (M1 Mac)
- **Shell**: Zsh (Powerlevel9k theme)
- **エディタ**: Vim/Neovim (vim-plug)
- **ターミナル**: iTerm2
- **フォント**: Nerd Fonts (MesloLGS NF)

## 主要な設定内容

### Vim
- プラグイン管理: vim-plug
- ファイルエクスプローラー: NERDTree
- ファジーファインダー: fzf
- Git統合: fugitive, gitgutter
- 自動補完: CoC.nvim
- カラースキーム: Gruvbox

### Zsh
- テーマ: Powerlevel9k
- プラグイン: git, zsh-syntax-highlighting, zsh-autosuggestions
- エイリアス: `cc` (claude-code), git shortcuts

## インストール手順

```bash
cd ~/Development/dotfiles
./install.sh
```

## 注意事項

- 既存のzsh設定は保持されています
- Homebrew、pyenv、nodenv、rbenvなどの設定も含まれています
- iTerm2プロファイルは手動でインポートが必要です