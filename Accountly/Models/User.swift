//
//  User.swift
//  Accountly
//
//  Created by Rimsha on 02/02/2026.
//

import Foundation

struct User: Identifiable, Codable {

    // MARK: - Properties

    var id: String?
    var firstName: String
    var lastName: String
    var contactNumber: String
    var countryCode: String?
    var birthDay: String
    var birthMonth: String
    var birthYear: String
    var email: String
    var profileImageURL: String?

    // MARK: - Initializers

    init(
        id: String? = nil,
        firstName: String,
        lastName: String,
        contactNumber: String,
        countryCode: String? = nil,
        birthDay: String,
        birthMonth: String,
        birthYear: String,
        email: String,
        profileImageURL: String? = nil
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.contactNumber = contactNumber
        self.countryCode = countryCode
        self.birthDay = birthDay
        self.birthMonth = birthMonth
        self.birthYear = birthYear
        self.email = email
        self.profileImageURL = profileImageURL
    }

    init?(from dictionary: [String: Any], id: String) {
        guard
            let firstName = dictionary["firstName"] as? String,
            let lastName = dictionary["lastName"] as? String,
            let email = dictionary["email"] as? String
        else {
            return nil
        }

        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.contactNumber = dictionary["contactNumber"] as? String ?? ""
        self.countryCode = dictionary["countryCode"] as? String
        self.birthDay = dictionary["birthDay"] as? String ?? ""
        self.birthMonth = dictionary["birthMonth"] as? String ?? ""
        self.birthYear = dictionary["birthYear"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String
    }

    // MARK: - Converter

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "contactNumber": contactNumber,
            "birthDay": birthDay,
            "birthMonth": birthMonth,
            "birthYear": birthYear,
            "email": email
        ]

        if let countryCode = countryCode {
            dict["countryCode"] = countryCode
            dict["fullPhoneNumber"] = countryCode + contactNumber
        }

        if let profileImageURL = profileImageURL {
            dict["profileImageURL"] = profileImageURL
        }

        return dict
    }
}
