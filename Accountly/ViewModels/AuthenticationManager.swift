//
//  AuthenticationManager.swift
//  Accountly
//
//  Created by Rimsha on 04/02/2026.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Combine

class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()

    @Published var isLoggedIn = false
    @Published var currentUser: Accountly.User?

    private var authListener: AuthStateDidChangeListenerHandle?

    private init() {
        setupAuthStateListener()
    }

    deinit {
        if let listener = authListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }

    private func setupAuthStateListener() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                self?.isLoggedIn = true
                self?.loadUserData(userId: user.uid)
            } else {
                self?.isLoggedIn = false
                self?.currentUser = nil
            }
        }
    }

    private func loadUserData(userId: String) {
        let ref = Database.database().reference().child("users/\(userId)")

        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            if let userData = snapshot.value as? [String: Any],
               let firstName = userData["firstName"] as? String,
               let lastName = userData["lastName"] as? String,
               let contactNumber = userData["contactNumber"] as? String,
               let birthDay = userData["birthDay"] as? String,
               let birthMonth = userData["birthMonth"] as? String,
               let birthYear = userData["birthYear"] as? String,
               let email = userData["email"] as? String {

                let profileImageURL = userData["profileImageURL"] as? String

                DispatchQueue.main.async {
                    self?.currentUser = Accountly.User(
                        id: userId,
                        firstName: firstName,
                        lastName: lastName,
                        contactNumber: contactNumber,
                        birthDay: birthDay,
                        birthMonth: birthMonth,
                        birthYear: birthYear,
                        email: email,
                        profileImageURL: profileImageURL
                    )
                }
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
    func deleteAccount(completion: @escaping (Bool, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false, NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"]))
            return
        }

        let userId = user.uid

        let ref = Database.database().reference().child("users/\(userId)")
        ref.removeValue { error, _ in
            if let error = error {
                completion(false, error)
                return
            }

            user.delete { error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(false, error)
                    } else {
                        self.isLoggedIn = false
                        self.currentUser = nil
                        completion(true, nil)
                    }
                }
            }
        }
    }
    func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
}
