//
//  signupViewModel.swift
//  Accountly
//
//  Created by Rimsha on 02/02/2026.
//

import SwiftUI
import Combine
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class signUpViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
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

        if !namePredicate.evaluate(with: trimmedFirst) { return
            
            "Invalid First Name" }
        if !namePredicate.evaluate(with: trimmedLast) { return
            "Invalid Last Name"
        }

        let phoneRegex = #"^(\+92|0)3[0-9]{9}$"#
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)

        if !phonePredicate.evaluate(with: contactNumber) { return
            "Enter a valid Mobile Number"
        }

        guard
            let day = Int(birthDay),
            let month = Int(birthMonth),
            let year = Int(birthYear)
        else {
return "Invalid Birth Date"        }

        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year

        guard let dob = Calendar.current.date(from: components) else { return
            "Invalid Birth Date"
        }

        let now = Date()
        let age = Calendar.current.dateComponents([.year], from: dob, to: now).year ?? 0

        if age < 18 { return
            "You must be at least 18 years old to create an account"
        }
        

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        if !emailPredicate.evaluate(with: trimmedEmail) { return
            "Enter a valid Email Address"
        }

        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^A-Za-z\\d]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

        if !passwordPredicate.evaluate(with: password) { return "Password must be 8+ chars with upper, number & symbol" }
        if password != confirmPassword { return
            "Passwords do not match"
        }
        if profileImage == nil { return
            "Please select a profile image"
        }

        return nil
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

            self.uploadProfileImage(userId: userId) { imageURL in
                let finalImageURL = imageURL ?? "https://example.com/placeholder.jpg"
                self.saveUserData(userId: userId, profileImageURL: finalImageURL)
            }

            
        }
    }

    private func uploadProfileImage(userId: String, completion: @escaping (String?) -> Void) {
        guard let image = profileImage, let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }

        let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if error != nil {
                completion(nil)
                return
            }

            storageRef.downloadURL { url, error in
                completion(url?.absoluteString)
            }
        }
    }

    private func saveUserData(userId: String, profileImageURL: String) {
        let ref = Database.database().reference().child("users/\(userId)")
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "contactNumber": contactNumber,
            "birthDay": birthDay,
            "birthMonth": birthMonth,
            "birthYear": birthYear,
            "email": email,
            "profileImageURL": profileImageURL
        ]
        ref.setValue(userData) { [weak self] error, _ in
            guard let self = self else { return }
            self.isLoading = false
            if let error = error {
                self.errorMessage = error.localizedDescription
            }
        
        }
    }
}
