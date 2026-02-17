//
//  AuthErrorHandler.swift
//  Accountly
//
//  Created by Rimsha on 17/02/2026.
//

import Foundation
import FirebaseAuth

struct AuthErrorHandler {

    // MARK: - Main

    static func getFriendlyErrorMessage(for error: Error) -> String {
        let nsError = error as NSError
        let code = nsError.code

        if let authCode = AuthErrorCode(rawValue: code) {
            return getMessage(for: authCode)
        }

        return "An error occurred. Please try again."
    }

    // MARK: - Error Messages

    private static func getMessage(for code: AuthErrorCode) -> String {
        switch code {
        case .wrongPassword:
            return "Incorrect password. Please try again."
        case .userNotFound:
            return "No account found with this email address. Please sign up."
        case .invalidEmail:
            return "Invalid email format. Please check and try again."
        case .userDisabled:
            return "This account has been disabled. Please contact support."
        case .tooManyRequests:
            return "Too many failed attempts. Please try again later or reset your password."
        case .emailAlreadyInUse:
            return "This email is already registered. Please login or use a different email."
        case .weakPassword:
            return "Password is too weak. Please use a stronger password."
        case .invalidRecipientEmail:
            return "The email address is invalid. Please check and try again."
        case .networkError:
            return "Network error. Please check your connection and try again."
        
        default:
            return "Login failed. Please check your credentials and try again."
        }
    }

    // MARK: - Helpers

    static func isUserNotFound(_ error: Error) -> Bool {
        let nsError = error as NSError
        return nsError.code == AuthErrorCode.userNotFound.rawValue
    }

    static func isInvalidEmail(_ error: Error) -> Bool {
        let nsError = error as NSError
        return nsError.code == AuthErrorCode.invalidEmail.rawValue
    }
}
