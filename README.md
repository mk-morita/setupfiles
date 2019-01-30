# setupfiles

Mac専用です。

## What is this repository?
新しく導入した Mac のセットアップをするためのスクリプト、設定ファイルを保持しています。

セットアップスクリプトを実行することで、個別カスタマイズする前段階までの、必要なアプリケーションや設定を一括で行うことができます。

パブリックリポジトリですので、業務に密着する情報は含まないようにしています。インストール完了後に個別設定してください。


## Setup

1. App Store アプリを起動し、Apple ID でログインしておく。

1. AppStore以外のアプリケーションをインストールできる設定をターミナルから行う。

  ```bash
  sudo spctl --master-disable
  spctl kext-consent disable
  ```

1. 下図のように設定する。

1. このリポジトリをホームディレクトリ等に clone して、セットアップ用スクリプトを実行します。

  ```bash
  git clone https://github.com/mk-morita/setupfiles.git
  cd setupfiles
  ./setup.sh
  ```

  git コマンドを実行するために必要な Xcode command line tools がインストールされていない場合はダイアログが表示されるので、それに従って先にインストールする。
  インストール終了後、再度 `git clone` から手順を進める。
  * 途中でパスワード入力を求められたりするので、時々実行中の状態を確認して対応する。
  * パスワード以外で、 `Do you want to set a repository (y)? ((n) for local Brewfile). [y/n]:` と聞かれた場合は "n" を指定する。

1. インストール完了後、下図のように設定を戻す。

1. 最初に行った設定をターミナルから元に戻す。

  ```
  sudo spctl --master-enable
  ```

1. 必要に応じて別途アプリケーションをインストールする

  ```bash
  brew cask install virtualbox
  brew cask install virtualbox-extension-pack
  brew cask install vagrant
  brew cask install vagrant-manager
  ```

---
## インストールされるアプリケーション
以下は一部。詳しくは `Brewfile`を参照。

|application  |説明 |
|------|---------|-----|
|Atom  |テキストエディタ |
|Bash  |Bash 5.0 |
|Docker  |Docker for Mac |
|Firefox  |ブラウザ |
|Google Chrome  |ブラウザ |
|Google Drive File Stream  |(無し)    |
|Intellij IDEA CE  |Intellij IDEA CE |
|iTerm2  |ターミナル |
|Station  |Slack, Gmail, Google Calendar 等を1箇所で管理できる |
|SonicWall Mobile Connect |VPN接続用 |
|TeamSQL  |DB Manager |

## 開発関連ツールの使い方

### Auto complete
セットアップを実行後、以下の auto complete が使えます。
* Bash
* Git
* Docker

### jenv: Java version を切り替える
[`anyenv`](https://github.com/anyenv/anyenv) を利用して [`jenv`](http://www.jenv.be) をインストールしており、この `jenv` で Javaバージョン(`$JAVA_HOME`も切り替え可)の切り替えを行えます。


---
# Appendices
以下は設定ファイル等用意するための手順や情報です。


Reference:
* [Qiita | Macで自動環境構築＆バックアップ(App Storeも)](https://qiita.com/takeo-asai/items/29724f94e2992fdc7246)

## Homebrew

### Prepare Brewfile

```bash
export HOMEBREW_BREWFILE=~/setupfiles/Brewfile
brew file init
```

* Vagrant, Virtualbox 関連は `Brewfile` から削除しておく。


### Restore Brewfile

```bash
brew file install Brewfile
```

## Atom

事前に "Atom > Install Shell Commands" から`apm`を導入しておく。

### Prepare Atomfile

```bash
apm list -bi > Atomfile
```

### Restore from Atomfile
```bash
apm install --packages-file Atomfile
```

## Visual Studio code

1. `Command + Shift + P` でコマンドパレットを開く
1. "shell" で検索
1. `code` コマンドをインストールする
![Visual Studio Code | install 'code' command](./docs/vscode_install_shell.png)
