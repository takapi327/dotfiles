---
name: feasibility-check
description: 引数で渡されたファイルの内容を、現在の実装と公式ドキュメントに照らして考慮漏れ・実現可能性を調査します
argument-hint: <対象ファイルパス>
arguments: target_file
allowed-tools: Read, Grep, Glob, WebSearch, WebFetch
---

対象ファイル = $target_file

※ 対象ファイル（$target_file）が渡されていない場合は、対象ファイルのパスを指定するようエラーメッセージを表示して終了してください。

$target_file の内容を確認して理解してください。その後現在の実装と公式ドキュメントを確認して理解した上で考慮漏れがないか実現可能かどうか調査してください
