import Foundation
import UIKit
import Combine

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let coin: CoinModel?
    private let imageDataSevice: CoinImageService?
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageDataSevice = CoinImageService(coin: coin)
        self.addSubcribers()
        self.isLoading = false
    }
    
    func addSubcribers() {
        imageDataSevice?.$image
            .sink { [weak self] (_) in
                self?.isLoading = true
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
    }
}
