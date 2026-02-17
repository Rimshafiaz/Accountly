//
//  MyProfileViewModel.swift
//  Accountly
//
//  Created by Rimsha on 09/02/2026.
//

import Foundation
import SwiftUI
import FirebaseAuth
import PhotosUI
import Combine
class MyProfileViewModel: ObservableObject {
    @Published var currentUser: Accountly.User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isEditMode = false
    @Published var isSaving = false
    @Published var hasChanges = false
    @Published var validationError: String?

    @Published var firstName = "" {
        didSet { checkForChanges() }
    }
    @Published var lastName = "" {
        didSet { checkForChanges() }
    }
    @Published var countryCode = "+92" {
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
    @Published var password = "" {
        didSet {
            checkForChanges()
            if !password.isEmpty {
                validationError = nil
            }
        }
    }
    @Published var confirmPassword = "" {
        didSet {
            checkForChanges()
            if !confirmPassword.isEmpty {
                validationError = nil
            }
        }
    }

    private var originalData: [String: Any] = [:]
    
    func fetchCurrentUserProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "No user logged in"
            return
        }
        
        isLoading = true
        errorMessage = nil

        DatabaseService.fetchUser(userId: userId) { [weak self] result in
            guard let self = self else { return }

            self.isLoading = false

            switch result {
            case .success(let userData):
                if let user = Accountly.User(from: userData, id: userId) {
                    self.currentUser = user
                    self.loadUserDataForEditing()
                } else {
                    self.errorMessage = "Failed to parse user data"
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
     func loadUserDataForEditing() {
        guard let user = currentUser else { return }
        firstName = user.firstName
        lastName = user.lastName
        contactNumber = user.contactNumber
        countryCode = user.countryCode ?? "+92"
        birthDay = user.birthDay
        birthMonth = user.birthMonth
        birthYear = user.birthYear
        email = user.email
        profileImageURL = user.profileImageURL
        password = ""
        confirmPassword = ""
        validationError = nil

        originalData = [
            "firstName": firstName,
            "lastName": lastName,
            "countryCode": countryCode,
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
        let hasCountryCodeChanged = (countryCode != originalData["countryCode"] as? String)
        let hasContactChanged = (contactNumber != originalData["contactNumber"] as? String)
        let hasBirthDayChanged = (birthDay != originalData["birthDay"] as? String)
        let hasBirthMonthChanged = (birthMonth != originalData["birthMonth"] as? String)
        let hasBirthYearChanged = (birthYear != originalData["birthYear"] as? String)
        let hasImageChanged = (profileImage != nil)
        let hasPasswordChanged = !password.isEmpty || !confirmPassword.isEmpty

        hasChanges = hasNameChanged || hasLastNameChanged || hasCountryCodeChanged || hasContactChanged || hasBirthDayChanged || hasBirthMonthChanged || hasBirthYearChanged || hasImageChanged || hasPasswordChanged
    }
    
    func saveChanges() {
        validationError = nil

        if let error = validateFields() {
            validationError = error
            return
        }

        guard let userId = Auth.auth().currentUser?.uid else { return }

        isSaving = true
        errorMessage = nil

        if !password.isEmpty {
            updatePassword { [weak self] success in
                guard let self = self else { return }
                if success {
                    if let image = self.profileImage {
                        self.uploadProfileImage(image, userId: userId)
                    } else {
                        self.updateUserData(userId: userId)
                    }
                } else {
                    self.isSaving = false
                }
            }
        } else {
            if let image = profileImage {
                uploadProfileImage(image, userId: userId)
            } else {
                updateUserData(userId: userId)
            }
        }
    }

    private func validateFields() -> String? {
        return UserValidator.validateProfileEditFields(
            firstName: firstName,
            lastName: lastName,
            email: email,
            contactNumber: contactNumber,
            countryCode: countryCode,
            birthDay: birthDay,
            birthMonth: birthMonth,
            birthYear: birthYear,
            password: password,
            confirmPassword: confirmPassword
        )
    }

    private func updatePassword(completion: @escaping (Bool) -> Void) {
        let currentUser = Auth.auth().currentUser

        currentUser?.updatePassword(to: password) { error in
            if let error = error {
                self.errorMessage = "Failed to update password: \(error.localizedDescription)"
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    private func uploadProfileImage(_ image: UIImage, userId: String) {
        ImageUploadService.uploadProfileImage(image, userId: userId) { [weak self] (result: Result<String, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let urlString):
                self.profileImageURL = urlString
                self.updateUserData(userId: userId)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.isSaving = false
            }
        }
    }
    
    private func updateUserData(userId: String) {
        let user = User(
            id: userId,
            firstName: firstName,
            lastName: lastName,
            contactNumber: contactNumber,
            countryCode: countryCode,
            birthDay: birthDay,
            birthMonth: birthMonth,
            birthYear: birthYear,
            email: email,
            profileImageURL: profileImageURL
        )

        DatabaseService.updateUser(userId: userId, data: user.toDictionary()) { [weak self] success, error in
            guard let self = self else { return }

            self.isSaving = false

            if let error = error {
                self.errorMessage = "Failed to save: \(error.localizedDescription)"
            } else {
                self.currentUser = user

                self.originalData = [
                    "firstName": user.firstName,
                    "lastName": user.lastName,
                    "countryCode": user.countryCode ?? "",
                    "contactNumber": user.contactNumber,
                    "birthDay": user.birthDay,
                    "birthMonth": user.birthMonth,
                    "birthYear": user.birthYear
                ]

                self.profileImage = nil
                self.password = ""
                self.confirmPassword = ""
                self.validationError = nil
                self.hasChanges = false
                self.isEditMode = false
            }
        }
    }
    

}

