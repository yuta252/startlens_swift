## Startlensモバイルアプリ

### アプリ概要

Startlensアプリケーションにおける旅行者が旅なかで利用する観光用アプリ。

これまではWeb (http://www.startlens.jp/) からオンライン観光として観光地を検索・閲覧することを想定していましたが、iOS向けにモバイルアプリから閲覧することができるようにしました。
また、観光中にモバイルでの利用を想定していることから、事前に登録した観光地の対象物をモバイルカメラで撮影した際に画像認識するシステムを実装しました。これにより観光ガイドなしで旅行を楽しむことができます。


### ターゲットユーザー

- StartlensのWebアプリ (http://www.startlens.jp/) に登録している旅行者
  - デモアカウント Email: test@startlens.com, Password: startlens
  - 上記のデモアカウントを利用してiOSアプリケーションヘのログインが可能
  

## 開発環境

XCode:     12.4
Swift:    5.3.2

## アプリ画面

![screen1](https://user-images.githubusercontent.com/42575165/112249591-6b1fd580-8c9b-11eb-96d1-db0afb3f63e1.png)


![screen2](https://user-images.githubusercontent.com/42575165/112249602-6fe48980-8c9b-11eb-879f-a216e2d78126.png)


## 機能

- 画像認識機能
  - Tensorflow liteを利用しモバイル端末上でDeepLearning（mobileNet)の推論処理を行う
  - 推論結果のベクトル情報をAPIでバックエンドサーバー (https://github.com/yuta252/startlens_learning) に送信しKNN法を利用して類似画像を取得する
- JWTトークンを利用したログイン認証機能及び新規登録機能
- アンケート機能（アンケートによるユーザーの属性を訪問者ログとして観光事業者でデータビジュアライズする）
- 観光地一覧及び場所(現在地)・カテゴリーによる検索機能
- お気に入り機能
- 観光地詳細情報の閲覧及びレビューの投稿機能


## APIサーバー

- https://github.com/yuta252/startlens_learning



## 使用素材

- [Unsplash](https://unsplash.com/)






