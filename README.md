# installer
我らが公開するシェルスクリプト開発用のコマンドを一通りインストールするためのシェルスクリプト

## 使い方

### インストールしたい場合

管理者の場合は次のように実行する。

```sh:
$ shellshoccar.sh install
```

すると/usr/local/shellshoccarディレクトリーが作られ、そこに一式が作られる。コマンドが成功したら、環境変数PATHには、コマンド実行の最後に示されたディレクトリー（おそらくは `/usr/local/shellshoccar/bin` ）を追加すること。

一般ユーザーが自分のディレクトリーにインストールする場合は、--prefixオプションを使い、例えば次のようにする。

```sh:
$ shellshoccar.sh --prefix=~/shellshoccar install
```

すると~/shellshoccarディレクトリーが作られ、そこに一式が作られる。コマンドが成功したら、こちらも環境変数PATHには、コマンド実行の最後に示されたディレクトリー（おそらくは `~/shellshoccar/bin` ）を追加すること。

### アンインストールしたい場合

管理者の場合は次のように実行する。

```sh:
$ shellshoccar.sh uninstall
```

すると/usr/local/shellshoccarディレクトリーが消される。ただし本コマンドは、/usr/local/shellshoccar/log/shellshoccar_inst.logというファイルが存在することを事前確認し、それがなければアンインストールは拒否するようになっている。

一般ユーザーが自分のディレクトリーにインストールしたものをアンインストールする場合は、--prefixオプションを使い、例えば次のようにする。

もしそのファイルを消してしまったのであれば、 `rm -rf /usr/local/shellshoccar` を実行して手動で消せばよい。

```sh:
$ shellshoccar.sh --prefix=~/shellshoccar uninstall
```

すると~/shellshoccarディレクトリーが消される。ただし本コマンドは、~/shellshoccar/log/shellshoccar_inst.logというファイルが存在することを事前確認し、それがなければアンインストールは拒否するようになっている。

もしそのファイルを消してしまったのであれば、 `rm -rf ~/shellshoccar` を実行して手動で消せばよい。

## 依存コマンド

本コマンドを実行するには、POSIX範囲外のコマンドとして、次のどちらかの組み合わせが必要である。

* gitコマンド
* unzipコマンドとWebアクセスのためのコマンドとしてcurlまたはwget
