//
//  DetailView.swift
//  PCrypto
//
//  Created by Logycent on 25/12/2024.
//

import SwiftUI

struct DetailView: View {
    
    @Binding var coin: CoinModel?
    
    //to initialize view before coming here
    init(coin: Binding<CoinModel?>) {
        self._coin = coin
    }
    
    var body: some View {
        Text("\(coin?.name ?? "")")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: .constant(dev.coin))
    }
}
