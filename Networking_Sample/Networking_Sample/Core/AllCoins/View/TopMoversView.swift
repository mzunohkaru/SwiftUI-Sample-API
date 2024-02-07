//
//  TopMoversView.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/02/06.
//

import SwiftUI

struct TopMoversView: View {
    
    @StateObject var viewModel: CoinsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top Movers")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.topMovingCoins) { coin in
                        TopMoversItemView(coin: coin)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
