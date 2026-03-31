---
allowed-tools: Bash(git:*), Bash(gh:*), Bash(npm:*), Bash(cat:*), Read(*), Fetch(*), WebSearch(*), WebFetch(*), Grep(*)
description: "引数で指定したPRで行なった依存ライブラリのバージョンアップに従うレビューを行います"
---

PR番号 = $1

※ $1 が渡されていない場合はエラーメッセージを表示して終了してください。

## 手順

### 1. PR情報の取得

`gh pr view {PR番号}` および `gh pr diff {PR番号}` を使用して、PRの概要と変更差分を取得してください。

### 2. 依存ライブラリの変更検出

差分から依存ライブラリの変更を検出してください。対象ファイルの例：

- `build.sbt`, `project/plugins.sbt`, `project/*.scala` (Scala/sbt)
- `package.json`, `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml` (Node.js)
- `requirements.txt`, `pyproject.toml`, `poetry.lock`, `Pipfile.lock` (Python)
- `Gemfile`, `Gemfile.lock` (Ruby)
- `go.mod`, `go.sum` (Go)
- `Cargo.toml`, `Cargo.lock` (Rust)
- `*.tf` (Terraform providers)
- `flake.nix`, `flake.lock` (Nix)

変更前後のバージョンを一覧化してください。

### 3. 各ライブラリの変更内容調査

変更されたライブラリそれぞれについて、以下を調査してください：

- 公式のChangelog/Release Notesを確認（GitHub Releasesページ等）
- 変更前バージョンから変更後バージョンまでの間に含まれる変更を確認

### 4. レビュー観点

以下の観点でレビューを行ってください：

- **Breaking Changes（破壊的変更）**: API変更、削除されたメソッド/クラス、シグネチャ変更
- **非推奨API（Deprecation）**: 今回のバージョンで非推奨になったAPIをプロジェクト内で使用していないか
- **マイグレーション対応漏れ**: 公式マイグレーションガイドの手順がすべて実施されているか
- **推移的依存関係の影響**: transitive dependencyの変更による間接的な影響
- **セキュリティ**: CVE/セキュリティアドバイザリの有無、脆弱性修正の確認
- **動作互換性**: ランタイムバージョン要件の変更（Java/Node.js/Python等の最低バージョン）

### 5. プロジェクト内の影響範囲確認

変更されたライブラリのAPIを使用している箇所をプロジェクト内で検索し、影響を受けるファイルを特定してください。

### 6. 結果出力

レビュー結果はマークダウンファイルに書き出してまとめてください。以下の構成で記載してください：

```
# 依存ライブラリ バージョンアップレビュー
## PR情報
## 変更されたライブラリ一覧（変更前 → 変更後）
## 各ライブラリの詳細レビュー
### ライブラリ名
- Breaking Changes
- Deprecations
- マイグレーション対応状況
- セキュリティ
## プロジェクト内の影響範囲
## 総合評価・指摘事項
```

レビューとマークダウンファイルの確認は3回繰り返して行い精度を高めるようにしてください。
