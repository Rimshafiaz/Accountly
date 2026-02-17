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
        if let error = UserValidator.validateEmail(email) {
            errorMessage = error == "Please Enter your Email" ? "Enter your email address to reset password" : error
            return
        }

        isResettingPassword = true
        errorMessage = nil

        Auth.auth().sendPasswordReset(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines)) { [weak self] error in
            guard let self = self else { return }

            self.isResettingPassword = false

            if let error = error {
                self.errorMessage = AuthErrorHandler.getFriendlyErrorMessage(for: error)
            } else {
                print("Password reset email sent successfully")
                self.resetPasswordMessage = "Password reset email sent! Check your inbox and follow the instructions."
                self.showResetPasswordAlert = true
            }
        }
    }

    private func validateFields() -> String? {
        if let error = UserValidator.validateEmail(email) {
            return error == "Please Enter your Email" ? "Enter your Email Address" : error
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
                self.errorMessage = AuthErrorHandler.getFriendlyErrorMessage(for: error)
                return
            }
        }
    }
}

