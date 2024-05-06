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
    private let fileManager = FilesManager.shared
    private let coinImagesFolder = #function
    private var imageSubscription: AnyCancellable?
    private let imageName: String

    init(coin: Coin) {
        self.coin = coin
        imageName = coin.id
        getCoinImage()
    }

    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: coinImagesFolder) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }

    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        imageSubscription = NetworkManager.download(url: url)
            .tryMap { data in
                UIImage(data: data)
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: NetworkManager.handleCompletion,
                receiveValue: { [weak self] image in
                    guard let self, let downloadedImage = image else { return }
                    self.image = downloadedImage
                    self.imageSubscription?.cancel()
                    self.fileManager.saveImage(image: downloadedImage,
                                               imageName: self.imageName,
                                               folderName: self.coinImagesFolder)
                }
            )
    }
}
