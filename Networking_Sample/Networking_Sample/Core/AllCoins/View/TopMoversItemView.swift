//
//  TopMoversItemView.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/02/06.
//

import SwiftUI

struct TopMoversItemView: View {
    let coin: Coin
    
    var body: some View {
        VStack(alignment: .leading) {
            // image
            AsyncImage(url: URL(string: coin.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.orange)
            } placeholder: {
                ProgressView()
            }
            
            // coin info
            HStack(spacing: 2) {
                Text(coin.symbol.uppercased())
                    .fontWeight(.bold)
                
                Text("\(coin.currentPrice.toCurrency())")
                    .foregroundColor(.gray)
            }
            .font(.caption)
            
            // coin percent change
            Text(coin.priceChangePercentage24H.toPercent())
                .font(.title2)
                .foregroundColor(coin.priceChangePercentage24H > 0 ? .green : .red)
        }
        .frame(width: 140, height: 140)
        .background(Color("ItemBackgroundColor"))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray4), lineWidth: 2)
        }
    }
}
