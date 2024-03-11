FROM debian:buster-slim as mecab-builder
RUN apt-get update -qq \
  && apt-get install -y \
  build-essential \
  libmecab-dev \
  mecab \
  mecab-ipadic \
  mecab-ipadic-utf8 \
  git \
  curl \
  file \
  sudo

# mecab-ipadic-neologdのインストール
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
  && cd mecab-ipadic-neologd && ./bin/install-mecab-ipadic-neologd -n -y \
  && echo dicdir = $(mecab-config --dicdir)"/mecab-ipadic-neologd" > /etc/mecabrc

FROM ruby:3.2.2
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    mecab \
    mecab-ipadic \
    mecab-ipadic-utf8 \
    libmecab-dev \
    nodejs \
    locales \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean \
  && locale-gen ja_JP.UTF-8

ENV LANG=ja_JP.UTF-8
ENV TZ=Asia/Tokyo

COPY --from=mecab-builder /usr/lib/x86_64-linux-gnu/mecab/ /usr/lib/x86_64-linux-gnu/mecab/
COPY --from=mecab-builder /etc/mecabrc /etc/mecabrc
COPY --from=mecab-builder /var/lib/mecab/dic /var/lib/mecab/dic

WORKDIR /app
COPY . /app
RUN bundle install --without development test --deployment


# # # Start the Rails server
CMD ["bundle", "exec",  "rails", "server", "-b", "0.0.0.0", "-e", "production"]
