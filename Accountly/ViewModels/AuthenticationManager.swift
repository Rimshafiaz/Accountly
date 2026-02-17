//
//  AuthenticationManager.swift
//  Accountly
//
//  Created by Rimsha on 04/02/2026.
//

import Foundation
import FirebaseAuth
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
        DatabaseService.fetchUser(userId: userId) { [weak self] result in
            switch result {
            case .success(let userData):
                if let user = User(from: userData, id: userId) {
                    DispatchQueue.main.async {
                        self?.currentUser = user
                    }
                }
            case .failure:
                break
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

        DatabaseService.deleteUser(userId: userId) { [weak self] success, error in
            guard let self = self else { return }

            if !success {
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
