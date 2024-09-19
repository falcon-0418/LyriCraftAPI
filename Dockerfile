# ビルドステージ
# MeCabのビルダーイメージを作成するためにDebianベースのイメージを使用
FROM debian:buster-slim as mecab-builder

# 必要なパッケージをaptでインストール
RUN apt-get update -qq \
  && apt-get install -y \
  \
  # build-essential = mecabのようなc++で書かれたソフトウェアのコンパイルに必要な基本的な開発ツールが含まれてるメタパッケージ
  build-essential \
  \
  # mecab関連のライブラリ
  libmecab-dev \
  mecab \
  mecab-ipadic \
  mecab-ipadic-utf8 \
  \
  git \
  curl \
  file \
  # mecabのインストールスクリプトでsudoを必要としているため追加
  sudo

# mecab-ipadic-neologd(解析ライブラリと辞書)をインストール
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
  && cd mecab-ipadic-neologd && ./bin/install-mecab-ipadic-neologd -n -y \
  \
  # MeCabが使用する辞書ディレクトリを指定する設定。 (mecab-config --dicdir)は辞書ディレクトリのパスを取得するコマンド
  && echo dicdir = $(mecab-config --dicdir)"/mecab-ipadic-neologd" > /etc/mecabrc

# 実行ステージ
FROM ruby:3.2.2
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    # mecab関連を実行時用にも必要なため再インストール (もしかしたらCOPYすれば済むかも)
    vim \
    mecab \
    mecab-ipadic \
    mecab-ipadic-utf8 \
    libmecab-dev \
    \
    nodejs \
    locales \
  # mecab-builderも含めパッケージリストを削除して、Dockerイメージのサイズを小さくする
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean \
  && locale-gen ja_JP.UTF-8

# 環境変数の設定
ENV LANG=ja_JP.UTF-8
ENV TZ=Asia/Tokyo

# mecab-ipadic-neologdの再インストールの代わりにビルドステージから必要なファイルをコピー
COPY --from=mecab-builder /usr/lib/x86_64-linux-gnu/mecab/ /usr/lib/x86_64-linux-gnu/mecab/
COPY --from=mecab-builder /etc/mecabrc /etc/mecabrc
COPY --from=mecab-builder /var/lib/mecab/dic /var/lib/mecab/dic

# 作業ディレクトリを設定
WORKDIR /api

# アプリケーションのソースコードをコピー
COPY . /api

# アプリケーションの依存関係をインストール
RUN bundle install


# # # Rails serverの起動
CMD ["bundle", "exec",  "rails", "server", "-b", "0.0.0.0", "-p", "${PORT}", "-e", "production"]
