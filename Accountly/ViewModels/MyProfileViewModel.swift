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

            self.countryCode = userData["countryCode"] as? String ?? "+92"
            
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
        let trimmedFirst = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLast = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedFirst.isEmpty {
            return "Please Enter your First Name"
        }
        if trimmedLast.isEmpty {
            return "Please Enter your Last Name"
        }
        if trimmedEmail.isEmpty {
            return "Please Enter your Email"
        }

        let nameRegex = "^[A-Za-z][A-Za-z' -]{1,49}$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)

        if !namePredicate.evaluate(with: trimmedFirst) {
            return "Invalid First Name"
        }
        if !namePredicate.evaluate(with: trimmedLast) {
            return "Invalid Last Name"
        }

     
        if countryCode == "+92" {
            let phoneRegex = #"^3[0-9]{9}$"#
            let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)

            if !phonePredicate.evaluate(with: contactNumber) {
                return "Enter a valid Mobile Number (3XXXXXXXXX)"
            }
        } else {
            let phoneRegex = #"^[0-9]{6,15}$"#
            let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)

            if !phonePredicate.evaluate(with: contactNumber) {
                return "Enter a valid phone number"
            }
        }

        guard
            let day = Int(birthDay),
            let month = Int(birthMonth),
            let year = Int(birthYear)
        else {
            return "Invalid Birth Date"
        }

        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year

        guard let dob = Calendar.current.date(from: components) else {
            return "Invalid Birth Date"
        }

        let now = Date()
        let age = Calendar.current.dateComponents([.year], from: dob, to: now).year ?? 0

        if age < 18 {
            return "You must be at least 18 years old to create an account"
        }

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        if !emailPredicate.evaluate(with: trimmedEmail) {
            return "Enter a valid Email Address"
        }

        if !password.isEmpty {
            let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^A-Za-z\\d]).{8,}$"
            let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

            if !passwordPredicate.evaluate(with: password) {
                return "Password must be 8+ chars with upper, number & symbol"
            }
            if password != confirmPassword {
                return "Passwords do not match"
            }
        }

        return nil
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
        let fullPhoneNumber = countryCode + contactNumber
        var userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "countryCode": countryCode,
            "contactNumber": contactNumber,
            "fullPhoneNumber": fullPhoneNumber,
            "birthDay": birthDay,
            "birthMonth": birthMonth,
            "birthYear": birthYear,
            "email": email
        ]

        if let imageURL = profileImageURL, !imageURL.isEmpty {
            userData["profileImageURL"] = imageURL
        }

        databaseRef.child("users").child(userId).updateChildValues(userData) { [weak self] error, _ in
            guard let self = self else { return }

            self.isSaving = false

            if let error = error {
                self.errorMessage = "Failed to save: \(error.localizedDescription)"
            } else {
                self.currentUser = User(
                    id: userId,
                    firstName: self.firstName,
                    lastName: self.lastName,
                    contactNumber: self.contactNumber,
                    birthDay: self.birthDay,
                    birthMonth: self.birthMonth,
                    birthYear: self.birthYear,
                    email: self.email,
                    profileImageURL: self.profileImageURL
                )

                self.originalData = [
                    "firstName": self.firstName,
                    "lastName": self.lastName,
                    "countryCode": self.countryCode,
                    "contactNumber": self.contactNumber,
                    "birthDay": self.birthDay,
                    "birthMonth": self.birthMonth,
                    "birthYear": self.birthYear
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
