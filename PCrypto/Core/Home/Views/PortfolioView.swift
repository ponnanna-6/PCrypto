import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var homeVM: HomeViewModel

    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $homeVM.seachText)
                    coinLogoList

                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButtton
                }
            })
            .onChange(of: homeVM.seachText) { value in
                if value == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVm)
    }
}

extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(homeVM.seachText.isEmpty ? homeVM.portfolioCoins : homeVM.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    selectedCoin?.id == coin.id
                                        ? Color.theme.green : Color.clear
                                )
                        )
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
    }

    private var portfolioInputSection: some View {
        VStack {
            HStack {
                Text("Current price of \(selectedCoin?.symbol ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current Value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }

    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }

    private var trailingNavBarButtton: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0)
            Button {
                saveButtonPress()
            } label: {
                Text("save".uppercased())
            }
            .opacity(
                (selectedCoin != nil
                    && selectedCoin?.currentHoldings != Double(quantityText))
                    ? 1.0 : 0.0)
        }
        .font(.headline)
    }

    private func saveButtonPress() {
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
        else { return }

        //save buttton code
        homeVM.updatePortfolio(coin: coin, amount: amount)

        //show checkmark
        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelectedCoin()
        }

        UIApplication.shared.endEditing()

        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeIn) {
                showCheckMark = false
            }
        }
    }

    private func removeSelectedCoin() {
        selectedCoin = nil
        homeVM.seachText = ""
    }

    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin

        if let portfolioCoin = homeVM.portfolioCoins.first(where: {
            $0.id == coin.id
        }) {
            if let amount = portfolioCoin.currentHoldings {
                quantityText = amount>0 ? "\(amount)" : ""
            }
        } else {
            quantityText = ""
        }
    }
}
