//
//  Networking_SampleApp.swift
//  Networking_Sample
//
//  Created by Mizuno Hikaru on 2024/01/15.
//

import SwiftUI

@main
struct Networking_SampleApp: App {
    
//    @StateObject var viewModel = CoinsViewModel(service: CoinDataService())
    
    var body: some Scene {
        WindowGroup {
//            ContentView(service: MockCoinService())
            
            ContentView(service: CoinDataService())
            
//            ContentView()
//                .environmentObject(viewModel)
        }
    }
}
