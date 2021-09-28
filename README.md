# Visible Scratch Skillz

- スクラッチの楽譜を作成し、画像として出力できるサービスです
- トリック名、パターン、拍の長さを選んで追加していくことで簡単に楽譜を作ることができます
- ログイン無しでも作成することができます
- ログインして利用すると以下の機能が使えるようになります
  - 作成した楽譜の保存(画像用のURLが生成されます)
  - 保存した画像のURLをワンクリックでクリップボードにコピー
  - 保存した画像のembedタグをワンクリックでクリップボードにコピー


![image](https://user-images.githubusercontent.com/75117116/135072406-a642d222-65d9-4816-a2e7-6cf9ce2b44bb.png)
![image](https://user-images.githubusercontent.com/75117116/135074078-1685dcdd-1e06-4e2e-81cd-7a270e428010.png)


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
