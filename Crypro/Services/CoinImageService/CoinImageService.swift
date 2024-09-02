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
    private var imageCache = NSCache<NSString, NSData>()
    private var imageSubscriptions: [String: AnyCancellable] = [:]
    private let networkManager: NetworkManagerProtocol
    private let imageDataProvider: ImageDataProviderProtocol

    init(networkManager: NetworkManagerProtocol, imageDataProvider: ImageDataProviderProtocol) {
        self.networkManager = networkManager
        self.imageDataProvider = imageDataProvider
    }

    deinit {
        imageSubscriptions.values.forEach { $0.cancel() }
    }
}

// MARK: - CoinImageServiceProtocol

extension CoinImageService: CoinImageServiceProtocol {
    var imageDataPublisher: Published<[String: Data]>.Publisher { $imageDataDict }

    func getCoinImage(for coin: Coin) {
        let imageName = coin.id as NSString
        AppLogger.log(tag: .debug, "Attempting to get image for coin:", imageName as String)
        if let cachedData = imageCache.object(forKey: imageName) {
            AppLogger.log(tag: .debug, "Image found in cache for coin:", imageName as String)
            imageDataDict[imageName as String] = cachedData as Data
        } else if let imageData = imageDataProvider.getImageData(imageName: imageName as String,
                                                                 folderName: coinImagesFolder) {
            AppLogger.log(tag: .debug, "Image found in provider for coin:", imageName as String)
            imageCache.setObject(imageData as NSData, forKey: imageName)
            imageDataDict[imageName as String] = imageData
        } else {
            AppLogger.log(tag: .debug, "Image not found in provider, downloading for coin:", imageName as String)
            downloadCoinImage(for: coin)
        }
    }
}

// MARK: - Private methods

private extension CoinImageService {
    func downloadCoinImage(for coin: Coin) {
        let imageName = coin.id as NSString
        guard let url = URL(string: coin.image) else {
            AppLogger.log(tag: .error, "Invalid URL for coin:", imageName as String)
            return
        }

        if imageSubscriptions[imageName as String] != nil {
            AppLogger.log(tag: .debug, "Download already in progress for coin:", imageName as String)
            return
        }

        AppLogger.log(tag: .debug, "Starting download for coin:", imageName as String)
        let subscription = networkManager.download(url: url)
            .first()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        AppLogger.log(tag: .debug, "Image download finished for coin:", imageName as String)
                    case let .failure(error):
                        AppLogger.log(tag: .error,
                                      "Image download failed for coin:",
                                      imageName as String,
                                      "with error:",
                                      error.localizedDescription)
                    }
                    self?.imageSubscriptions[imageName as String]?.cancel()
                    self?.imageSubscriptions.removeValue(forKey: imageName as String)
                },
                receiveValue: { [weak self] downloadedImage in
                    guard let self = self else { return }
                    self.imageDataDict[imageName as String] = downloadedImage
                    self.imageCache.setObject(downloadedImage as NSData, forKey: imageName)
                    self.imageDataProvider.saveImage(data: downloadedImage,
                                                     imageName: imageName as String,
                                                     folderName: self.coinImagesFolder)
                    AppLogger.log(tag: .debug, "Image downloaded and saved for coin:", imageName as String)
                }
            )

        imageSubscriptions[imageName as String] = subscription
    }
}
