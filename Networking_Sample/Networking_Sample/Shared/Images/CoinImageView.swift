//
//  CoinImageView.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/02/08.
//

import SwiftUI

struct CoinImageView: View {
    
    @ObservedObject var imageLoader: ImageLoader
    
    init(url: String) {
        self.imageLoader = ImageLoader(url: url)
    }
    
    var body: some View {
        if let image = imageLoader.image {
            image
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    CoinImageView(url: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400")
}
