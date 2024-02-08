//
//  ImageLoader.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/02/08.
//

import SwiftUI

class ImageLoader: ObservableObject {
    
    @Published var image: Image?
    
    private let urlString: String
    
    init(url: String) {
        // 外部から画像のURLを文字列として受け取り, urlStringプロパティに格納
        self.urlString = url
        Task { await loadImage() }
    }
    
    @MainActor
    private func loadImage() async {
        // 指定されたURLのキーでキャッシュを確認
        if let cached = ImageCache.shared.get(forkey: urlString) {
            // キャッシュに画像が存在する場合
            print("DEBUG: Did fetch image from cache..")
            self.image = Image(uiImage: cached)
            return
        }
        // URLが有効であることを確認
        guard let url = URL(string: urlString) else { return }
        
        do {
            // 画像データをダウンロード
            let (data, _) = try await URLSession.shared.data(from: url)
            
            print("DEBUG: Did receive data from endpoint..")

            guard let uiImage = UIImage(data: data) else { return }
            // ダウンロードした画像をキャッシュに保存
            ImageCache.shared.set(uiImage, forkey: urlString)
            // ダウンロードした画像でimageプロパティを更新
            self.image = Image(uiImage: uiImage)
        } catch {
            print("DEBUG: Failed to fetch image with error \(error)")
        }
    }
}
