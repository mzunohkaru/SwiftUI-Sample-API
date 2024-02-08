//
//  CoinsViewModel.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/01/15.
//

import Foundation

/// ViewModelは MVVM というアーキテクチャパターンの一部で、データとビジネスロジックを管理します

class CoinsViewModel: ObservableObject {
    
    @Published var coins = [Coin]()
    @Published var errorMessage: String?
    @Published var coinDetails: CoinDetails?
    
    @Published var topMovingCoins = [Coin]()
    
    // 仮想通貨のデータを取得するためのサービス
    private let service: CoinServiceProtocol // CoinDataService タイプであることを宣言しますが、この行ではインスタンスを割り当てません
//    private let service = CoinDataService() // CoinDataService クラスの新しいインスタンスで初期化
    
    init(service: CoinServiceProtocol) {
        self.service = service
    }
    
    @MainActor
    func fetchCoins() async { 
        do {
            // 非同期で仮想通貨のデータを取得し、取得したデータをcoinsに格納
            let coins = try await service.fetchCoins()
            self.coins.append(contentsOf: coins)
            configureTopMovingCoins()
            
        } catch {
            guard let error = error as? CoinAPIError else { return }
            self.errorMessage = error.customDescription
        }
    }
    // throws : 外部 (呼び出し元) にエラーを投げる

//    @MainActor
//    func fetchCoinDetails(coinId: String) async {
//        do {
//            self.coinDetails = try await service.fetchCoinDetails(id: coinId)
//        } catch {
//            print("DEBUG: Error \(error.localizedDescription)")
//        }
//    }
    
    func configureTopMovingCoins() {
        // 価格変動が激しい順に配列に格納
        let topMovers = coins.sorted(by: { $0.priceChangePercentage24H > $1.priceChangePercentage24H })
        // 配列の中から、上から5つの要素を格納
        self.topMovingCoins = Array(topMovers.prefix(5))
    }
    
    /*
    func fetchCoinsWithCompletionHandler() {
        /* [weak self] 
        クロージャは自身がキャプチャしたものを強く参照します。
        つまり、クロージャが存在する限り、キャプチャしたものはメモリから解放されません。
        これが問題となるのは、クロージャが自身を含むオブジェクトをキャプチャした場合です。
        この場合、オブジェクトとクロージャが互いに強く参照し合うため、
        どちらもメモリから解放されない状態、つまりメモリリークが発生します。

        [weak self]を使用すると、クロージャは自身を弱く参照します。
        これにより、クロージャが存在してもオブジェクトはメモリから解放され、メモリリークが防止されます。

        ただし、selfが弱く参照されるため、クロージャが実行される時点でselfがすでに解放されている可能性があります。
        そのため、クロージャ内でselfを使用する際にはオプショナルとして扱われ、self?.という形でアクセスします。
        */

        service.fetchCoinsWithResult { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let coins):
                    self?.coins = coins
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
     */
}
