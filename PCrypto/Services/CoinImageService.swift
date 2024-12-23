import Foundation
import UIKit
import Combine
import SwiftUI

class CoinImageService {
    @Published var image: UIImage? = nil
    private let fileManager = LocalFileManager.instance
    private let imageFolderName = "coin_images"
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage () {
        if let savedImage = fileManager.getImage(imageName: self.imageName, folderName: imageFolderName) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage () {
        guard let url = URL(string: coin.image) else { return}
        
        imageSubscription = NetworkingManger.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManger.handleCompletion , receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let downloadImage = returnedImage else { return }
                self.image = returnedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadImage, imageName: self.imageName, folderName: self.imageFolderName)
            })
    }
}
