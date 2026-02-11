//
//  SignupView.swift
//  Accountly
//
//  Created by Rimsha on 02/02/2026.


import SwiftUI
import PhotosUI

struct SignupView: View {
    @StateObject private var viewModel = signUpViewModel()
    @StateObject private var socialAuthManager = SocialAuthManager()
    @State private var selectedPickerItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
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
                .padding(.vertical, 40)
                .padding(.horizontal, 20)
                
                PhotosPicker(
                    selection: $selectedPickerItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    ZStack {
                        Circle()
                            .fill(Color("BrandSecondary"))
                            .frame(width: 140, height: 140)
                        
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 140, height: 140)
                                .foregroundStyle(Color("BrandGray"))
                        }
                    }
                }
                
                Text("Add your Image")
                    .foregroundColor(.black.opacity(0.7))
                
                HStack(spacing: 9) {
                    SAuthField(icon: "person.fill", placeholder: "First Name", text: $viewModel.firstName)
                        .frame(minWidth: 145, maxWidth: .infinity)
                    
                    SAuthField(icon: "person.fill", placeholder: "Last Name", text: $viewModel.lastName)
                    .frame(minWidth: 145, maxWidth: .infinity)}
                .padding(.horizontal, 40)
               
                
                SAuthField(icon: "phone.fill", placeholder: "Contact Number", text: $viewModel.contactNumber)
                    .keyboardType(.phonePad)
                    .padding(.horizontal, 40)
                

                HStack(spacing: 8) {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("BrandSecondary"))
                            .frame(height: 38)
                        
                        HStack(spacing: 5) {
                            Image(systemName: "calendar")
                                .foregroundColor(.white)
                            Text("Birth Date")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                        .padding(.horizontal, 10)
                    }
                    .frame(width: 120)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("BrandSecondary"))
                            .frame(height: 38)
                        
                        TextField("DD", text: $viewModel.birthDay)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .padding(.horizontal, 5)
                    }
                    .frame(minWidth: 50)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("BrandSecondary"))
                            .frame(height: 38)
                        
                        TextField("MM", text: $viewModel.birthMonth)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .padding(.horizontal, 5)
                    }
                    .frame(minWidth: 50)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("BrandSecondary"))
                            .frame(height: 38)
                        
                        TextField("YYYY", text: $viewModel.birthYear)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .padding(.horizontal, 5)
                    }
                    .frame(minWidth: 65)
                }
                .padding(.horizontal, 40)

                SAuthField(icon: "envelope.fill", placeholder: "Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .padding(.horizontal, 40)
                ZStack {
                    SAuthField(icon: "key.fill",
                               placeholder: "Password",
                               text: $viewModel.password,
                               isSecure: !showPassword)
                    
                    HStack {
                        Spacer()
                        Button {
                            showPassword.toggle()
                        } label: {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.trailing, 12)
                        }
                    }
                }
                .padding(.horizontal, 40)
                ZStack {
                    SAuthField(icon: "key.fill",
                               placeholder: "Confirm Password",
                               text: $viewModel.confirmPassword,
                               isSecure: !showConfirmPassword)
                    
                    HStack {
                        Spacer()
                        Button {
                            showConfirmPassword.toggle()
                        } label: {
                            Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.trailing, 12)
                        }
                    }
                }.padding(.horizontal, 40)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                if let socialError = socialAuthManager.errorMessage {
                    Text(socialError)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Button(action: { viewModel.signUp() }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color("BrandPrimary"))
                            .frame(height: 44)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Sign up")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(minWidth: 93 ,maxWidth: 100)
                    .padding(.horizontal, 40)
                }
                .disabled(viewModel.isLoading)
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.black.opacity(0.7))
                    
                    NavigationLink(destination: Loginview()) {
                        Text("Log in")
                            .fontWeight(.semibold)
                            .foregroundColor(Color("BrandPrimary"))
                    }
                }
                
                HStack(spacing: 15) {
                    SGoogleButton {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let rootVC = windowScene.windows.first?.rootViewController {
                            socialAuthManager.signInWithGoogle(presenting: rootVC)
                        }
                    }
                    .disabled(socialAuthManager.isLoading)
                    
                    SAppleButton {
                        socialAuthManager.signInWithApple()
                    }
                    .disabled(socialAuthManager.isLoading)
                }
                .padding(.horizontal, 40)
                
                if socialAuthManager.isLoading {
                    ProgressView()
                        .tint(Color("BrandPrimary"))
                }
                
               
            }
            .padding(.vertical, 20)
        }
        .background(Color("AppBackground"))
        .ignoresSafeArea()
        .onChange(of: selectedPickerItem) {
            if let newItem = selectedPickerItem {
                didSelectImage(newItem)
            }
        }

    }
    
    private func didSelectImage(_ item: PhotosPickerItem) {
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                selectedImage = uiImage
                viewModel.profileImage = uiImage
            }
        }
    }
}

struct SAuthField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .padding(.leading, 12)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.leading, 5)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.leading, 5)
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, minHeight: 38, maxHeight: 44)
        .background(Color("BrandSecondary"))
        .cornerRadius(22)
    }
}

struct SGoogleButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "globe")
                Text("Login with Google").font(.subheadline)
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .foregroundColor(.white)
            .background(Color("BrandPrimary"))
            .cornerRadius(22)
        }
    }
}

struct SAppleButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "applelogo")
                Text("Login with Apple").font(.subheadline)
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .foregroundColor(.white)
            .background(Color("BrandPrimary"))
            .cornerRadius(22)
        }
    }
}

#Preview {
    SignupView()
}

