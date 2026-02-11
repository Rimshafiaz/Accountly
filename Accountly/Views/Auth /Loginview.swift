//
//  Loginview.swift
//  Accountly
//
//  Created by Rimsha on 23/01/2026.
//


import SwiftUI

struct Loginview: View {
    @StateObject private var viewModel = LoginViewModel()
    @StateObject private var socialAuthManager = SocialAuthManager()
    @State private var showPassword = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

               
                HStack {
                    Text("ⓐ")
                        .font(.system(size: 28))
                        .fontWeight(.bold)
                        .foregroundColor(Color("BrandPrimary"))

                    Text("Accountly")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("BrandPrimary"))

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 30)
                .padding(.bottom , 140)


                Text("Login to your Account")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("BrandPrimary"))
                    .padding(.top, 10)

               
                AuthField(
                    icon: "envelope.fill",
                    placeholder: "Email",
                    text: $viewModel.email
                )

              
                ZStack {
                    AuthField(
                        icon: "key.fill",
                        placeholder: "Password",
                        text: $viewModel.password,
                        isSecure: !showPassword
                    )

                    HStack {
                        Spacer()
                        Button {
                            showPassword.toggle()
                        } label: {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.trailing, 50)
                        }
                    }
                }

            
                Button {
                    viewModel.login()
                } label: {
                    Group {
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Log in")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(minWidth:83, maxWidth: 100, minHeight: 48, maxHeight: 38)
                }
                .background(Color("BrandPrimary"))
                .foregroundColor(.white)
                .cornerRadius(24)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .disabled(viewModel.isLoading)

          
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                if let socialError = socialAuthManager.errorMessage {
                    Text(socialError)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                HStack {
                    Text("Don't have an account yet?")
                    NavigationLink("Sign up", destination: SignupView())
                        .fontWeight(.medium)
                        .foregroundColor(Color("BrandPrimary"))
                }.padding(.vertical, 10)

       
                HStack(spacing: 12) {
                    GoogleSignInButton {
                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let root = scene.windows.first?.rootViewController {
                            socialAuthManager.signInWithGoogle(presenting: root)
                        }
                    }

                    AppleSignInButton {
                        socialAuthManager.signInWithApple()
                    }
                }
                .padding(.horizontal,40)

                if socialAuthManager.isLoading {
                    ProgressView()
                        .tint(Color("BrandPrimary"))
                }

                Spacer(minLength: 30)
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color("AppBackground").ignoresSafeArea())
    }
}
struct AuthField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.white)

            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 38, maxHeight: 45)
        .background(Color("BrandSecondary"))
        .cornerRadius(25)
        .padding(.horizontal,40)
    }
}


struct GoogleSignInButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "globe")
                Text("Login with Google")
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .foregroundColor(.white)
            .background(Color("BrandPrimary"))
            .cornerRadius(22)
        }
    }
}

struct AppleSignInButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "applelogo")
                Text("Login with Apple")
                    .font(.subheadline)
//
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .foregroundColor(.white)
            .background(Color("BrandPrimary"))
            .cornerRadius(22)
            
        }
    }
}

#Preview {
    Loginview()
}
