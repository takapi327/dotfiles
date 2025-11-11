# M1 Mac Dotfiles

vim + iTerm2 + Claude Code向けの効率的な開発環境設定ファイル集です。

## 特徴

- 🚀 M1 Mac最適化済み
- 🎨 Gruvboxカラーテーマ
- ⚡ Vim (vim-plug) + Neovim対応
- 🔧 既存のzsh設定を保持
- 🤖 Claude Code統合（`cc`エイリアス）
- 📦 自動インストールスクリプト付き

## クイックスタート

```bash
git clone https://github.com/yourusername/dotfiles.git ~/Development/dotfiles
cd ~/Development/dotfiles
./install.sh
```

## 含まれる設定

### Vim設定 (`.vimrc`)
- **プラグイン管理**: vim-plug
- **ファイルエクスプローラー**: NERDTree
- **ファジーファインダー**: fzf.vim
- **Git統合**: fugitive, gitgutter
- **自動補完**: CoC.nvim
- **シンタックスハイライト**: vim-polyglot
- **Linting**: ALE

### Zsh設定 (`.zshrc`, `.zprofile`)
- **テーマ**: Powerlevel9k (Nerd Font対応)
- **プラグイン**: git, zsh-syntax-highlighting, zsh-autosuggestions
- **パッケージマネージャー**: Homebrew, pyenv, nodenv, rbenv対応
- **エイリアス**: 
  - Git shortcuts
  - Claude Code (`cc`)
  - Docker (`dps`, `dimg`, `dc`, `ld`等)

### iTerm2設定
- **カラースキーム**: Gruvbox Dark
- **フォント**: MesloLGS Nerd Font
- **キーバインド**: 最適化済み

### Docker
- **Docker Desktop**: 自動インストール
- **Docker CLI ツール**: docker-compose, lazydocker
- **コンテナ分析ツール**: dive
- **Zsh補完**: Docker/docker-compose用の自動補完

### 生産性向上ツール
- **DeepL**: 高精度翻訳アプリ
- **Rectangle**: ウィンドウ管理（キーボードショートカット）
- **Alt-tab**: Windowsスタイルのアプリ切り替え
- **Raycast**: Spotlight代替（高機能ランチャー）
- **Stats**: メニューバーにシステム情報表示

## 必要な環境

- macOS (M1/M2 Mac推奨)
- Homebrew
- iTerm2
- Git

## インストール後の設定

1. ターミナルを再起動するか `source ~/.zshrc` を実行
2. iTerm2でプロファイルをインポート:
   - Preferences → Profiles → Import JSON Profiles...
   - `iterm2/profiles.json`を選択
3. 必要に応じて言語固有のツールをインストール

## カスタマイズ

各設定ファイルはカスタマイズ可能です:
- Vimのキーマッピング: `.vimrc`の`Key mappings`セクション
- Zshエイリアス: `.zshrc`の`永続的なalias`セクション
- iTerm2設定: `iterm2/profiles.json`を編集

## トラブルシューティング

### フォントが正しく表示されない
```bash
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font
```

### Vim pluginがインストールされない
```bash
vim +PlugInstall +qall
```

## ライセンス

MIT