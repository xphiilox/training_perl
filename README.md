# training_perl

DockerコンテナのPerl練習用の環境です。
デバッガーを使ってステップ実行して入門しましょう。
Mojolicious を使ったホーム画面も用意しています。

## 使い方

```sh
make build
make up
```

ブラウザで開く:

```txt
http://localhost:3000
```

シェルに入る場合:

```sh
make shell
```

コンテナを起動したままにする場合:

```sh
make up
docker compose exec perl bash
```

テスト:

```sh
make test
```

## VSCode でデバッグする

VSCode に Dev Containers 拡張が入っている状態で、このフォルダを開いてから `Dev Containers: Reopen in Container` を実行してください。

コンテナ内の VSCode には Perl 拡張 `richterger.perl` が入り、Docker イメージ側にはデバッグアダプタ兼 language server の `Perl::LanguageServer` が入ります。

デバッグは VSCode の Run and Debug から以下を選べます。

- `Debug current Perl file`
- `Debug hello.pl`

最初に使うなら `bin/hello.pl` を開いて、`Debug current Perl file` または `Debug hello.pl` でブレークポイントを置いて実行できます。

CPAN モジュールを追加したい場合は `cpanfile` に書いてから、必要に応じて Dockerfile や起動後のコンテナでインストールしてください。

詳しい手順は [GETTING_STARTED.md](GETTING_STARTED.md) を見てください。

![VSCode Perl debugger](docs/images/vscode-perl-debug.png)

Enjoy!
