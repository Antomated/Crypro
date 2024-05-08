//
//  FilesManager.swift
//  Crypro
//
//  Created by Beavean on 03.04.2024.
//

import SwiftUI

final class FilesManager {
    static let shared = FilesManager()
    private init() {}

    func saveImage(image: UIImage, imageName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        guard let data = image.pngData(),
              let url = getURLForImage(imageName: imageName, folderName: folderName)
        else { return }
        do {
            try data.write(to: url)
        } catch {
            AppLogger.log(tag: .error, "Error saving image. ImageName: \(imageName). \(error)")
        }
    }

    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
}

// MARK: - Private methods

private extension FilesManager {
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
        return folderURL.appendingPathExtension(imageName + ".png")
    }
}
