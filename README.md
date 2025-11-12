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

## 含まれる開発環境

### プログラミング言語
- **Python**: pyenv + pyenv-virtualenvで複数バージョン管理
- **Node.js**: nodenvで管理
- **Ruby**: rbenvで管理  
- **Scala**: sbt + Coursier + Metals
- **Go**: 公式インストーラー

### 開発ツール
- **エディタ**: Neovim (vim-plug)
- **ターミナル**: iTerm2 + Zsh (Powerlevel9k)
- **コンテナ**: Docker Desktop + lazydocker
- **Git**: gh CLI + fugitive (Vim統合)
- **AWS**: AWS CLI + SAM CLI
- **データベース**: MySQL Shell

## インストール後の設定

1. ターミナルを再起動するか `source ~/.zshrc` を実行
2. iTerm2でプロファイルをインポート:
   - Preferences → Profiles → Import JSON Profiles...
   - `iterm2/profiles.json`を選択
3. 必要に応じて言語固有のツールをインストール

## Vim設定と使用方法

### インストールされるプラグイン

| カテゴリ         | プラグイン          | 説明                            |
|--------------|----------------|-------------------------------|
| ファイルエクスプローラー | NERDTree       | サイドバーでファイル管理                  |
| ファジーファインダー   | fzf.vim        | 高速ファイル検索                      |
| Git統合        | fugitive       | Gitコマンドの実行                    |
| Git統合        | gitgutter      | 行ごとのGit差分表示                   |
| 自動補完         | CoC.nvim       | LSP対応のインテリセンス                 |
| TypeScript開発 | typescript-vim | TypeScript構文ハイライト             |
| TypeScript開発 | yats.vim       | Yet Another TypeScript Syntax |
| JavaScript開発 | vim-javascript | モダンJS構文サポート                   |
| Svelte開発    | vim-svelte     | Svelte構文ハイライト・インデント          |
| Svelte開発    | vim-svelte-plugin | 高機能Svelte構文プラグイン           |
| Svelte開発    | context_filetype.vim | コンテキスト別処理              |
| Svelte開発    | nerdcommenter  | Svelte対応コメント機能              |
| Svelte開発    | vim-prettier   | Prettier統合フォーマッター            |
| Scala開発      | nvim-metals    | Scala LSP (Metals) 統合         |
| Scala開発      | vim-scala      | Scalaシンタックス・インデント             |
| デバッグ         | nvim-dap       | デバッグアダプタープロトコル対応              |
| デバッグ         | nvim-dap-ui    | デバッグUI                        |
| ファイル検索       | telescope      | 高機能ファジーファインダー                 |
| テストランナー      | neotest        | 統合テストランナー                     |
| シンタックス       | vim-polyglot   | 多言語シンタックスハイライト                |
| Linting      | ALE            | 自動エラーチェック・フォーマット              |
| ステータスライン     | airline        | 拡張ステータスライン                    |
| 編集補助         | commentary     | コメント切り替え                      |
| 編集補助         | surround       | 括弧・クォート操作                     |
| 編集補助         | auto-pairs     | 括弧の自動閉じ                       |
| その他          | vim-devicons   | ファイルアイコン表示                    |

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

| キー          | 動作         | 説明                         |
|-------------|------------|----------------------------|
| `<Space>si` | ビルドインポート   | sbtプロジェクトをインポート            |
| `<Space>sb` | ビルド接続      | ビルドサーバーに接続                 |
| `<Space>sc` | コンパイル      | カスケードコンパイル実行               |
| `<Space>sr` | サーバー再起動    | Metalsサーバーを再起動             |
| `<Space>so` | import整理   | 未使用importの削除・整理            |
| `<Space>mc` | コンパイル      | プロジェクト全体をコンパイル             |
| `<Space>mi` | 暗黙引数表示     | 暗黙的な引数の表示切替                |
| `<Space>md` | 診断         | Metalsの診断情報を表示             |
| `<Space>mw` | ワークシート     | ワークシートのホバー情報               |
| `<Space>fm` | Metalsコマンド | Telescope経由でMetalsコマンド一覧表示 |

#### デバッグ（nvim-dap）

| キー           | 動作       | 説明             |
|--------------|----------|----------------|
| `<Space>dt`  | ブレークポイント | ブレークポイントの設定/解除 |
| `<Space>dc`  | デバッグ開始   | デバッグセッションを開始   |
| `<Space>dr`  | REPL起動   | デバッグREPLを開く    |
| `<Space>dK`  | 変数確認     | カーソル位置の変数値を表示  |
| `<Space>dso` | ステップオーバー | 次の行へ進む         |
| `<Space>dsi` | ステップイン   | 関数内に入る         |
| `<Space>dl`  | 最後のデバッグ  | 前回のデバッグ設定で再実行  |

#### Telescope検索

| キー          | 動作       | 説明              |
|-------------|----------|-----------------|
| `<Space>ff` | ファイル検索   | プロジェクト内のファイル検索  |
| `<Space>fg` | 内容検索     | ファイル内容を横断検索     |
| `<Space>fb` | バッファ検索   | 開いているバッファから検索   |
| `<Space>fh` | ヘルプ検索    | Vimヘルプを検索       |

### カラーテーマ

Gruvbox Darkテーマが適用されています。変更する場合は`.vimrc`の`colorscheme gruvbox`を編集してください。

### 言語別設定

| 言語                    | タブ設定  | フォーマッター      | その他                |
|-----------------------|-------|--------------|--------------------|
| Python                | スペース4 | black, isort | flake8, pylint     |
| Ruby                  | スペース2 | rubocop      | solargraph LSP     |
| Go                    | ハードタブ | gofmt        | rustc              |
| JavaScript/TypeScript | スペース2 | Prettier     | ESLint             |
| Rust                  | スペース2 | rustfmt      | rustc              |
| Scala                 | スペース2 | scalafmt     | Metals LSP, scalac |
| Markdown              | スペース2 | -            | 自動改行、プレビュー対応       |
| その他                   | スペース2 | -            | デフォルト設定            |

### Python開発環境のセットアップ（pyenv）

#### 1. pyenvの基本的な使い方
```bash
# インストール可能なPythonバージョンを確認
pyenv install --list

# 特定のバージョンをインストール
pyenv install 3.11.7

# グローバルバージョンを設定
pyenv global 3.11.7

# プロジェクト固有のバージョンを設定
cd /path/to/project
pyenv local 3.10.13

# 現在のバージョンを確認
pyenv version

# インストール済みバージョン一覧
pyenv versions
```

#### 2. 仮想環境の作成（pyenv-virtualenv）
```bash
# 仮想環境を作成
pyenv virtualenv 3.11.7 myproject-env

# 仮想環境をアクティベート
pyenv activate myproject-env

# 仮想環境をディアクティベート
pyenv deactivate

# プロジェクトディレクトリに自動アクティベート設定
cd /path/to/project
pyenv local myproject-env
```

#### 3. インストール済みのPython開発ツール
- **pip**: パッケージ管理
- **pipenv**: 依存関係管理
- **poetry**: モダンな依存関係管理
- **black**: コードフォーマッター
- **flake8**: リンター
- **pylint**: 高度なリンター
- **mypy**: 型チェッカー

### Ruby開発環境のセットアップ（rbenv）

#### 1. rbenvの基本的な使い方
```bash
# インストール可能なRubyバージョンを確認
rbenv install --list

# 特定のバージョンをインストール
rbenv install 3.2.3

# グローバルバージョンを設定
rbenv global 3.2.3

# プロジェクト固有のバージョンを設定
cd /path/to/project
rbenv local 3.0.6

# 現在のバージョンを確認
rbenv version

# インストール済みバージョン一覧
rbenv versions

# シムの再構築（新しいgemをインストール後）
rbenv rehash
```

#### 2. Gemの管理
```bash
# Bundlerを使用したプロジェクトセットアップ
gem install bundler
bundle init

# Gemfileに依存関係を追加後
bundle install

# プロジェクト内でgemを実行
bundle exec rails server
```

#### 3. インストール済みのRuby開発ツール
- **bundler**: Gem依存関係管理
- **rails**: Webフレームワーク
- **rubocop**: コードスタイルチェッカー
- **solargraph**: Language Server（VSCode/Vim用）
- **pry**: 高機能REPL/デバッガ
- **rspec**: テストフレームワーク

### Node.js開発環境のセットアップ（nodenv）

#### 1. nodenvの基本的な使い方
```bash
# インストール可能なNode.jsバージョンを確認
nodenv install --list

# 特定のバージョンをインストール
nodenv install 22.11.0

# グローバルバージョンを設定
nodenv global 22.11.0

# プロジェクト固有のバージョンを設定
cd /path/to/project
nodenv local 20.11.0

# 現在のバージョンを確認
nodenv version

# インストール済みバージョン一覧
nodenv versions

# パッケージマネージャーでパッケージをインストール後
nodenv rehash
```

#### 2. npmパッケージの管理
```bash
# package.jsonの初期化
npm init -y

# 開発用パッケージをインストール
npm install --save-dev eslint prettier

# 本番用パッケージをインストール
npm install express

# グローバルパッケージをインストール
npm install -g typescript

# Yarnを使う場合
yarn add react
yarn add -D @types/react

# pnpmを使う場合
pnpm add fastify
pnpm add -D vitest
```

#### 3. インストール済みのNode.js開発ツール
- **npm**: デフォルトパッケージマネージャー
- **yarn**: 高速パッケージマネージャー
- **pnpm**: ディスク効率的なパッケージマネージャー
- **typescript**: TypeScript言語
- **ts-node**: TypeScript実行環境
- **nodemon**: ファイル変更監視・自動再起動
- **eslint**: JavaScriptリンター
- **prettier**: コードフォーマッター
- **npm-check-updates**: パッケージ更新チェッカー

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

### TypeScript開発環境のセットアップ

#### 1. CoC拡張機能
install.shで以下が自動インストールされます：
- **coc-tsserver**: TypeScript言語サーバー
- **coc-eslint**: ESLintサポート
- **coc-prettier**: Prettierフォーマッター
- **coc-json**: JSON IntelliSense
- **coc-svelte**: Svelte言語サーバー

#### 2. TypeScript用キーバインド
既存のCoC.nvimキーバインドがTypeScriptでも使用可能：
- `gd`: 定義へジャンプ
- `gr`: 参照箇所一覧
- `K`: ホバードキュメント表示
- `<Space>rn`: リネーム
- `<Space>f`: 自動フォーマット

#### 3. CoC設定（:CocConfig）
```json
{
  "coc.preferences.formatOnSaveFiletypes": [
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact"
  ],
  "tsserver.formatOnType": true,
  "typescript.updateImportsOnFileMove.enable": true,
  "typescript.suggest.autoImports": true,
  "eslint.autoFixOnSave": true,
  "prettier.requireConfig": true
}
```

### Svelte開発環境のセットアップ

#### 1. インストールされるプラグイン
- **vim-svelte**: 軽量なSvelte構文ハイライト
- **vim-svelte-plugin**: 高機能Svelte構文プラグイン（Sass/TypeScript対応）
- **context_filetype.vim**: Svelteファイル内でHTML/JS/CSS部分を区別
- **nerdcommenter**: Svelte対応コメント機能
- **vim-prettier**: Prettierフォーマッター統合

#### 2. Svelte用設定
プロジェクトルートに`svelte.config.js`が必要（TypeScript/Sass使用時）：
```javascript
import { vitePreprocess } from '@sveltejs/kit/vite';

const config = {
  preprocess: vitePreprocess(),
  kit: {
    // adapter設定など
  }
};

export default config;
```

#### 3. CoC Svelte設定（:CocConfig）
```json
{
  "svelte.enable": true,
  "svelte.plugin.typescript.enable": true,
  "svelte.plugin.css.enable": true,
  "svelte.plugin.html.enable": true,
  "svelte.plugin.svelte.format.enable": true
}
```

#### 4. Svelteファイルでのコメント
- HTML部分: `<!-- コメント -->`
- Script部分: `// コメント`
- Style部分: `/* コメント */`

#### Metalsが動作しない場合
```vim
" Metalsの診断
:MetalsDoctor

" ログの確認
:MetalsLogToggle

" サーバーの再起動
:MetalsRestartServer
```

#### デバッグ機能を使う場合
```vim
" ブレークポイントを設定してからデバッグ開始
<Space>dt  " ブレークポイント設定
<Space>dc  " デバッグ実行

" デバッグ中の操作
<Space>dK  " 変数の値を確認
<Space>dso " 次の行へ
<Space>dsi " 関数の中へ
```

### AWS開発環境のセットアップ

#### AWS CLIの初期設定
```bash
# AWS認証情報を設定
aws configure

# プロファイルを指定して設定
aws configure --profile myprofile

# 設定確認
aws configure list
aws sts get-caller-identity
```

#### SAM CLIの使い方
```bash
# SAMプロジェクトの初期化
sam init

# ローカルでLambda関数をビルド
sam build

# ローカルでテスト実行
sam local start-api
sam local invoke FunctionName

# デプロイ
sam deploy --guided
```

### MySQL Shellの使い方

#### 基本的な接続方法
```bash
# MySQL Shellで接続（デフォルトはJavaScript モード）
mysqlsh -u username -h hostname -P 3306

# SQLモードで接続
mysqlsh --sql -u username -h hostname

# URI形式で接続
mysqlsh --uri username@hostname:3306/database

# エイリアスを使った接続
msh -u root -h localhost  # JavaScriptモード
sql                        # 従来のmysqlクライアント
```

#### MySQL Shellのモード切り替え
```sql
-- SQLモードに切り替え
\sql

-- JavaScriptモードに切り替え
\js

-- Pythonモードに切り替え
\py

-- 現在のモードを確認
\status
```

#### 便利なエイリアス
- `msh`: MySQL Shell（デフォルト）
- `mysqlsh`: SQLモードで起動
- `mshjs`: JavaScriptモードで起動
- `mshpy`: Pythonモードで起動
- `mshdump`: ダンプユーティリティ
- `sql`: 従来のMySQLクライアント

### 推奨される.gitignore設定

Scalaプロジェクトで以下のディレクトリを除外することを推奨：
```gitignore
# Scala/Metals
.metals/
.bloop/
.scala-build/
metals.sbt
.bsp/
project/metals.sbt
project/project/
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