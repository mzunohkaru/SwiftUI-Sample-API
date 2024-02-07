//
//  CoinDetails.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/02/05.
//

import Foundation

struct CoinDetails: Codable {
    let id: String
    let symbol: String
    let name: String
    let description: Description
}

struct Description: Codable {
    let descriptionText: String
    
    enum CodingKeys: String, CodingKey {
        case descriptionText = "en"
    }
}
