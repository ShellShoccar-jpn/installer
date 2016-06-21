# installer
我らが公開するシェルスクリプト開発用のコマンドを一通りインストールするためのシェルスクリプト

## 使い方

### インストールしたい場合

管理者の場合は次のように実行する。

```sh:
$ shellshoccar.sh install
```

すると/usr/local/shellshoccarディレクトリーが作られ、そこに一式が作られる。コマンドが成功したら、環境変数PATHに `/usr/local/shellshoccar` を追加すること。

一般ユーザーが自分のディレクトリーにインストールする場合は、--prefixオプションを使い、例えば次のようにする。

```sh:
$ shellshoccar.sh --prefix=~/shellshoccar install
```

すると~/shellshoccarディレクトリーが作られ、そこに一式が作られる。コマンドが成功したら、環境変数PATHに `~/shellshoccar` を追加すること。

### アンインストールしたい場合

管理者の場合は次のように実行する。

```sh:
$ shellshoccar.sh uninstall
```

すると/usr/local/shellshoccarディレクトリーが消される。ただし、/usr/local/shellshoccar/log/shellshoccar_inst.logというファイルが存在することを事前確認し、それがなければアンインストールは拒否される。

一般ユーザーが自分のディレクトリーにインストールしたものをアンインストールする場合は、--prefixオプションを使い、例えば次のようにする。

```sh:
$ shellshoccar.sh --prefix=~/shellshoccar uninstall
```

すると~/shellshoccarディレクトリーが消される。ただし、~/shellshoccar/log/shellshoccar_inst.logというファイルが存在することを事前確認し、それがなければアンインストールは拒否される。

## 依存コマンド

本コマンドを実行するには、POSIX範囲外のコマンドとして、次のどちらかの組み合わせが必要である。

* gitコマンド
* unzipコマンドとWebアクセスのためのコマンドとしてcurlまたはwget


