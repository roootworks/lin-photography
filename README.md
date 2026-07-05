# Lin Photography ホームページ

写真家「麟-Lin-」さんのポートフォリオサイトです。HTML/CSS/JavaScriptのみで作られた
静的サイトで、GitHub Pages(無料)にそのまま公開できます。サーバー処理やビルドは一切不要です。

## ファイル構成　

```
lin-photography-site/
├── index.html              ページ本体(この1ファイルに全セクションが入っています)
├── assets/
│   ├── css/style.css       デザイン(白背景・シンプル)
│   ├── js/i18n.js          日本語/英語/中国語(簡体字)の文言データ
│   ├── js/main.js          スライドショー・言語切替・お問い合わせフォームの動作
│   └── img/                圧縮済みの写真・ロゴ
├── tools/
│   ├── resize-images.ps1   写真を後から差し替える時の圧縮スクリプト
│   └── serve.ps1           手元で表示確認するための簡易サーバー
├── .nojekyll                GitHub Pages側でJekyll変換をしないようにする空ファイル
└── README.md                このファイル
```

## GitHub Pagesの無料枠について(確認済み)

- 公開(Public)リポジトリなら完全無料。静的HTML/CSS/JS/画像のみで、今回のサイトはこの範囲内で収まっています。
- サーバー処理(お問い合わせの自動メール送信、データベースなど)はできません。
  → お問い合わせフォームは「送信」を押すとお使いのメールソフトが自動で起動し、内容が入力された状態になる方式(mailto)にしています。相手のPC/スマホにメールソフトの設定がない場合に備えて、メールアドレスも直接表示しています。
- 画像はすべて圧縮済みで、サイト全体で約6MBです(GitHubの目安である「リポジトリ1GB程度」「月間帯域100GB程度」に対して十分小さく、無料枠で問題なく運用できます)。
- 独自ドメインを使わない場合、公開URLは `https://(GitHubのユーザー名).github.io/(リポジトリ名)/` になります。

## 手元での確認方法(公開前のプレビュー)

Node.js等をインストールしなくても、PowerShellだけで確認できます。

```
powershell -ExecutionPolicy Bypass -File tools\serve.ps1
```

ブラウザで `http://localhost:8080/` を開くと表示されます。止めるときはターミナルを閉じてください。

## GitHubで公開する手順(アカウントをまだお持ちでない場合)

1. **GitHubアカウントを作成**
   - https://github.com/ にアクセスし、「Sign up」からメールアドレス・パスワード・ユーザー名を登録します(無料)。
2. **新しいリポジトリを作成**
   - 右上の「+」→「New repository」
   - Repository name: 例 `lin-photography`(お好きな名前でOK。これが公開URLの一部になります)
   - Public(公開)を選択 ※Privateだと無料でPagesが使えません
   - 「Create repository」をクリック
3. **このフォルダの中身をアップロード**
   - 一番簡単な方法: 作成したリポジトリのページで「uploading an existing file」というリンクをクリックし、
     `lin-photography-site` フォルダの中身(index.html, assets, tools, .nojekyll, README.md)を
     まとめてドラッグ&ドロップ → 「Commit changes」
   - Gitコマンドに慣れている場合は、リポジトリ作成後に表示される案内に従い、
     このフォルダで以下を実行(すでに `git init` 済みなら1〜3行目は不要です):
     ```
     git remote add origin https://github.com/(ユーザー名)/(リポジトリ名).git
     git branch -M main
     git push -u origin main
     ```
4. **GitHub Pagesを有効化**
   - リポジトリの「Settings」→左メニュー「Pages」
   - 「Build and deployment」の「Branch」で `main` / `/(root)` を選択して「Save」
   - 数分待つと、ページ上部に公開URL(`https://(ユーザー名).github.io/(リポジトリ名)/`)が表示されます。

## 後から変更したいとき

- **お問い合わせ先メールアドレスの変更**
  - `assets/js/main.js` 冒頭の `CONTACT_EMAIL` を変更
  - `index.html` 内のメールアドレス(2箇所: お問い合わせ欄・リンク欄のメールアイコン)を変更
  - 現在の設定: `qilin375hptak@outlook.jp`
- **電話番号の変更**
  - `index.html` の `contact-phone` 内の `tel:` リンクと表示テキスト(現在: 090-1325-7647)を変更
- **文章(日本語/英語/中国語)の変更**
  - `assets/js/i18n.js` を開き、該当する言語(ja/en/zh)の該当キーの文章を書き換えるだけで反映されます。
- **写真の差し替え**
  - `りんくんホームページ` フォルダのような元データを用意し、`tools/resize-images.ps1` の
    `$jobs` リストにあるファイル名を書き換えて実行すると、自動でリサイズ・圧縮されて
    `assets/img/` に出力されます(サイズが大きいまま使うとページの表示が遅くなるため)。
  - スライドショーの枚数を増減したい場合は、`index.html` の `.slide` の `<img>` タグを追加/削除してください。
- **ロゴの差し替え**
  - `assets/img/logo.png` を置き換えるだけで、トップの演出・favicon(タブのアイコン)両方に反映されます。

## 問い合わせフォームについて(補足)

静的サイトのため、サーバーを介した完全自動送信はできません。現在の実装は
「送信」ボタンを押すとお使いのメールソフト(Outlook、Mailなど)が起動し、
入力内容が本文に自動で入った状態でメール作成画面が開く」という方式です。
最後に「送信」を押すのはご本人(お問い合わせをした人)の操作になります。
