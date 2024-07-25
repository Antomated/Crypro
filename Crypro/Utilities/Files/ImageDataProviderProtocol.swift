//
//  ImageDataProviderProtocol.swift
//  Crypro
//
//  Created by Antomated on 25.07.2024.
//

import Foundation

protocol ImageDataProviderProtocol {
    func saveImage(data: Data, imageName: String, folderName: String)
    func getImageData(imageName: String, folderName: String) -> Data?
}
