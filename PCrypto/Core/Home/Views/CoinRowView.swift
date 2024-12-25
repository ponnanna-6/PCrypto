//
//  CoinRowView.swift
//  PCrypto
//
//  Created by Logycent on 21/12/2024.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinModel
    let showHolding: Bool
    var body: some View {
        HStack(spacing: 0){
            leftSection
            
            Spacer()
            
            if showHolding {
                centerSection
            }
            
            rightSection
        }
        .font(.subheadline)
        .background(Color.theme.background)
    }
}

extension CoinRowView {
    var leftSection: some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 20)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .padding(.leading, 2)
        }
    }
    
    var centerSection: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString2Places())
        }
        .foregroundColor(Color.theme.accent)
    }
    
    var rightSection: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentage() ?? "")
                .foregroundColor(coin.priceChangePercentage24H ?? 0 >= 0 ? Color.theme.green : Color.theme.red)
        }
        .frame(width: UIScreen.main.bounds.width/3, alignment: .trailing)
    }
}

struct CoiRowView_Preview: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.coin, showHolding: dev.coin.currentHoldings ?? 0 >= 0)
    }
}
