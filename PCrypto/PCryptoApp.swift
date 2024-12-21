//
//  PCryptoApp.swift
//  PCrypto
//
//  Created by Logycent on 19/12/2024.
//

import SwiftUI

@main
struct PCryptoApp: App {
    @StateObject private var vm = HomeViewModel ()
    
    var body: some Scene {
        WindowGroup {
            NavigationView() {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
