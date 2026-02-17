//
//  signupViewModel.swift
//  Accountly
//
//  Created by Rimsha on 02/02/2026.
//

import SwiftUI
import Combine
import FirebaseAuth

class signUpViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var countryCode = "+92"
    @Published var contactNumber = ""
    @Published var birthDay = ""
    @Published var birthMonth = ""
    @Published var birthYear = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var profileImage: UIImage? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private var authManager = AuthenticationManager.shared

    private func validateFields() -> String? {
        return UserValidator.validateSignupFields(
            firstName: firstName,
            lastName: lastName,
            email: email,
            contactNumber: contactNumber,
            countryCode: countryCode,
            birthDay: birthDay,
            birthMonth: birthMonth,
            birthYear: birthYear,
            password: password,
            confirmPassword: confirmPassword,
            profileImage: profileImage
        )
    }

    func signUp() {
        errorMessage = nil

        if let error = validateFields() {
            errorMessage = error
            return
        }

        isLoading = true

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                return
            }

            guard let userId = authResult?.user.uid else {
                self.isLoading = false
                self.errorMessage = "Failed to get user ID"
                return
            }

            guard let image = self.profileImage else {
                self.isLoading = false
                self.errorMessage = "Profile image is required"
                return
            }

            // Upload image with fallback
            ImageUploadService.uploadProfileImageWithFallback(
                image,
                userId: userId,
                fallbackName: "\(self.firstName) \(self.lastName)"
            ) { imageURL in
                self.saveUserData(userId: userId, profileImageURL: imageURL)
            }
        }
    }

    private func saveUserData(userId: String, profileImageURL: String) {
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

        DatabaseService.saveUser(userId: userId, data: user.toDictionary()) { [weak self] success, error in
            guard let self = self else { return }
            self.isLoading = false
            if let error = error {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
