//
//  HTTPDataDownloader.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/02/06.
//

import Foundation

protocol HTTPDataDownLoader {
    func fetchData<T: Decodable>(as type: T.Type, endpoint: String) async throws -> T
}

extension HTTPDataDownLoader {
    // throws : 付与された関数等は、エラーを投げる可能性があることを示します
    //          関数の実行中に何らかの問題が発生した場合に、通常の戻り値の代わりにエラーを返すことを意味します
    func fetchData<T: Decodable>(as type: T.Type, endpoint: String) async throws -> T {
        
        guard let url = URL(string: endpoint) else {
            throw CoinAPIError.requestFailed(description: "Invalid URL")
        }
        
        // URLからデータを非同期に取得する
        // try : throwsが付与された関数、メソッド、イニシャライザを呼び出す際に使用されます
        //       呼び出し元はその関数等がエラーを投げる可能性があることを認識できます
        // try : エラーを捕捉するためにdo-catchブロック内で使用されます
        // try? : エラーが発生した場合にnilを返し、そうでなければオプショナル値を返します
        // try! : エラーが発生しないことが確実である場合に使用され、エラーが発生した場合はランタイムエラーを引き起こします
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // 取得したレスポンスがHTTPレスポンスかどうかを確認
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CoinAPIError.requestFailed(description: "Request failed")
        }
        guard httpResponse.statusCode == 200 else {
            throw CoinAPIError.invalidStatusCode(statusCode: httpResponse.statusCode)
        }
        
        // doブロック内でtryを使用してエラーを投げるコードを実行し、catchブロックでそのエラーを捕捉して処理します
        do {
            // データをtype (Coinオブジェクトなど) の配列にデコードしている
            //         JSONDecoder().decode([Coin].self, from: data)
            //         JSONDecoder().decode(CoinDetails.self, from: data)
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("DEBUG: Error \(error)")
            // デコード中にエラーが発生した場合
            throw error as? CoinAPIError ?? .unknownError(error: error)
        }
    }
}
