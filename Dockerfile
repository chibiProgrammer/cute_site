# ruby2.6.5を使用する
FROM ruby:2.6.5
# インストール可能なパッケージの一覧を更新, -qq: エラー以外は表示しない : nodejsをインストール, -y: 処理中にあわられるプロンプトに対して全てYesと解答
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
########################################################################
# yarnパッケージ管理ツールをインストール
RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn
# Node.jsをインストール
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
apt-get install nodejs
#######################################################################
# ファイルを作成する
RUN mkdir /kawaii
# 作業ディレクトリを設定する
WORKDIR /kawaii
# ローカルのファイルをコンテナにコピー
COPY Gemfile /kawaii/Gemfile
COPY Gemfile.lock /kawaii/Gemfile.lock
# bundle installを実行
RUN bundle install
# ローカルのファイルをコンテナにコピー
COPY . /kawaii

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
# :chmod +x すべてのユーザーに実行権限を与える, 
RUN chmod +x /usr/bin/entrypoint.sh
# 一番最初に実行するコマンド
ENTRYPOINT ["entrypoint.sh"]
# コンテナがリッスンするport番号
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]