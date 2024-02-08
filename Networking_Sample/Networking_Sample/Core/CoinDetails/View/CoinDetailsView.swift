//
//  CoinDetailsView.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/02/05.
//

import SwiftUI

struct CoinDetailsView: View {
    
    let coin: Coin
    
//    @EnvironmentObject var viewModel: CoinsViewModel
//    
//    init(coin: Coin) {
//        self.coin = coin
//    }
    
    @ObservedObject var viewModel: CoinDetailsViewModel
    
    init(coin: Coin, service: CoinServiceProtocol) {
        self.coin = coin
        // CoinDetailsViewModelを生成する時に必要な coid.id を渡す
        self.viewModel = CoinDetailsViewModel(coidId: coin.id, service: service)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let details = viewModel.coinDetails {
                    HStack {
                        VStack {
                            Text(details.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text(details.symbol.uppercased())
                                .font(.footnote)
                        }
                        
                        Spacer()
                        
                        CoinImageView(url: coin.image)
                            .frame(width: 64, height: 64)
                    }
                    
                    Text(details.description.descriptionText)
                        .font(.footnote)
                        .padding(.vertical)
                    
                    Spacer()
                }
            }
            .task {
//                await viewModel.fetchCoinDetails(coinId: coin.id)
                await viewModel.fetchCoindDetails()
            }
            .padding()
        }
    }
}
