//
//  ImageDataProvider.swift
//  Crypro
//
//  Created by Antomated on 03.04.2024.
//

import Foundation

final class ImageDataProvider {
    static let shared = ImageDataProvider()
    private init() {}

    func saveImage(data: Data, imageName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        guard let url = getURLForImage(imageName: imageName, folderName: folderName) else { return }
        do {
            try data.write(to: url)
        } catch {
            AppLogger.log(tag: .error, "Error saving image. ImageName: \(imageName). \(error)")
        }
    }

    func getImageData(imageName: String, folderName: String) -> Data? {
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else { return nil }
        return try? Data(contentsOf: url)
    }
}

// MARK: - Private methods

private extension ImageDataProvider {
    func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName),
              !FileManager.default.fileExists(atPath: url.path)
        else { return }
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        } catch {
            AppLogger.log(tag: .error, "Error creating directory. FolderName: \(folderName). \(error)")
        }
    }

    func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }

    func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName).appendingPathExtension("png")
    }
}
