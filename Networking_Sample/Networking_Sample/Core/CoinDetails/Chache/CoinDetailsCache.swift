//
//  CoinDetailsCache.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/02/06.
//

import Foundation

class CoinDetailsCache {
    
    static let shared = CoinDetailsCache()
    
    // キャッシュオブジェクトを作成します。キーはNSString型、値はNSData型です。
    private let cache = NSCache<NSString, NSData>()
    
    // 外部からの初期化を防ぐために、イニシャライザをprivateにしています。これにより、sharedプロパティを通じてのみインスタンスにアクセスできます。
    private init() {}
    
    // coinDetails : 保存するコインの情報
    // key : キャッシュキー
    func set(_ coinDetails: CoinDetails, forKey key: String) {
         // coinDetailsをJSON形式にエンコードします。
        guard let data = try? JSONEncoder().encode(coinDetails) else { return }
        // エンコードされたデータをキャッシュに保存します。
        // キーと値は、NSCacheが要求する型にキャストしています。
        cache.setObject(data as NSData, forKey: key as NSString)
    }
    
    // key : 取得したい情報のキャッシュキー
    func get(forKey key: String) -> CoinDetails? {
        // 指定されたキーでキャッシュからデータを取得し、Data型にキャストします。
        guard let data = cache.object(forKey: key as NSString) as? Data else { return nil }
        // 取得したデータをCoinDetails型にデコードし、失敗した場合はnilを返します。
        return try? JSONDecoder().decode(CoinDetails.self, from: data)
    }
}
