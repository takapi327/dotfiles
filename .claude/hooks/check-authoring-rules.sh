#!/bin/bash
# Claude Code Stop hook: 記述ルールの確認・修正を促す
# 処理完了時に、今回の変更が以下のルールに沿っているか検証・修正させる
#   コード        -> How    （どのように実現しているか）
#   テストコード   -> What   （何を検証しているか）
#   コミットログ   -> Why    （なぜこの変更が必要か）
#   コードコメント -> Why not（なぜ他の手段を採らなかったか・注意点）

INPUT=$(cat)

# 無限ループ防止: このhook起因の継続(stop_hook_active)なら確認済みとして通過させる
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')
if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  exit 0
fi

REASON=$(cat <<'EOF'
処理を終える前に、今回の作業で変更・追加した内容が以下の記述ルールに沿っているか必ず確認し、違反があれば修正してください。

- コード: 「How（どのように実現しているか）」が読み取れる実装になっているか
- テストコード: 「What（何を検証しているか）」がテスト名・内容から明確か
- コミットログ: 「Why（なぜこの変更が必要か）」が説明されているか
- コードコメント: 「Why not（なぜ他の手段を採らなかったか・注意点）」が書かれているか

該当する変更が無い項目はスキップして構いません。確認と修正が完了したら終了してください。
EOF
)

# Stopをブロックし、Claudeに確認・修正を継続させる
# jqが無い環境ではJSONを出力できず、通常どおり終了する（安全側にフォールバック）
if command -v jq &> /dev/null; then
  jq -n --arg reason "$REASON" '{decision: "block", reason: $reason}'
fi

exit 0
