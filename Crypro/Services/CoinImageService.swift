//
//  CoinImageService.swift
//  Crypro
//
//  Created by Antomated on 03.04.2024.
//

import Combine
import Foundation

final class CoinImageService {
    @Published var imageData: Data?
    private let coin: Coin
    private let imageProvider = ImageDataProvider.shared
    private var imageSubscription: AnyCancellable?
    private let imageName: String
    private lazy var coinImagesFolder = String(describing: type(of: self))

    init(coin: Coin) {
        self.coin = coin
        imageName = coin.id
        getCoinImage()
    }

    private func getCoinImage() {
        if let imageData = imageProvider.getImageData(imageName: imageName, folderName: coinImagesFolder) {
            self.imageData = imageData
        } else {
            downloadCoinImage()
        }
    }

    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        imageSubscription = NetworkManager.download(url: url)
            .first()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        AppLogger.log(tag: .error, "Image download finished.")
                    case let .failure(error):
                        AppLogger.log(tag: .error, "Image download failed with error: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] downloadedImage in
                    guard let self else { return }
                    self.imageData = downloadedImage
                    self.imageProvider.saveImage(data: downloadedImage,
                                                 imageName: self.imageName,
                                                 folderName: self.coinImagesFolder)
                }
            )
    }
}
