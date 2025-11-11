# iTerm2 設定

## 自動インストール

`install.sh`を実行すると、iTerm2のDynamic Profiles機能を使用してプロファイルが自動的にインストールされます。

プロファイルは以下の場所にコピーされます：
`~/Library/Application Support/iTerm2/DynamicProfiles/dotfiles-profile.json`

## デフォルトプロファイルに設定

自動インストール後：
1. iTerm2を開く
2. Preferences (⌘,) → Profiles
3. 「M1 Mac Development」プロファイルを選択
4. 下部の「Set as Default」をクリック

## 手動インポート（代替方法）

手動でインポートする場合：
1. iTerm2を開く
2. Preferences (⌘,) → Profiles
3. 左下の「Import JSON Profiles...」をクリック
4. `iterm2/profiles.json`を選択

## 推奨設定

### フォント
- Nerd Font（MesloLGS NF）は`install.sh`で自動インストールされます
- 手動インストールの場合：
  ```bash
  brew tap homebrew/cask-fonts
  brew install --cask font-meslo-lg-nerd-font
  ```

### カラーテーマ
プロファイルにGruvbox Darkテーマが含まれています。

### キーバインド
- ⌘D: 水平分割
- ⌘⇧D: 垂直分割
- ⌘[/⌘]: ペイン間移動

## カスタマイズ

プロファイル読み込み後の調整：
- フォントサイズ: "MesloLGS-NF-Regular 13"の数字を変更
- カラー: 各色の値を好みに応じて調整
- キーマッピング: Optionキーの動作を必要に応じて変更

注意: iTerm2内での変更は元のファイルには反映されません。変更を永続化するには、プロファイルをエクスポートしてソースファイルを更新してください。
