# Getting Started

このリポジトリは Docker Compose と VSCode Dev Containers で使う Perl 練習環境です。

## 必要なもの

- Git
- Docker Desktop
- VSCode
- VSCode 拡張: Dev Containers

## ローカルに取得する

```sh
git clone https://github.com/xphiilox/training_perl.git
cd training_perl
```

## Docker コンテナを起動する

```sh
docker compose build
docker compose up -d
```

ブラウザでホーム画面を開きます。

```txt
http://localhost:3000
```

ホーム画面は Apache の CGI 方式で動いています。入口のスクリプトは `public/index.cgi` です。

コンテナに入る場合:

```sh
docker compose exec perl bash
```

コンテナ内では `/workspace` が作業ディレクトリです。

```sh
cd /workspace
perl bin/hello.pl
prove -l t
```

## Makefile を使う場合

```sh
make build
make up
make shell
make web
make run
make test
```

## VSCode で開く

```sh
code .
```

VSCode が開いたら、コマンドパレットから以下を実行します。

```txt
Dev Containers: Reopen in Container
```

左下に `Container training-perl:local` のような表示が出れば、コンテナ内で開けています。

## VSCode でデバッグする

1. `bin/hello.pl` を開く
2. `say "Hello, Perl!!!";` の行にブレークポイントを置く
3. Run and Debug から `Debug current Perl file` を実行する

この環境では `stopOnEntry: true` にしてあるため、デバッグ開始時に実行位置で止まります。

## よく使う確認コマンド

```sh
perl -v
perl bin/hello.pl
prove -l t
perl -MPerl::LanguageServer -e 'print "Perl::LanguageServer OK\n"'
```

## 終了する

```sh
docker compose down
```

## トラブルシュート

### `perl bin/hello.pl` が見つからない

コンテナ内で `/workspace` にいるか確認してください。

```sh
pwd
cd /workspace
perl bin/hello.pl
```

### VSCode でブレークポイントが置けない

以下を確認してください。

- VSCode 左下がコンテナ接続表示になっている
- `bin/hello.pl` の右下の言語モードが `Perl` になっている
- Dev Container 内に `richterger.perl` 拡張が入っている

必要なら VSCode で以下を実行します。

```txt
Developer: Reload Window
```

### `Couldn't start client Perl Language Server` が出る

コンテナ内で以下が通るか確認してください。

```sh
perl -MPerl::LanguageServer -e 'print "Perl::LanguageServer OK\n"'
```

通る場合は VSCode を Dev Container で開き直してください。

![VSCode Perl debugger](docs/images/vscode-perl-debug.png)

Enjoy!
