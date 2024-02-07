//
//  CoinsViewModelTests.swift
//  Networking_SampleTests
//
//  Created by Mizuno Hikaru on 2024/02/06.
//

import XCTest
// XCTestフレームワークをインポートし、Networking_Sampleモジュールからテスト対象をインポートしています。
// @testableキーワードにより、internalスコープの要素にアクセスできます。
@testable import Networking_Sample

class CoinsViewModelTests: XCTestCase {

    // CoinsViewModelの初期化をテストするメソッド
    func testInit() {
        // 実際のCoinServiceの代わりにテストで使用されます
        let service = MockCoinService()
        let viewModel = CoinsViewModel(service: service)
        
        // viewModelがnilでないことを確認
        XCTAssertNotNil(viewModel, "The view model should not be nil")
    }
    
    // CoinsViewModelがコインのデータを正常に取得できるかをテストするメソッド
    func testSuccessfullCoinsFetch() async {
        let service = MockCoinService()
        let viewModel = CoinsViewModel(service: service)
        
        // コインのデータの取得
        await viewModel.fetchCoins()
        // viewModelのcoins配列にコインが1つ以上含まれていることを確認
        XCTAssertTrue(viewModel.coins.count > 0) // ensures taht coins array has coins
        // viewModelのcoins配列に正確に5つのコインが含まれていることを確認
        XCTAssertEqual(viewModel.coins.count, 5) // ensures that all coins were decoded
        // viewModelのcoins配列がmarketCapRankに基づいて正しくソートされていることを確認
        XCTAssertEqual(viewModel.coins, viewModel.coins.sorted(by: { $0.marketCapRank < $1.marketCapRank })) // ensures sorting order
    }
    
    // 不正なJSONデータを使用してコインのデータ取得を試みた場合の挙動をテストするメソッド
    func testCoinFetchWithInvalidJSON() async {
        let service = MockCoinService()
        // MockCoinServiceのmockDataプロパティに不正なJSONデータを設定
        service.mockData = mockCoins_invalidJSON
        
        let viewModel = CoinsViewModel(service: service)
        
        await viewModel.fetchCoins()
        // viewModelのcoins配列が空であることを確認
        // 不正なデータではコインのデータを取得できないため、配列は空になります
        XCTAssertTrue(viewModel.coins.isEmpty)
        // viewModelのerrorMessageがnilでないことを確認
        // 不正なJSONデータを使用した場合、エラーメッセージが設定されるべきです。
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    // 不正なデータエラーを投げるかどうかをテストするメソッド
    func testThrowsInvalidDataError() async {
        let service = MockCoinService()
        // MockCoinServiceのmockErrorプロパティにinvalidDataエラーを設定
        service.mockError = CoinAPIError.invalidData
        
        let viewModel = CoinsViewModel(service: service)
        // viewModelのfetchCoinsメソッドを呼び出しています。このとき、設定されたエラーが使用されます。
        await viewModel.fetchCoins()
        // viewModelのerrorMessageがnilでないことを確認
        XCTAssertNotNil(viewModel.errorMessage)

        // viewModelのerrorMessageがCoinAPIError.invalidDataのcustomDescriptionと等しいことを確認しています。
        // これにより、適切なエラーメッセージが設定されているかをテストします。
        XCTAssertEqual(viewModel.errorMessage, CoinAPIError.invalidData.customDescription)
    }
    
    // 不正なステータスコードエラーを投げるかどうかをテストするメソッド
    func testThrowsInvalidStatusCode() async {
        let service = MockCoinService()
        // MockCoinServiceのmockErrorプロパティにinvalidStatusCodeエラーを設定しています。
        // このエラーは、HTTPステータスコード404を持っています。
        service.mockError = CoinAPIError.invalidStatusCode(statusCode: 404)
        
        let viewModel = CoinsViewModel(service: service)
        // viewModelのfetchCoinsメソッドを非同期的に呼び出しています。このとき、設定されたエラーが使用されます。
        await viewModel.fetchCoins()
        // viewModelのerrorMessageがnilでないことを確認
        XCTAssertNotNil(viewModel.errorMessage)
        // viewModelのerrorMessageがCoinAPIError.invalidStatusCode(statusCode: 404)のcustomDescriptionと等しいことを確認しています。
        // これにより、適切なエラーメッセージが設定されているかをテストします。
        XCTAssertEqual(viewModel.errorMessage, CoinAPIError.invalidStatusCode(statusCode: 404).customDescription)
    }
}
