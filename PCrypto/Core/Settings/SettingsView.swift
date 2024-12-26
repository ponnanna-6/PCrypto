//
//  SettingsView.swift
//  PCrypto
//
//  Created by Logycent on 26/12/2024.
//

import SwiftUI

struct SettingsView: View {
    
    let gitURL = URL(string: "https://github.com/ponnanna-6")!
    let coinGeckoURL = URL(string: "https://www.coingecko.com")!
    let repoURL = URL(string: "https://github.com/ponnanna-6/PCrypto")!
    let linkdinURL = URL(string: "https://in.linkedin.com/in/k-s-ponnanna")!
    let creditURL = URL(string: "https://www.swiftful-thinking.com")!

    
    var body: some View {
        NavigationView {
            List {
                aboutPCrypto
                coinGecko
                developerInfo
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}

extension SettingsView {
    private var aboutPCrypto: some View {
        Section(header: Text("About PCryto")) {
            VStack(alignment: .leading){
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("PCrypto is a live cryptocurrency app that fetches real-time data from the CoinGecko API, providing users with up-to-date information on various cryptocurrencies. The app displays key metrics such as price, market cap, and volume, helping users track the performance of their favorite coins in real time.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Github Repo 👾", destination: repoURL)
        }
    }
    
    private var coinGecko: some View {
        Section(header: Text("Coin gecko API")) {
            VStack(alignment: .leading){
                Image("coingecko")
                    .resizable()
                    .frame(width: .infinity, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("CoinGecko offers a comprehensive analysis of the crypto market, tracking price, volume and market capitalization. It provides access to its data through a free API, empowering developers and users with valuable insights.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit CoinGecko 🦎", destination: coinGeckoURL)
        }
    }
    
    private var developerInfo: some View {
        Section(header: Text("Developer"), footer: Text("@ ks-ponnanna")) {
            VStack(alignment: .leading){
                Text("Hey there! I'm Ponnanna, a passionate software engineer 👨‍💻. Feel free to connect with me below. Thank you!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit My GitHub 👾", destination: coinGeckoURL)
            Link("Connect on Linkedin 📘", destination: linkdinURL)
            Link("Contact Me 📫 - ponnanna200@gmail.com", destination: URL(string: "mailto:ponnanna200@gmail.com")!)
            
            HStack {
                Text("Credits to - ")
                Link("Swiftful-thinking", destination: creditURL)
            }
        }
    }
}
