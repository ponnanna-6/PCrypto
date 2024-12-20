//
//  ContentView.swift
//  PCrypto
//
//  Created by Logycent on 19/12/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("Accent")
                    .foregroundColor(Color.theme.accent)
                Text("Red")
                    .foregroundColor(Color.theme.red)
                Text("Green")
                    .foregroundColor(Color.theme.green)
                Text("Second")
                    .foregroundColor(Color.theme.secondaryText)
            }
            .font(.headline)
            
        }
    }
}

#Preview {
    ContentView()
}
