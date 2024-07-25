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
    private var imageSubscriptions: [String: AnyCancellable] = [:]
    private let networkManager: NetworkServiceProtocol

    init(networkManager: NetworkServiceProtocol) {
        self.networkManager = networkManager
    }

    deinit {
        imageSubscriptions.values.forEach { $0.cancel() }
    }
}

// MARK: - CoinImageServiceProtocol

extension CoinImageService: CoinImageServiceProtocol {
    var imageDataPublisher: Published<[String: Data]>.Publisher { $imageDataDict }

    func getCoinImage(for coin: Coin) {
        let imageName = coin.id
        AppLogger.log(tag: .debug, "Attempting to get image for coin:", imageName)
        if let imageData = imageProvider.getImageData(imageName: imageName, folderName: coinImagesFolder) {
            AppLogger.log(tag: .debug, "Image found in provider for coin:", imageName)
            imageDataDict[imageName] = imageData
        } else {
            AppLogger.log(tag: .debug, "Image not found in provider, downloading for coin:", imageName)
            downloadCoinImage(for: coin)
        }
    }
}

// MARK: - Private methods

private extension CoinImageService {
    func downloadCoinImage(for coin: Coin) {
        let imageName = coin.id
        guard let url = URL(string: coin.image) else {
            AppLogger.log(tag: .error, "Invalid URL for coin:", imageName)
            return
        }

        if imageSubscriptions[imageName] != nil {
            AppLogger.log(tag: .debug, "Download already in progress for coin:", imageName)
            return
        }

        AppLogger.log(tag: .debug, "Starting download for coin:", imageName)
        let subscription = networkManager.download(url: url)
            .first()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        AppLogger.log(tag: .debug, "Image download finished for coin:", imageName)
                    case let .failure(error):
                        AppLogger.log(tag: .error, "Image download failed for coin:", imageName, "with error:", error.localizedDescription)
                    }
                    self?.imageSubscriptions[imageName]?.cancel()
                    self?.imageSubscriptions.removeValue(forKey: imageName)
                },
                receiveValue: { [weak self] downloadedImage in
                    guard let self = self else { return }
                    self.imageDataDict[imageName] = downloadedImage
                    self.imageProvider.saveImage(data: downloadedImage,
                                                 imageName: imageName,
                                                 folderName: self.coinImagesFolder)
                    AppLogger.log(tag: .debug, "Image downloaded and saved for coin:", imageName)
                }
            )

        imageSubscriptions[imageName] = subscription
    }
}
