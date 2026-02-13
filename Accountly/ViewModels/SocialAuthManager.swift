//
//  SocialAuthManager.swift
//  Accountly
//
//  Created by Rimsha on 10/02/2026.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import GoogleSignIn
import AuthenticationServices
import CryptoKit
import Combine

class SocialAuthManager: NSObject, ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var authManager = AuthenticationManager.shared
    private var currentNonce: String?

    func signInWithGoogle(presenting: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Failed to get Google Client ID"
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        isLoading = true

        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self.isLoading = false
                self.errorMessage = "Failed to get user token"
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            self.authenticateWithFirebase(credential: credential, provider: "google")
        }
    }

    func signInWithApple() {
        let nonce = randomNonceString()
        currentNonce = nonce

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()

        isLoading = true
    }

    private func authenticateWithFirebase(credential: AuthCredential, provider: String) {
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                return
            }

            guard let user = authResult?.user else {
                self.isLoading = false
                self.errorMessage = "Failed to get user"
                return
            }

            self.checkAndCreateUserProfile(user: user, provider: provider)
        }
    }

    private func checkAndCreateUserProfile(user: FirebaseAuth.User, provider: String) {
        print("DEBUG: checkAndCreateUserProfile for provider: \(provider)")
        let ref = Database.database().reference().child("users/\(user.uid)")
        print("DEBUG: Database path: users/\(user.uid)")

        var firstName = ""
        var lastName = ""

        if let displayName = user.displayName {
            let components = displayName.components(separatedBy: " ")
            firstName = components.first ?? ""
            lastName = components.dropFirst().joined(separator: " ")
        }

        print("DEBUG: Name from provider: \(firstName) \(lastName)")
        print("DEBUG: Email from provider: \(user.email ?? "none")")

       
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": user.email ?? "",
            "profileImageURL": user.photoURL?.absoluteString ?? "",
            "authProvider": provider
        ]

        print("DEBUG: About to save user data to Firebase...")
        print("DEBUG: Data: \(userData)")

        ref.updateChildValues(userData) { [weak self] error, _ in
            print("DEBUG: updateChildValues callback FIRED!")
            guard let self = self else { return }
            self.isLoading = false

            if let error = error {
                print("DEBUG: FAILED to save user data: \(error.localizedDescription)")
                self.errorMessage = "Failed to save profile: \(error.localizedDescription)"
            } else {
                print("DEBUG: User data saved SUCCESSFULLY!")
                self.authManager.isLoggedIn = true
            }
        }
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }

        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}

extension SocialAuthManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                isLoading = false
                errorMessage = "Invalid state: A login callback was received, but no login request was sent."
                return
            }

            guard let appleIDToken = appleIDCredential.identityToken else {
                isLoading = false
                errorMessage = "Unable to fetch identity token"
                return
            }

            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                isLoading = false
                errorMessage = "Unable to serialize token string from data"
                return
            }

            let credential = OAuthProvider.appleCredential(
                withIDToken: idTokenString,
                rawNonce: nonce,
                fullName: appleIDCredential.fullName
            )

            authenticateWithFirebase(credential: credential, provider: "apple")
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        isLoading = false
        errorMessage = error.localizedDescription
    }
}

extension SocialAuthManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            fatalError("No window scene found")
        }
        guard let window = scene.windows.first(where: { $0.isKeyWindow }) else {
            return scene.windows.first ?? UIWindow(windowScene: scene)
        }
        return window
    }
}
