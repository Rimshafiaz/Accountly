//
//  UserValidator.swift
//  Accountly
//
//  Created by Rimsha on 17/02/2026.
//

import Foundation

struct UserValidator {

    // MARK: - Individual Validators

    static func validateFirstName(_ firstName: String) -> String? {
        let trimmed = firstName.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return "Please Enter your First Name"
        }

        let nameRegex = "^[A-Za-z][A-Za-z' -]{1,49}$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)

        if !namePredicate.evaluate(with: trimmed) {
            return "Invalid First Name"
        }

        return nil
    }

    static func validateLastName(_ lastName: String) -> String? {
        let trimmed = lastName.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return "Please Enter your Last Name"
        }

        let nameRegex = "^[A-Za-z][A-Za-z' -]{1,49}$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)

        if !namePredicate.evaluate(with: trimmed) {
            return "Invalid Last Name"
        }

        return nil
    }

    static func validateEmail(_ email: String) -> String? {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return "Please Enter your Email"
        }

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        if !emailPredicate.evaluate(with: trimmed) {
            return "Enter a valid Email Address"
        }

        return nil
    }

    static func validatePhoneNumber(_ contactNumber: String, countryCode: String) -> String? {
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

        return nil
    }

    static func validateBirthDate(day: String, month: String, year: String) -> String? {
        guard
            let day = Int(day),
            let month = Int(month),
            let year = Int(year)
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

        return nil
    }

    static func validatePassword(_ password: String) -> String? {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^A-Za-z\\d]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

        if !passwordPredicate.evaluate(with: password) {
            return "Password must be 8+ chars with upper, number & symbol"
        }

        return nil
    }

    static func validateConfirmPassword(_ password: String, confirmPassword: String) -> String? {
        if password != confirmPassword {
            return "Passwords do not match"
        }
        return nil
    }

    // MARK: - Complete Validators

    static func validateSignupFields(
        firstName: String,
        lastName: String,
        email: String,
        contactNumber: String,
        countryCode: String,
        birthDay: String,
        birthMonth: String,
        birthYear: String,
        password: String,
        confirmPassword: String,
        profileImage: (any Sendable)?
    ) -> String? {

        if let error = validateFirstName(firstName) { return error }
        if let error = validateLastName(lastName) { return error }
        if let error = validateEmail(email) { return error }
        if let error = validatePhoneNumber(contactNumber, countryCode: countryCode) { return error }
        if let error = validateBirthDate(day: birthDay, month: birthMonth, year: birthYear) { return error }
        if let error = validatePassword(password) { return error }
        if let error = validateConfirmPassword(password, confirmPassword: confirmPassword) { return error }

        if profileImage == nil {
            return "Please select a profile image"
        }

        return nil
    }

    static func validateProfileEditFields(
        firstName: String,
        lastName: String,
        email: String,
        contactNumber: String,
        countryCode: String,
        birthDay: String,
        birthMonth: String,
        birthYear: String,
        password: String,
        confirmPassword: String
    ) -> String? {

        if let error = validateFirstName(firstName) { return error }
        if let error = validateLastName(lastName) { return error }
        if let error = validateEmail(email) { return error }
        if let error = validatePhoneNumber(contactNumber, countryCode: countryCode) { return error }
        if let error = validateBirthDate(day: birthDay, month: birthMonth, year: birthYear) { return error }

        if !password.isEmpty {
            if let error = validatePassword(password) { return error }
            if let error = validateConfirmPassword(password, confirmPassword: confirmPassword) { return error }
        }

        return nil
    }
}
