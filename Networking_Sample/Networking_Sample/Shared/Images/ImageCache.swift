//
//  ImageCache.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/02/08.
//

import UIKit

class ImageCache {
    
    static let shared = ImageCache()
    
    // キャッシュオブジェクトを作成します。
    private let cache = NSCache<NSString, UIImage>()
    
    // 外部からの初期化を防ぐために、イニシャライザをprivateにしています。これにより、sharedプロパティを通じてのみインスタンスにアクセスできます。
    private init() {}
    
    func set(_ image: UIImage, forkey key: String) {
        // キーと値は、NSCacheが要求する型にキャストしています。
        cache.setObject(image, forKey: key as NSString)
    }
    
    // key : 取得したい情報のキャッシュキー
    func get(forkey key: String) -> UIImage? {
        // 指定されたキーでキャッシュからデータを取得し、NSString型にキャストします。
        return cache.object(forKey: key as NSString)
    }
}
