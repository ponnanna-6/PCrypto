//
//  LocalFileManager.swift
//  PCrypto
//
//  Created by Logycent on 23/12/2024.
//

import UIKit

class LocalFileManager {
    static let instance = LocalFileManager()
    private init() {}

    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        createFolderIfNecessary(folderName: folderName)
        
        //get path for image
        guard
            let data = image.pngData(),
            let url = getURLForImage(
                imageName: imageName, folderName: folderName)
        else { return }

        //save image to path
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image \(imageName). \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        //get path for image
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }

        return UIImage(contentsOfFile: url.path)
    }

    private func createFolderIfNecessary(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true)
            } catch let error{
                print("Error while creating folder \(folderName). \(error)")
            }
        }
    }

    private func getURLForFolder(folderName: String) -> URL? {
        guard
            let url = FileManager.default.urls(
                for: .cachesDirectory, in: .userDomainMask
            ).first
        else {
            return nil
        }

        return url.appendingPathComponent(folderName)
    }

    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderUrl = getURLForFolder(folderName: folderName) else {
            return nil
        }

        return folderUrl.appendingPathComponent(imageName + ".png")
    }
}
