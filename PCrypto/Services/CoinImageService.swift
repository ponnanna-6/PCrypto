import Foundation
import UIKit
import Combine

class CoinImageService {
    @Published var image: UIImage? = nil
    
    var imageSubscription: AnyCancellable?
    var coin: CoinModel?
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinImage(urlString: coin.image)
    }
    
    private func getCoinImage (urlString: String) {
        guard let url = URL(string: urlString) else {return}
        
        imageSubscription = NetworkingManger.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManger.handleCompletion , receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
                self?.imageSubscription?.cancel()
            })
    }
}
