//
//  ContentView.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/01/15.
//

import SwiftUI

struct ContentView: View {
    
    private let service: CoinServiceProtocol
    
    @StateObject var viewModel: CoinsViewModel
    
    init(service: CoinServiceProtocol) {
        self.service = service
        self._viewModel = StateObject(wrappedValue: CoinsViewModel(service: service))
    }
    
    //    @EnvironmentObject var viewModel: CoinsViewModel
    
    var body: some View {
        NavigationStack {
            
            // top movers view
            TopMoversView(viewModel: viewModel)
            
            Divider()
            
            // all coins view
            AllCoinsView(viewModel: viewModel)
            
                .navigationDestination(for: Coin.self, destination: { coin in
                    CoinDetailsView(coin: coin, service: service)
                })
            
            //            .overlay {
            //                if let error = viewModel.errorMessage {
            //                    Text(error)
            //                }
            //            }
                .onAppear {
                    if let error = viewModel.errorMessage {
                        print("DEBUG: Error message \(error)")
                    }
                }
        }
        .task {
            await viewModel.fetchCoins()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(service: MockCoinService())
    }
}
