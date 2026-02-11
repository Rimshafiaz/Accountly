//
//  User.swift
//  Accountly
//
//  Created by Rimsha on 02/02/2026.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String?
    var firstName: String
    var lastName: String
    var contactNumber: String
    var birthDay: String
    var birthMonth: String
    var birthYear: String
    var email: String
    var profileImageURL: String?
}


