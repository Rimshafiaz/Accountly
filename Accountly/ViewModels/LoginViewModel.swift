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
    @Published var email = "" {
        didSet { clearErrorOnType() }
    }
    @Published var password = "" {
        didSet { clearErrorOnType() }
    }
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    @Published var showResetPasswordAlert = false
    @Published var resetPasswordMessage: String? = nil
    @Published var isResettingPassword = false

    private var authManager = AuthenticationManager.shared

    private func clearErrorOnType() {
        errorMessage = nil
    }

    func resetPassword() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedEmail.isEmpty {
            errorMessage = "Enter your email address to reset password"
            return
        }

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        if !emailPredicate.evaluate(with: trimmedEmail) {
            errorMessage = "Enter a valid email address"
            return
        }

        isResettingPassword = true
        errorMessage = nil

        Auth.auth().sendPasswordReset(withEmail: trimmedEmail) { [weak self] error in
            guard let self = self else { return }

            self.isResettingPassword = false

            if let error = error {
                print("Password reset error: \(error.localizedDescription)")
                let nsError = error as NSError

                if nsError.code == AuthErrorCode.userNotFound.rawValue {
                    self.errorMessage = "No account found with this email address"
                } else if nsError.code == AuthErrorCode.invalidEmail.rawValue {
                    self.errorMessage = "Invalid email format"
                } else {
                    self.errorMessage = "Failed to send reset email. Please try again."
                }
            } else {
                print("Password reset email sent successfully to: \(trimmedEmail)")
                self.resetPasswordMessage = "Password reset email sent! Check your inbox and follow the instructions."
                self.showResetPasswordAlert = true
            }
        }
    }

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
                self.errorMessage = self.getFriendlyErrorMessage(error)
                return
            }


        }
    }

    private func getFriendlyErrorMessage(_ error: Error) -> String {
        let nsError = error as NSError

        if nsError.code == AuthErrorCode.wrongPassword.rawValue {
            return "Incorrect password. Please try again."
        } else if nsError.code == AuthErrorCode.userNotFound.rawValue {
            return "No account found with this email address. Please sign up."
        } else if nsError.code == AuthErrorCode.invalidEmail.rawValue {
            return "Invalid email format. Please check and try again."
        } else if nsError.code == AuthErrorCode.userDisabled.rawValue {
            return "This account has been disabled. Please contact support."
        } else if nsError.code == AuthErrorCode.tooManyRequests.rawValue {
            return "Too many failed attempts. Please try again later or reset your password."
        } else {
            return "Login failed. Please check your credentials and try again."
        }
    }
}

