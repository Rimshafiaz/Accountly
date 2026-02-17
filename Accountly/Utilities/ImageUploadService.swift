//
//  ImageUploadService.swift
//  Accountly
//
//  Created by Rimsha on 17/02/2026.
//

import UIKit
import FirebaseStorage

struct ImageUploadService {

    // MARK: - Upload

    static func uploadProfileImage(
        _ image: UIImage,
        userId: String,
        compressionQuality: CGFloat = 0.5,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let imageData = image.jpegData(compressionQuality: compressionQuality) else {
            completion(.failure(NSError(domain: "ImageUpload", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to process image"])))
            return
        }

        let storageRef = Storage.storage().reference()
        let profileImageRef = storageRef.child("profile_images/\(userId).jpg")

        profileImageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            profileImageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let urlString = url?.absoluteString {
                    completion(.success(urlString))
                } else {
                    completion(.failure(NSError(domain: "ImageUpload", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve image URL"])))
                }
            }
        }
    }

    // MARK: - Upload with Fallback

    static func uploadProfileImageWithFallback(
        _ image: UIImage,
        userId: String,
        fallbackName: String = "",
        completion: @escaping (String) -> Void
    ) {
        uploadProfileImage(image, userId: userId) { result in
            switch result {
            case .success(let urlString):
                completion(urlString)
            case .failure:
                let fallbackURL = "https://ui-avatars.com/api/?name=\(fallbackName.replacingOccurrences(of: " ", with: "+"))&background=0D8ABC&color=fff"
                completion(fallbackURL)
            }
        }
    }
}
