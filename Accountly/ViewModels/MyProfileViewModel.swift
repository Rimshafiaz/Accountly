//
//  MyProfileViewModel.swift
//  Accountly
//
//  Created by Rimsha on 09/02/2026.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import PhotosUI
import Combine
class MyProfileViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isEditMode = false
    @Published var isSaving = false
    @Published var hasChanges = false

    @Published var firstName = "" {
        didSet { checkForChanges() }
    }
    @Published var lastName = "" {
        didSet { checkForChanges() }
    }
    @Published var contactNumber = "" {
        didSet { checkForChanges() }
    }
    @Published var birthDay = "" {
        didSet { checkForChanges() }
    }
    @Published var birthMonth = "" {
        didSet { checkForChanges() }
    }
    @Published var birthYear = "" {
        didSet { checkForChanges() }
    }
    @Published var profileImage: UIImage? {
        didSet { checkForChanges() }
    }
    @Published var profileImageURL: String?

    @Published var email = ""
    @Published var password = ""

    private let databaseRef = Database.database().reference()
    private var originalData: [String: Any] = [:]
    
    func fetchCurrentUserProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "No user logged in"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        databaseRef.child("users").child(userId).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            
            self.isLoading = false
            
            guard snapshot.exists(),
                  let userData = snapshot.value as? [String: Any] else {
                self.errorMessage = "User data not found"
                return
            }
            
            self.currentUser = User(
                id: userId,
                firstName: userData["firstName"] as? String ?? "",
                lastName: userData["lastName"] as? String ?? "",
                contactNumber: userData["contactNumber"] as? String ?? "",
                birthDay: userData["birthDay"] as? String ?? "",
                birthMonth: userData["birthMonth"] as? String ?? "",
                birthYear: userData["birthYear"] as? String ?? "",
                email: userData["email"] as? String ?? "",
                profileImageURL: userData["profileImageURL"] as? String
            )
            
            self.loadUserDataForEditing()
        }
    }
    
     func loadUserDataForEditing() {
        guard let user = currentUser else { return }
        firstName = user.firstName
        lastName = user.lastName
        contactNumber = user.contactNumber
        birthDay = user.birthDay
        birthMonth = user.birthMonth
        birthYear = user.birthYear
        email = user.email
        profileImageURL = user.profileImageURL

        originalData = [
            "firstName": firstName,
            "lastName": lastName,
            "contactNumber": contactNumber,
            "birthDay": birthDay,
            "birthMonth": birthMonth,
            "birthYear": birthYear
        ]

        hasChanges = false
    }

    func checkForChanges() {
        guard !originalData.isEmpty else {
            hasChanges = false
            return
        }

        let hasNameChanged = (firstName != originalData["firstName"] as? String)
        let hasLastNameChanged = (lastName != originalData["lastName"] as? String)
        let hasContactChanged = (contactNumber != originalData["contactNumber"] as? String)
        let hasBirthDayChanged = (birthDay != originalData["birthDay"] as? String)
        let hasBirthMonthChanged = (birthMonth != originalData["birthMonth"] as? String)
        let hasBirthYearChanged = (birthYear != originalData["birthYear"] as? String)
        let hasImageChanged = (profileImage != nil)

        hasChanges = hasNameChanged || hasLastNameChanged || hasContactChanged || hasBirthDayChanged || hasBirthMonthChanged || hasBirthYearChanged || hasImageChanged
    }
    
    func saveChanges() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        isSaving = true
        errorMessage = nil
        
        if let image = profileImage {
            uploadProfileImage(image, userId: userId)
        } else {
            updateUserData(userId: userId)
        }
    }
    
    private func uploadProfileImage(_ image: UIImage, userId: String) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            errorMessage = "Failed to process image"
            isSaving = false
            return
        }
        
        let storageRef = Storage.storage().reference()
        let profileImageRef = storageRef.child("profile_images/\(userId).jpg")
        
        profileImageRef.putData(imageData, metadata: nil) { [weak self] _, error in
            if let error = error {
                self?.errorMessage = "Failed to upload image: \(error.localizedDescription)"
                self?.isSaving = false
                return
            }
            
            profileImageRef.downloadURL { url, error in
                if let error = error {
                    self?.errorMessage = "Failed to get image URL: \(error.localizedDescription)"
                    self?.isSaving = false
                    return
                }
                
                self?.profileImageURL = url?.absoluteString
                self?.updateUserData(userId: userId)
            }
        }
    }
    
    private func updateUserData(userId: String) {
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "contactNumber": contactNumber,
            "birthDay": birthDay,
            "birthMonth": birthMonth,
            "birthYear": birthYear,
            "email": email,
            "profileImageURL": profileImageURL ?? ""
        ]

        databaseRef.child("users").child(userId).updateChildValues(userData) { [weak self] error, _ in
            self?.isSaving = false

            if let error = error {
                self?.errorMessage = "Failed to save: \(error.localizedDescription)"
            } else {
                self?.isEditMode = false
                self?.fetchCurrentUserProfile()
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            AuthenticationManager.shared.isLoggedIn = false
            AuthenticationManager.shared.currentUser = nil
        } catch {
            errorMessage = "Failed to logout: \(error.localizedDescription)"
        }
    }
}
