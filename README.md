This project was moved to the following repository.

https://github.com/Kibaan/AbstractHTTP-iOS


# AbstractHTTP


AbstractHTTP はHTTP通信とそれに付随する一連の処理を抽象化したライブラリです。

このライブラリ大部分がプロトコルでできており、**通信の実装というより設計や処理の流れを提供するもの**になっています。

※ 利便性のためプロトコルのデフォルト実装はいくつか含まれています

```
AbstractHTTP is abstract HTTP processing library.  
```

# プログラミングガイド


## 最小構成の通信サンプル (The simplest example)

`ConnectionSpec`(※)を継承したクラス（以下Specクラス）を作成して、リクエストとレスポンスの詳細を記載します。

Specクラスは１つのAPIの仕様を表します。REST通信であればURLとHTTPメソッドの組み合わせに対して１つSpecクラスを作成するのが良いでしょう。

ただし、リクエストパラメーターとレスポンスが同じようなAPIが複数あれば、まとめて１つのSpecクラスを作った方が便利かもしれません。

※ `ConnectionSpec`は`RequestSpec`、`ResponseSpec`２つのプロトコルを継承したプロトコルです。ConnectionSpecを作成する代わりに、RequestSpecを継承したクラスとResponseSpecを継承したクラスを、それぞれ別に作成することもできます。

```swift
// 最小構成のシンプルなConnectionSpec実装
class SimplestSpec: ConnectionSpec {
    // 通信で受取るデータの型を定義する
    typealias ResponseModel = String

    // リクエスト先のURL 
    var url: String { return "https://www.google.com/" }
    
    // リクエストのHTTPメソッド
    var httpMethod: HTTPMethod { return .get }
    
    // 送信するリクエストヘッダー
    var headers: [String: String] { return [:] }
    
    // URLに付けるクエリパラメーター（URL末尾の`?`以降につけるkey=value形式のパラメーター）
    var urlQuery: URLQuery? { return nil }

    // ポストするデータ（リクエストボディ）。GET通信など不要な場合はnilにする
    func makePostData() -> Data? { return nil }
    
    // レスポンスデータのパース前のバリデーション
    func isValidResponse(response: Response) -> Bool { return true }

    // 通信レスポンスをデータモデルに変換する
    func parseResponse(response: Response) throws -> ResponseModel {
        if let string = String(bytes: response.data, encoding: .utf8) {
            return string
        }
        throw ConnectionErrorType.parse
    }
}
```


```swift
let spec = SimplestSpec()
Connection(spec) { response in
    print(response)
}
```

## リクエスト仕様の共通化

ほとんどのプロジェクトでは複数のAPIに共通のリクエスト仕様があります。

例えば、API全体で同じUser-Agentを指定する

## JSON形式のREST APIの例

APIのレスポンスには様々な形式がありますが、アプリにおいて一番メジャーなJSON形式のAPIの実装例を記載します。


## 通信中にインジケーターを表示する

一つの通信だけであれば、通信開始時にインジケーターを表示して、終了時にインジケーターを消すだけでよいが、複数の通信が全て終わるまでインジケーターを出す場合はもう少し複雑になる。

この実装を誤ると、エラーのときインジケーターが消えなくなったり、逆に消えてほしくないタイミングで消えたり、といったバグにつながるので、参照カウント方式で管理する

## 共通のレスポンス処理

## リトライ

通信が失敗したときに自動でリトライしたり、エラーダイアログを出した上でリトライする実装。

単純に考えれば、送信したリクエストパラメーターを保存しておき、再び同じものをリクエストしてやればリトライになるが、例えばリクエストパラメーターに現在時刻を含めなければいけない場合など、全く同じリクエストでは問題があることもある。

そのため、リクエストパラメーターの構築処理からもう一度やり直す仕様にしている。
この仕様であれば全く同じリクエストを送ることはもちろん、リトライのときに一部のパラメータを変えることもできる。

例えば、404エラーやログインエラーをリトライしても、もう一度同じエラーになるだけで意味がない。
ネットワーク

## URLSessionによる通信実装

本ライブラリには標準でURLSessionを使った通信実装、`DefaultHTTPConnector` が組み込まれています。

通信内容を端末にキャッシュしない
invalidate
リダイレクトを無視する

## 401エラーが発生したらアクセストークンをリフレッシュ
再認証を組み込む

## 404エラーを正常系として扱う

データのリストを返すAPIが0件の場合に404エラーを返すことはたまにあります。

## 通信をモック化

## 通信のキャンセル
画面の離脱時に実行していた通信を全てキャンセルする

## ポーリング（自動更新）
通信が完了したら、N秒後に再度自動で通信を行う。
ポーリングをするには、ポーリングを継続、停止する条件を定める必要がある。

ネットワークエラーの場合はポーリングを行っていい

# APIインスタンスを保持する

リトライ、ポーリングなどのときも開放されないようにする
