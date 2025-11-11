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

## Vim設定と使用方法

### インストールされるプラグイン

| カテゴリ         | プラグイン        | 説明                    |
|--------------|--------------|-----------------------|
| ファイルエクスプローラー | NERDTree     | サイドバーでファイル管理          |
| ファジーファインダー   | fzf.vim      | 高速ファイル検索              |
| Git統合        | fugitive     | Gitコマンドの実行            |
| Git統合        | gitgutter    | 行ごとのGit差分表示           |
| 自動補完         | CoC.nvim     | LSP対応のインテリセンス         |
| Scala開発      | nvim-metals  | Scala LSP (Metals) 統合 |
| Scala開発      | vim-scala    | Scalaシンタックス・インデント     |
| シンタックス       | vim-polyglot | 多言語シンタックスハイライト        |
| Linting      | ALE          | 自動エラーチェック・フォーマット      |
| ステータスライン     | airline      | 拡張ステータスライン            |
| 編集補助         | commentary   | コメント切り替え              |
| 編集補助         | surround     | 括弧・クォート操作             |
| 編集補助         | auto-pairs   | 括弧の自動閉じ               |
| その他          | vim-devicons | ファイルアイコン表示            |

### 主要なキーバインド

**リーダーキー**: `Space`

#### ファイル操作

| キー          | 動作          | 説明                  |
|-------------|-------------|---------------------|
| `<Space>n`  | NERDTreeトグル | ファイルエクスプローラーの表示/非表示 |
| `<Space>nf` | NERDTreeで検索 | 現在のファイルをツリーで表示      |
| `<Space>f`  | ファイル検索      | fzfでファイル名検索         |
| `<Space>g`  | 内容検索        | ripgrepでファイル内容検索    |
| `<Space>b`  | バッファ一覧      | 開いているバッファを表示        |
| `<Space>h`  | 履歴          | 最近開いたファイル一覧         |

#### ウィンドウ・バッファ操作

| キー             | 動作      | 説明             |
|----------------|---------|----------------|
| `Ctrl+h/j/k/l` | ウィンドウ移動 | 左/下/上/右のウィンドウへ |
| `<Space>bp`    | 前のバッファ  | 前のバッファへ移動      |
| `<Space>bn`    | 次のバッファ  | 次のバッファへ移動      |
| `<Space>bd`    | バッファ削除  | 現在のバッファを閉じる    |

#### 編集操作

| キー               | 動作      | 説明           |
|------------------|---------|--------------|
| `<Space>w`       | 保存      | ファイルを保存      |
| `<Space>q`       | 終了      | Vimを終了       |
| `<Space>wq`      | 保存して終了  | 保存してVimを終了   |
| `<Space><Space>` | ハイライト解除 | 検索ハイライトをクリア  |
| `gcc`            | コメント切替  | 行コメントのON/OFF |
| `gc{motion}`     | 範囲コメント  | 選択範囲をコメント化   |

#### コード補完・ナビゲーション（CoC.nvim）

| キー          | 動作      | 説明           |
|-------------|---------|--------------|
| `Tab`       | 補完選択    | 次の補完候補を選択    |
| `Shift+Tab` | 逆補完選択   | 前の補完候補を選択    |
| `Enter`     | 補完確定    | 選択した補完を確定    |
| `gd`        | 定義へジャンプ | 変数/関数の定義位置へ  |
| `gr`        | 参照検索    | 変数/関数の使用箇所一覧 |
| `K`         | ドキュメント  | ホバードキュメント表示  |

#### Git操作（fugitive）

| コマンド          | 動作      | 説明               |
|---------------|---------|------------------|
| `:Git` / `:G` | ステータス   | git statusを表示    |
| `:Gwrite`     | ステージ    | git add（現在のファイル） |
| `:Gcommit`    | コミット    | git commit画面を開く  |
| `:Gpush`      | プッシュ    | リモートへプッシュ        |
| `:Gdiff`      | 差分表示    | 現在のファイルの差分       |
| `:Gblame`     | blame表示 | 行ごとの変更履歴         |

#### Scala開発（Metals）

| キー          | 動作       | 説明              |
|-------------|----------|-----------------|
| `<Space>si` | ビルドインポート | sbtプロジェクトをインポート |
| `<Space>sb` | ビルド接続    | ビルドサーバーに接続      |
| `<Space>sc` | コンパイル    | カスケードコンパイル実行    |
| `<Space>sr` | サーバー再起動  | Metalsサーバーを再起動  |
| `<Space>so` | import整理 | 未使用importの削除・整理 |
| `<Space>mc` | コンパイル    | プロジェクト全体をコンパイル  |
| `<Space>mi` | 暗黙引数表示   | 暗黙的な引数の表示切替     |
| `<Space>md` | 診断       | Metalsの診断情報を表示  |
| `<Space>mw` | ワークシート   | ワークシートのホバー情報    |

### カラーテーマ

Gruvbox Darkテーマが適用されています。変更する場合は`.vimrc`の`colorscheme gruvbox`を編集してください。

### 言語別設定

| 言語                    | タブ設定  | フォーマッター      | その他                |
|-----------------------|-------|--------------|--------------------|
| Python                | スペース4 | black, isort | flake8, pylint     |
| Go                    | ハードタブ | gofmt        | rustc              |
| JavaScript/TypeScript | スペース2 | Prettier     | ESLint             |
| Rust                  | スペース2 | rustfmt      | rustc              |
| Scala                 | スペース2 | scalafmt     | Metals LSP, scalac |
| Markdown              | スペース2 | -            | 自動改行、プレビュー対応       |
| その他                   | スペース2 | -            | デフォルト設定            |

### Scala開発環境のセットアップ

#### 1. 必要なツールのインストール
```bash
# Coursier (Scalaツールのインストーラ)
brew install coursier/formulas/coursier

# Metalsのインストール
cs install metals

# sbtのインストール（まだの場合）
brew install sbt
```

#### 2. Vimでの初回セットアップ
```vim
" プラグインのインストール
:PlugInstall

" Scalaファイルを開いてMetalsを起動
:MetalsInstall

" プロジェクトのインポート
:MetalsImportBuild
```

### トラブルシューティング

#### プラグインが読み込まれない場合
```vim
:PlugInstall
```

#### CoC.nvimの言語サーバーをインストール
```vim
:CocInstall coc-json coc-tsserver coc-python coc-rust-analyzer coc-metals
```

#### Metalsが動作しない場合
```vim
" Metalsの診断
:MetalsDoctor

" ログの確認
:MetalsLogToggle

" サーバーの再起動
:MetalsRestartServer
```

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