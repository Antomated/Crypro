//
//  CoinImageService.swift
//  Crypro
//
//  Created by Antomated on 03.04.2024.
//

import Combine
import Foundation

final class CoinImageService {
    @Published var imageDataDict: [String: Data] = [:]
    private lazy var coinImagesFolder = String(describing: type(of: self))
    private let imageProvider = ImageDataProvider.shared
    private var imageSubscription: AnyCancellable?
    private let networkManager: NetworkServiceProtocol

    init(networkManager: NetworkServiceProtocol) {
        self.networkManager = networkManager
    }

}

// MARK: - CoinImageServiceProtocol

extension CoinImageService: CoinImageServiceProtocol {
    func getCoinImage(for coin: Coin) {
        let imageName = coin.id
        if let imageData = imageProvider.getImageData(imageName: imageName, folderName: coinImagesFolder) {
            imageDataDict[imageName] = imageData
        } else {
            downloadCoinImage(for: coin)
        }
    }

    var imageDataPublisher: Published<[String: Data]>.Publisher { $imageDataDict }
}

// MARK: - Private methods

private extension CoinImageService {
    func downloadCoinImage(for coin: Coin) {
        guard let url = URL(string: coin.image) else { return }
        imageSubscription = networkManager.download(url: url)
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
                    let imageName = coin.id
                    self.imageDataDict[imageName] = downloadedImage
                    self.imageProvider.saveImage(data: downloadedImage,
                                                 imageName: imageName,
                                                 folderName: self.coinImagesFolder)
                }
            )
    }
}
