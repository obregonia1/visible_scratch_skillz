# Visible Scratch Skillz

- スクラッチの楽譜を作成し、画像として出力できるサービスです
- トリック名、パターン、拍の長さを選んで追加していくことで簡単に楽譜を作ることができます
- ログイン無しでも作成することができます

ログインして利用すると以下の機能が使えるようになります
- 作成した楽譜の保存(画像用のURLが生成されます)
- 保存した画像のURLをワンクリックでクリップボードにコピー
- 保存した画像のembedタグをワンクリックでクリップボードにコピー

[デモ動画](https://youtu.be/mmrSsEF59x4)

|作成画面|ユーザーページ|
|-|-|
|![create_demo](https://user-images.githubusercontent.com/75117116/137609359-f0a6456b-d87a-482e-ab0f-1e1ecaad68d9.gif)|![137609742-2b5f6ffb-f3f7-48df-9a03-17eb5ffc8553](https://user-images.githubusercontent.com/75117116/137609757-86ff4c70-6e62-4e73-843f-bcf5d5be27e6.png)|

## インフラ構成図
![Untitled Diagram drawio (2)のコピー2](https://user-images.githubusercontent.com/75117116/137612823-c84d4243-3497-4229-8a4e-bc3adf4b1bdf.png)

## URL
```
https://visible-scratch-skillz.net
```

## ローカルで起動
```
$ git clone https://github.com/obregonia1/visible_scratch_skillz.git
```
```
$ cd visible_scratch_skillz
```
```
$ bin/setup
```
```
$ rails server
```

## seed(テスト)データを入力
```
$ rails db:seed
```
下記を入力してログインしてください。
```
Email: vss1@example.com
Password: password
```

## テストの実行
```
$ rspec
```

## Lint
```
$ rubocop
```
