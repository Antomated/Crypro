//
//  CoinImageService.swift
//  Crypro
//
//  Created by Beavean on 03.04.2024.
//

import Combine
import SwiftUI

final class CoinImageService {
    @Published var image: UIImage?
    private let coin: Coin
    private let imageProvider = LocalImageProvider.shared
    private var imageSubscription: AnyCancellable?
    private let imageName: String
    private lazy var coinImagesFolder = String(describing: type(of: self))

    init(coin: Coin) {
        self.coin = coin
        imageName = coin.id
        getCoinImage()
    }

    private func getCoinImage() {
        if let savedImage = imageProvider.getImage(imageName: imageName, folderName: coinImagesFolder) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }

    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        imageSubscription = NetworkManager.download(url: url)
            .first()
            .tryMap { data in
                UIImage(data: data)
            }
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
                receiveValue: { [weak self] image in
                    guard let self, let downloadedImage = image else { return }
                    self.image = downloadedImage
                    self.imageProvider.saveImage(image: downloadedImage,
                                               imageName: self.imageName,
                                               folderName: self.coinImagesFolder)
                }
            )
    }
}
