# Docker Compose で、 ElasticSearch の VectorStore(ベクトル検索・Store)を作成する

## アプリ概要 (Summary)

1. ElasticSearch とは、Elastic 社により開発された OSS の分散型検索エンジンおよびデータベースです。

  - 大規模なテキストデータや構造化データの索引付け、検索、および分析を行うための強力なツールとして広く利用されています。

  - Lucene という Java ベースの検索エンジンライブラリをベースにしており、高速で柔軟な「全文検索機能」を提供します。

  - JSON ベースの検索/分析エンジンで、登録したドキュメントから目的の単語を含むドキュメントを高速に検索することができます。

  - 基本的に Elasticsearch では Restful API を使って操作します。

2. Kibana とは、Elastic 社により開発された OSS のデータ可視化ツールです。

  - Elasticsearch のデータ可視化や、"Elastic Stack"のプロダクト群(Elasticsearch, Logstash, Beats)の制御のために利用されるフロントエンドツールです。

  - ログ分析やアプリケーションのモニタリングなどのユースケースに使われるデータ可視化ツールです。

  - ヒストグラム、線グラフや地図のサポートなど、強力で使いやすい機能を提供します。

  - Kibana は、Elasticsearch と緊密に統合されているため、Elasticsearch に保存されているデータを可視化するためのデフォルトの選択肢になります。

3. Eland とは、Elasticが提供するPythonライブラリで、ElasticsearchのデータとPyTorchやscikit-learn などのPythonの充実した機械学習ライブラリを連携させるための機能を提供しています。

  - このElandにバンドルされる`eland_import_hub_model`というコマンドラインツールを利用すると、Hugging Faceで公開されているNLPモデルをElasticsearchにインポートすることができます。


## 前提条件

- [Elasticsearch の Machine Learning 機能を使ったベクトル検索](https://zenn.dev/fujimotoshinji/scraps/69d07284ec712e)にあるとおり、Machine Learning を利用するためにトライアルライセンスを有効化する必要があります。

- つまり、ベクトル検索機能は、有料なので、要注意です。

## 環境構築・コマンド操作

### 起動コマンド

```bash
docker-compose up --build
```

### NLPモデルのインポート

- 日本語の文章を数値列にエンベッド（ベクトル化）するためのモデルをHugging Faceで選定して導入します。

- 詳細は、参考の 6, 7, 8あたりを確認してください。

```bash
docker-compose run eland eland_import_hub_model \
  --url http://host.docker.internal:9200/ \
  --hub-model-id cl-tohoku/bert-base-japanese-v2 \
  --task-type text_embedding \
  --start
```

### 停止コマンド

```bash
docker compose down
```

### 起動後の Access URL

1. Elasticsearch： http://localhost:9200

2. Kibana： http://localhost:5601

## トラブル・シューティング

### Kibana の起動・Error

1. `Kibana server is not ready yet`

- 8 系のセキュリティが厳格化されたことに伴った Error

- ElasticSearch の環境変数である`xpack.security.enabled`を`false`にすることで、セキュリティ機能を 7 系と同様にすることで解決。

- セキュリティレベルを上げる場合は、[公式の ElasticSearch・8 系を Docker で構築する手順](https://www.elastic.co/guide/en/elasticsearch/reference/8.0/docker.html)を参考にする。

## 【参考・引用】

1. [ElasticSearch の情報調査・まとめ](https://zenn.dev/manase/scraps/23cedb41bf364b)

2. [Docker Hub Elasticsearch](https://hub.docker.com/_/elasticsearch/)

3. [ElasticSearch の環境を Docker を使って構築してみる](https://zenn.dev/komisan19/articles/f752c0d0299a92)

4. [Elasticsearch + Kibana ローカル環境構築方法メモ](https://qiita.com/KWS_0901/items/c300b5ee010cb48dbaa3)

5. [Docker で、Error load build context no space left on device というエラーの解決方法](https://zenn.dev/aiq_dev/articles/931a8f58f80359)

6. [Elasticsearchで日本語NLPモデルを利用してセマンティック検索を実現する](https://www.elastic.co/jp/blog/elasticsearch-nlp-ja)

7. [Elasticsearch v8.9 で実装した日本語NLP、ベクトル検索（セマンティック検索）を使ってみる](https://qiita.com/daixque/items/931b8be343075b835097)

8. [Elasticsearch の Machine Learning 機能を使ったベクトル検索](https://zenn.dev/fujimotoshinji/scraps/69d07284ec712e)

9. [elastic/eland](https://github.com/elastic/eland)

10. [Docker Elastic Eland Info](https://www.docker.elastic.co/r/eland)

