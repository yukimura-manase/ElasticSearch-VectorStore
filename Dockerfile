# マルチステージビルドの初めに、Python 開発環境を構築
FROM python:3.8-slim-buster as python-builder

# Container内の /app を 作業ディレクトリとして指定する
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# 続いて、ElasticSearchの環境を構築する (ElasticSearch 8系)
FROM docker.elastic.co/elasticsearch/elasticsearch:8.10.2 AS elastic-builder

# Container内の /app を 作業ディレクトリとして指定する 
WORKDIR /app

# Python 開発環境から必要なファイルをコピー
COPY --from=python-builder /app /app

# ElasticSearch の日本語検索プラグイン「 analysis-kuromoji 」をインストールする
RUN elasticsearch-plugin install analysis-kuromoji
