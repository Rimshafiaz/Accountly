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
        ScrollView{
            VStack{
                
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
                          .padding(.top, 40)
                .padding(.horizontal, 20)
                .padding(.bottom , 140)

                Text("Login to your Account")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("BrandPrimary"))
                HStack{
                    
                    ZStack(alignment: .leading) {
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("BrandSecondary"))
                            .frame(width : 300 ,height: 38)
                        
                        if viewModel.email.isEmpty {
                            Text("Email")
                                .foregroundColor(.white)
                                .padding(.leading, 40)
                        }
                        
                        HStack{
                            
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.white)
                                .padding(.leading, 10)
                            
                            TextField("", text: $viewModel.email)
                                .foregroundColor(.white)
                                .padding(.leading, 5)
                        }
                    }
                }.padding(.horizontal, 50)
                HStack{
                    
                    ZStack(alignment: .leading) {
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("BrandSecondary"))
                            .frame(width : 300 ,height: 38)
                        
                        if viewModel.password.isEmpty {
                            Text("Password")
                                .foregroundColor(.white)
                                .padding(.leading, 35)
                        }
                        
                        HStack{
                            
                            Image(systemName: "key.fill")
                                .foregroundColor(.white)
                                .padding(.leading, 10)
                            
                            if showPassword {
                                            TextField("", text: $viewModel.password)
                                                .foregroundColor(.white)
                                                .padding(.leading, 5)
                                        } else {
                                            SecureField("", text: $viewModel.password)
                                                .foregroundColor(.white)
                                                .padding(.leading, 5)
                                        }
                                        
                                        Button(action: {
                                            showPassword.toggle()
                                        }) {
                                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                                .foregroundColor(.white.opacity(0.7))
                                                .padding(.trailing, 10)
                                        }
                                    }
                                }
                            }.padding(.horizontal, 50)
                Button(action: {
                    viewModel.login()
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(width: 94, height: 38)
                    } else {
                        Text("Log in ")
                            .fontWeight(.semibold)
                            .frame(width: 94, height: 38)
                    }
                }
                .background(Color("BrandPrimary"))
                .foregroundColor(.white)
                .cornerRadius(22)
                .padding(.top, 15)
                .padding(.bottom, 20)
            
                .disabled(viewModel.isLoading)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.system(size: 13))
                        .padding(.top, 5)
                }

                if let socialError = socialAuthManager.errorMessage {
                    Text(socialError)
                        .foregroundColor(.red)
                        .font(.system(size: 13))
                        .padding(.top, 5)
                }
                
                HStack {
                     Text("Don't have an account yet?")
                         .foregroundColor(.black)

                     NavigationLink(destination: SignupView()) {
                         Text("Sign up")
                             .fontWeight(.semibold)
                             .foregroundColor(Color("BrandPrimary"))
                     }
                 }

                HStack(spacing: 13) {
                    GoogleSignInButton(action: {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let rootViewController = windowScene.windows.first?.rootViewController {
                            socialAuthManager.signInWithGoogle(presenting: rootViewController)
                        }
                    })
                    .disabled(socialAuthManager.isLoading)

                    AppleSignInButton(action: {
                        socialAuthManager.signInWithApple()
                    })
                    .disabled(socialAuthManager.isLoading)
                }

                if socialAuthManager.isLoading {
                    ProgressView()
                        .tint(Color("BrandPrimary"))
                        .padding(.top, 5)
                }


            
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color("AppBackground")
                .ignoresSafeArea()

        }
    }
}

struct GoogleSignInButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "globe")
                    .resizable()
                    .frame(width: 15, height: 15)

                Text("Login wih Google")
                    .font(.system(size: 12))
            }
            .foregroundColor(.white)
            .frame(width: 128, height: 35)
            .background(Color("BrandPrimary"))
            .cornerRadius(21)
        }
    }
}

struct AppleSignInButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "applelogo")
                    .resizable()
                    .frame(width: 15, height: 15)

                Text("Login with Apple")
                    .font(.system(size: 12))
            }
            .foregroundColor(.white)
            .frame(width: 128, height: 35)
            .background(Color("BrandPrimary"))
            .cornerRadius(20)
        }
    }
}

#Preview {
    Loginview()
}
