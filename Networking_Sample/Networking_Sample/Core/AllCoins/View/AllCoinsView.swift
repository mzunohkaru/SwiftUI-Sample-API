//
//  AllCoinsView.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/02/06.
//

import SwiftUI

struct AllCoinsView: View {
    
    @StateObject var viewModel: CoinsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("All Coins")
                .font(.headline)
                .padding()
            
            HStack {
                Text("Coin")
                
                Spacer()
                
                Text("Price")
                    .font(.footnote)
            }
            .font(.caption)
            .foregroundColor(.gray)
            .padding(.horizontal)
            
            ScrollView {
                ForEach(viewModel.coins) { coin in
                    CoinRowView(coin: coin)
                        .onAppear {
                            if coin == viewModel.coins.last {
                                print("DEBUG: Paginate here..")
                                Task { await viewModel.fetchCoins()}
                            }
                        }
                }
            }
        }
    }
}
