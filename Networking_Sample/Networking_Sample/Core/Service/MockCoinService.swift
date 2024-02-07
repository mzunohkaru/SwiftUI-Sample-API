//
//  MockCoinService.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/02/06.
//

import Foundation

class MockCoinService: CoinServiceProtocol {
    
    var mockData: Data?
    var mockError: CoinAPIError?
    
    func fetchCoins() async throws -> [Coin] {
        if let mockError { throw mockError }
        do {
            // コインのリストをデコード
            // mockDataがnilの場合は、デフォルトのデータmockCoinData_marketCapDescを使用
            let coins = try JSONDecoder().decode([Coin].self, from: mockData ?? mockCoinData_marketCapDesc)
            return coins
        } catch {
            // エラーをCoinAPIErrorに変換してスロー
            throw error as? CoinAPIError ?? .unknownError(error: error)
        }
    }
    
    func fetchCoinDetails(id: String) async throws -> CoinDetails? {
        let description = Description(descriptionText: "Test Description")
        let bitcoinDetails = CoinDetails(id: "bitcoin", symbol: "btc", name: "Bitcoin", description: description)
        return bitcoinDetails
    }
    
    func doSomething() {
        print("Do stuff")
    }
}
