//
//  Coin.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/01/16.
//

import Foundation

struct Coin: Codable, Identifiable, Hashable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let marketCapRank: Int
    let priceChangePercentage24H: Double
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
        case priceChangePercentage24H = "price_change_percentage_24h"
    }
}
