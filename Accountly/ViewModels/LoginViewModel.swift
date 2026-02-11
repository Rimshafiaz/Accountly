//
//  LoginViewModel.swift
//  Accountly
//
//  Created by Rimsha on 03/02/2026.
//

import Foundation
import Combine
import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabase

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading = false

    private var authManager = AuthenticationManager.shared

    private func validateFields() -> String? {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedEmail.isEmpty {
            return "Enter your Email Address"
        }

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        if !emailPredicate.evaluate(with: trimmedEmail) {
            return "Enter a Valid Email Address"
        }

        if password.isEmpty {
            return "Enter your Password"
        }

        return nil
    }

    func login() {
        errorMessage = nil

        if let error = validateFields() {
            errorMessage = error
            return
        }

        isLoading = true

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            self.isLoading = false

            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }

            
        }
    }
}

