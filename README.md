# PotepanEC (ECサイト)

## アプリケーションURL
- ホームページ：[http://www.stylishcoffee.work/potepan](http://www.stylishcoffee.work/potepan)
- 商品詳細ページ：[http://www.stylishcoffee.work/potepan/products/1](http://www.stylishcoffee.work/potepan/products/1)
- カテゴリーページ：[http://www.stylishcoffee.work/potepan/categories/1](http://www.stylishcoffee.work/potepan/categories/1)

## アプリケーションの概要

PotepanCamp課題で作成したECサイトです。

## アプリケーションの機能

- ホームページ
- 商品詳細ページ
    - 動的な商品の表示
    - 関連商品の表示
- カテゴリーページ
    - 動的なカテゴリーに所属する商品の一覧表示
    
## アプリケーションの使用技術

- インフラ
    - AWS EC2
        - Nginx
        - Unicorn
    - AWS VPC
    - AWS Route53
- データーベース
    - AWS RDS
- 画像アップロードライブラリ
    - PaperClip
    - AWS S3
- デプロイ
    - CircleCI
- テスト,品質管理
    - RSpec
    - RuboCop
- ECサイトフレームワーク
    - Solidus

## 開発環境
- RubyMine
- Ruby: v2.5.1
- Rails: v5.2.4
- Docker
    - Puma
    - Redis
    - MySQL
- Docker Compose
- ENTRYKIT
- CircleCI
- RuboCop
- RSpec
