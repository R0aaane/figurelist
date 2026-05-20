# FigureList Web

Flutterアプリの現在の機能を、ローカルサーバーで動くWeb版として実装したものです。

## 起動

```powershell
cd C:\_workspace\Flutter\FigureList\figurelist\webapp
node supervisor.js
```

管理画面は `http://localhost:4172`、アプリ本体は `http://localhost:4173` です。
管理画面またはアプリ右上の `Start` / `Stop` からアプリ本体サーバーを起動・停止できます。

アプリ本体だけを直接動かす場合:

```powershell
node server.js
```

この場合はアプリ内の `Stop` は使えますが、停止後の再起動には `node server.js` または `node supervisor.js` が必要です。

## DB

SQLiteファイルは `webapp\data\figurelist.sqlite` に作成されます。

主なテーブル:

- `prize_items`
- `prize_acquisition_logs`
- `prize_stores`
- `prize_store_appearances`
- `audit_logs`

プライズ状態、メモ、獲得ログ、店舗登録、入荷予定の手動変更、同期登録、削除は `audit_logs` に変更前後のJSONとして記録されます。

## ユーザー

アプリ画面から `Register` でユーザー名とパスワードを登録できます。
パスワードはPBKDF2ハッシュで保存し、平文では保存しません。
Web版はログインCookieを30日保持します。
Windows版はアプリデータフォルダにセッション情報を保存し、次回起動時に自動ログインと同期を試みます。

ユーザーごとに分かれるデータ:

- プライズ状態
- メモ
- 獲得ログ

全員共通のデータ:

- プライズ本体
- 掲載写真URL
- 店舗候補
- 店舗登録
- 入荷予定

`メンバー` タブでは、各ユーザーの獲得済み・獲得予定・見送りの件数と対象プライズを確認できます。

`メンバー` タブと `変更記録` タブは、username が `admin` のユーザーだけが閲覧できます。
管理者を作る場合は、ログイン画面で username に `admin` を指定して `Register` してください。

## 箱画像修正

詳細画面の `箱画像URL` を変更して `箱画像URLを保存` を押すと、プライズ本体の画像URLが更新されます。
また、`画像ファイルを選択` から手元の画像をアップロードして差し替えることもできます。

アップロードされた画像は `webapp/public/uploads` に保存されます。
この変更は全ユーザーに反映され、`audit_logs` に `image_update` または `box_image_upload` として記録されます。

## localhost以外で配信する場合

同じLAN内なら、PCのIPアドレスで `http://<PCのIPアドレス>:4173` にアクセスできます。
インターネット経由で仲間内に配信する場合は、Cloudflare Tunnel、ngrok、VPS + 独自ドメイン + HTTPS などを使えます。

公開する場合は、少なくとも以下を設定してください。

- HTTPS
- 推測されにくい強いパスワード
- DBファイルのバックアップ
- 管理サーバー `4172` は外部公開しない

## Cloudflare Tunnelで少人数に共有

テスト用途ならCloudflare Quick Tunnelを使います。Cloudflare公式ドキュメントでは、Quick Tunnelは開発・検証用で、本番運用には通常のCloudflare Tunnel作成が推奨されています。

1. `cloudflared` をインストールします。

```powershell
cd C:\_workspace\Flutter\FigureList\figurelist\webapp
.\install_cloudflared_windows.ps1
```

PowerShellでスクリプト実行が無効な場合:

```powershell
powershell -ExecutionPolicy Bypass -File .\install_cloudflared_windows.ps1
```

2. 新しいPowerShellを開き、トンネルを開始します。

```powershell
cd C:\_workspace\Flutter\FigureList\figurelist\webapp
.\start_cloudflare_tunnel.ps1
```

PowerShellでスクリプト実行が無効な場合:

```powershell
powershell -ExecutionPolicy Bypass -File .\start_cloudflare_tunnel.ps1
```

3. 画面に表示される `https://xxxxx.trycloudflare.com` のURLを仲間に共有します。

注意:

- 共有するのは `4173` のアプリ本体だけです。
- 管理サーバー `4172` は公開しません。
- PCをスリープさせる、PowerShellを閉じる、`Ctrl+C` で止めると共有URLは使えなくなります。
- Quick TunnelのURLは毎回変わります。
- 仲間には各自 `Register` でユーザー名とパスワードを作ってもらってください。
