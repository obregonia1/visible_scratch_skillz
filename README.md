# Visible Scratch Skillz

- スクラッチの楽譜を作成し、画像として出力できるサービスです
- トリック名、パターン、拍の長さを選んで追加していくことで簡単に楽譜を作ることができます
- ログイン無しでも作成することができます
- ログインして利用すると以下の機能が使えるようになります
  - 作成した楽譜の保存(画像用のURLが生成されます)
  - 保存した画像のURLをワンクリックでクリップボードにコピー
  - 保存した画像のembedタグをワンクリックでクリップボードにコピー

![image](https://user-images.githubusercontent.com/75117116/135206827-4d38f220-b0e1-4cc4-8b3b-9c0c4a117113.png)
![image](https://user-images.githubusercontent.com/75117116/135206690-40851caf-f11f-427b-80ee-a544bd6a735f.png)

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
