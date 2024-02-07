//
//  CoinRowView.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/02/06.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: Coin
    
    var body: some View {
        NavigationLink(value: coin) {
            HStack(spacing: 12) {
                
                Text("\(coin.marketCapRank)")
                    .foregroundColor(.gray)
                
                // URLデータに変換後、AsyncImageにURLを渡して画像をロード
                if let url = URL(string: coin.image) {
                    
                    AsyncImage(url: url) { image in
                        // 取得した画像ビュー
                        image
                            .resizable()
                            .frame(width: 40, height: 40)
                    } placeholder: {
                        // プレースホルダーのビュー
                        ProgressView()
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(coin.name)
                        .fontWeight(.semibold)
                    // uppercased : 大文字
                    Text(coin.symbol.uppercased())
                }
                .foregroundColor(.black)
                
                Spacer()
                
                // coin price info
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(coin.currentPrice.toCurrency())")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Text(coin.priceChangePercentage24H.toPercent())
                        .font(.caption)
                        .foregroundColor(coin.priceChangePercentage24H > 0 ? .green : .red)
                }
            }
            .padding(.horizontal)
            .font(.footnote)
        }
    }
}
