//
//  CoinDetailsViewModel.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/02/06.
//

import Foundation

class CoinDetailsViewModel: ObservableObject {
    
    private let service: CoinServiceProtocol
    
    private let coidId: String
    
    @Published var coinDetails: CoinDetails?
    
    init(coidId: String, service: CoinServiceProtocol) {
        self.service = service
        self.coidId = coidId
    }
    
    @MainActor
    func fetchCoindDetails() async {
        do {
            self.coinDetails = try await service.fetchCoinDetails(id: coidId)
        } catch {
            print("DEBUG: Error \(error.localizedDescription)")
        }
    }
}
