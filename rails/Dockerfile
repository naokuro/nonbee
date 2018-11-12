FROM centos:centos7
MAINTAINER naokuro

ENV HOME /root
ENV PATH $HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH
ENV SHELL /bin/bash
#ENV LANG en_US.utf-8
#ENV LC_ALL en_US.utf-8
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES 'YES'

# 言語設定
ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_CTYPE="ja_JP.UTF-8" \
    LC_ALL="ja_JP.UTF-8"
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

## システムの更新
RUN yum -y update
#RUN yum remove -y vim-minimal

# 一般的な開発ライブラリの構築
# リポジトリ
#   epel-release
# 開発ライブラリ　
#   which wget make gcc gcc-c++ bzip2 git zlib-devel readline-devel libsasl2 libsasl2-dev cyrus-sasl-devel
# MySQL関連
#   mysql mysql-devel
# SSH関連
#   openssl openssl-devel openssh-server
# ImageMagick関連
#   ImageMagick ImageMagick-devel
# ipa***　日本語
RUN yum install -y epel-release which wget make gcc gcc-c++ bzip2 git zlib-devel readline-devel libsasl2 libsasl2-dev cyrus-sasl-devel mysql mysql-devel openssl openssl-devel openssh-server ImageMagick ImageMagick-devel libxml2 libxml2-devel libxslt libxslt-devel ipa-gothic-fonts ipa-mincho-fonts

## システムの設定
RUN cp -p /usr/share/zoneinfo/Japan /etc/localtime

RUN echo "PATH=\$PATH:/usr/local/bin" >> /root/.bashrc
RUN echo "export PATH" >> /root/.bashrc

#RUN yum install -y patch

# rbenvインストール
RUN git clone https://github.com/rbenv/rbenv.git /root/.rbenv
RUN cd /root/.rbenv && git pull origin master
RUN git clone https://github.com/rbenv/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN cd /root/.rbenv/plugins/ruby-build && git pull origin master

RUN echo 'eval "$(rbenv init -)"' >> $HOME/.profile
RUN echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc
RUN source $HOME/.profile
RUN source $HOME/.bashrc

RUN rbenv install 2.5.3
RUN rbenv rehash
RUN rbenv global 2.5.3

# nodebrew + nodejsインストール
ENV NODE_VERSION 8.4.0
RUN wget git.io/nodebrew
RUN perl nodebrew setup
ENV PATH $HOME/.nodebrew/current/bin:$PATH
RUN echo 'export PATH=$HOME/.nodebrew/current/bin:$PATH' >> $HOME/.bashrc
RUN source $HOME/.bashrc && nodebrew install-binary $NODE_VERSION
RUN source $HOME/.bashrc && nodebrew use $NODE_VERSION

# gem update
#RUN gem update --system
RUN gem install bundler

# ワーキングディレクトリの設定
RUN mkdir -p /var/www/html/karitoke
WORKDIR /var/www/html/karitoke

# gemfileを追加する
ADD Gemfile /var/www/html/karitoke/Gemfile
ADD Gemfile.lock /var/www/html/karitoke/Gemfile.lock

# bundle install
#RUN bundle update
RUN bundle install --retry 3

ADD . /var/www/html/karitoke

#CMD ["bundle","exec","rails","s","-b","0.0.0.0","-p","3000"]
