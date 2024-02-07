//
//  Networking_SampleTests.swift
//  Networking_SampleTests
//
//  Created by Mizuno Hikaru on 2024/02/06.
//

import XCTest

@testable import Networking_Sample

final class Networking_SampleTests: XCTestCase {

    func test_DecodeCoinsIntoArray_marketCapDesc() throws {
        do {
            let coins = try JSONDecoder().decode([Coin].self, from: mockCoinData_marketCapDesc)
            XCTAssertTrue(coins.count > 0) // ensures taht coins array has coins
            XCTAssertEqual(coins.count, 5) // ensures that all coins were decoded
            
            XCTAssertEqual(coins, coins.sorted(by: { $0.marketCapRank < $1.marketCapRank })) // ensures sorting order
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
