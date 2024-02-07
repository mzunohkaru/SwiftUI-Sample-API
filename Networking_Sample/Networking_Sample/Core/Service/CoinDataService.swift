//
//  CoinDataService.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/01/16.
//

import Foundation

// protocol のメリット
// 異なるデータソースやAPIからコインデータを取得するための統一されたインターフェースを提供する
// データ取得のロジックを抽象化し、異なる実装間での互換性を保ちやすくする
protocol CoinServiceProtocol {
    
    func fetchCoins() async throws -> [Coin]
    
    func fetchCoinDetails(id: String) async throws -> CoinDetails?
}

class CoinDataService: CoinServiceProtocol, HTTPDataDownLoader {
    
    private var page = 0
    private var fetchLimit = 18
    
    init() {
        print("DEBUG: Did init service..")
    }
    
    func fetchCoins() async throws -> [Coin] {
        page += 1
        
        guard let endpoint = allCoinsURLString else {
            throw CoinAPIError.requestFailed(description: "Invalid endpoint")
        }
        //    private let endpoint = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=jpy&order=market_cap_desc&per_page=2&page=1&sparkline=true&price_change_percentage=24h&locale=ja"
        
        return try await fetchData(as: [Coin].self, endpoint: endpoint)
    }
    
    func fetchCoinDetails(id: String) async throws -> CoinDetails? {
        if let cached = CoinDetailsCache.shared.get(forKey: id) {
            print("DEBUG: Got details from cache")
            return cached
        }
        
        //        let endpoint = "https://api.coingecko.com/api/v3/coins/\(id)?localization=false"
        guard let endpoint = coinDetailsURLString(id: id) else {
            throw CoinAPIError.requestFailed(description: "Invalid endpoint")
        }
        
        let details = try await fetchData(as: CoinDetails.self, endpoint: endpoint)
        print("DEBUG: Got details from API")
        CoinDetailsCache.shared.set(details, forKey: id)
        return details
    }
    
    private var baseUrlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coingecko.com"
        components.path = "/api/v3/coins/"
        
        return components
    }
    
    private var allCoinsURLString: String? {
        var components = baseUrlComponents
        components.path += "markets"
        
        components.queryItems = [
            .init(name: "vs_currency", value: "jpy"),
            .init(name: "order", value: "market_cap_desc"),
            .init(name: "per_page", value: "\(fetchLimit)"),
            .init(name: "page", value: "\(page)"),
            .init(name: "price_change_percentage", value: "24h"),
            .init(name: "locale", value: "ja")
        ]
        
        return components.url?.absoluteString
    }
    
    private func coinDetailsURLString(id: String) -> String? {
        var components = baseUrlComponents
        components.path += "\(id)"
        
        components.queryItems = [
            .init(name: "localization", value: "false")
        ]
        
        return components.url?.absoluteString
    }
}

// MARK: - Completion Handlers

extension CoinDataService {
    
    func fetchCoinsWithResult(completion: @escaping(Result<[Coin], CoinAPIError>) -> Void){
        guard let url = URL(string: allCoinsURLString ?? "") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(.unknownError(error: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "Request failed")))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                completion(.success(coins))
            } catch {
                print("DEBUG: Failed to decode with error \(error)")
                completion(.failure(.jsonParsingFailure))
            }
        }.resume()
    }
    
    
    // 引数は、Coinの配列を返すことを意味する
    func fetchCoins(completion: @escaping([Coin]?, Error?) -> Void){
        guard let url = URL(string: allCoinsURLString ?? "") else { return }
        
        URLSession.shared.dataTask(with: url) { data, respose, error in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            
            //            let dataAsString = String(data: data, encoding: .utf8)
            //            print("DEBUG: Coin data \(dataAsString)")
            
            guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
                print("DEBUG: Failed to decode coins")
                return
            }
            
            completion(coins, nil)
        }.resume()
    }
    
    
    func fetchPrice(coin: String, completion: @escaping(Double) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("DEBUG: Failed with error \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            guard httpResponse.statusCode == 200 else { return }
            
            guard let data = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            guard let value = jsonObject[coin] as? [String: Double] else {
                print("Failed to parse value")
                return
            }
            guard let price = value["usd"] else { return }
            
            completion(price)
        }.resume()
    }
}
