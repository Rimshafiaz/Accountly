////
////  SignupView.swift
////  Accountly
////
////  Created by Rimsha on 02/02/2026.
////
//
//import SwiftUI
//import PhotosUI
//
//struct SignupView: View {
//    @StateObject private var viewModel = signUpViewModel()
//    @State private var selectedPickerItem: PhotosPickerItem?
//    @State private var selectedImage: UIImage?
//    @State private var showPassword = false
//    @State private var showConfirmPassword = false
//    
//    var body: some View {
//        ScrollView {
//            VStack {
//                HStack {
//                    Text("@  Accountly")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(Color("BrandPrimary"))
//                    Spacer()
//                }
//                .padding(.top, 60)
//                .padding(.horizontal, 20)
//                
//                PhotosPicker(
//                    selection: $selectedPickerItem,
//                    matching: .images,
//                    photoLibrary: .shared()
//                ) {
//                    ZStack {
//                        Circle()
//                            .frame(width: 143, height: 143)
//                            .foregroundColor(Color("BrandSecondary"))
//                        
//                        if let selectedImage = selectedImage {
//                            Image(uiImage: selectedImage)
//                                .resizable()
//                                .frame(width: 143, height: 143)
//                                .clipShape(Circle())
//                        } else {
//                            Image(systemName: "person.crop.circle.fill")
//                                .resizable()
//                                .frame(width: 143, height: 143)
//                                .foregroundStyle(Color("BrandGray"))
//                        }
//                    }
//                }
//                
//                Text("Add your Image")
//            }
//            HStack(spacing: 0.9) {
//                ZStack(alignment: .leading) {
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color("BrandSecondary"))
//                        .frame(width : 139, height: 38)
//
//                    if viewModel.firstName.isEmpty {
//                        Text("First Name")
//                            .foregroundColor(.white)
//                            .padding(.leading, 35)
//                    }
//                    Spacer()
//                    HStack {
//                        
//                        Image(systemName: "person.fill")
//                            .foregroundColor(.white)
//                            .padding(.leading, 10)
//
//                        TextField("", text: $viewModel.firstName)
//                            .foregroundColor(.white)
//                            .padding(.leading, 5)
//                    }
//                }
//
//                ZStack(alignment: .leading) {
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color("BrandSecondary"))
//                        .frame(width : 139, height: 38)
//
//                    if viewModel.lastName.isEmpty {
//                        Text("Last Name")
//                            .foregroundColor(.white)
//                            .padding(.leading, 35)
//                    }
//
//                    HStack {
//                        Image(systemName: "person.fill")
//                            .foregroundColor(.white)
//                            .padding(.leading, 10)
//
//                        TextField("", text: $viewModel.lastName)
//                            .foregroundColor(.white)
//                            .padding(.leading, 5)
//                    }
//                }
//
//
//             }
//             .padding(.horizontal, 50)
//            HStack(){
//
//
//                ZStack(alignment: .leading) {
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color("BrandSecondary"))
//                        .frame(width : 300 ,height: 38)
//                    
//                    if viewModel.contactNumber.isEmpty {
//                        Text("Contact Number")
//                            .foregroundColor(.white)
//                            .padding(.leading, 35)
//                    }
//                    
//                    HStack {
//                        Image(systemName: "phone.fill")
//                            .foregroundColor(.white)
//                            .padding(.leading, 10)
//                        
//                        TextField("", text: $viewModel.contactNumber)
//                            .foregroundColor(.white)
//                            .padding(.leading, 4)
//                    }
//                }
//             
//            }.padding(.horizontal, 50)
//            HStack{
//                ZStack {
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color("BrandSecondary"))
//                        .frame(width: 127, height: 38)
//
//                    HStack {
//                        Image(systemName: "calendar")
//                            .foregroundColor(.white)
//                           
//
//
//                        Text("Birth Date")
//                            .foregroundColor(.white)
//
//                     
//                    }
//                    .frame(height: 38)
//                }
//
//                ZStack(alignment: .center) {
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color("BrandSecondary"))
//                        .frame(width: 50, height: 38)
//                    
//                    if viewModel.birthDay.isEmpty {
//                        Text("DD")
//                            .foregroundColor(.white)
//                    }
//                    
//                    TextField("", text: $viewModel.birthDay)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                        .keyboardType(.numberPad)
//                }
//                
//                ZStack(alignment: .center) {
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color("BrandSecondary"))
//                        .frame(width: 50, height: 38)
//                    
//                    if viewModel.birthMonth.isEmpty {
//                        Text("MM")
//                            .foregroundColor(.white)
//                    }
//                    
//                    TextField("", text: $viewModel.birthMonth)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                        .keyboardType(.numberPad)
//                }
//                
//                ZStack(alignment: .center) {
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color("BrandSecondary"))
//                        .frame(width: 50, height: 38)
//                    
//                    if viewModel.birthYear.isEmpty {
//                        Text("YYYY")
//                            .foregroundColor(.white)
//                    }
//                    
//                    TextField("", text: $viewModel.birthYear)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                        .keyboardType(.numberPad)
//                }
//            }
//            .padding(.horizontal, 50)
//            HStack{
//              
//                ZStack(alignment: .leading) {
//                    
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color("BrandSecondary"))
//                        .frame(width : 300 ,height: 38)
//                    
//                    if viewModel.email.isEmpty {
//                        Text("Email")
//                            .foregroundColor(.white)
//                            .padding(.leading, 40)
//                    }
//                    
//                    HStack{
//                        
//                        Image(systemName: "envelope.fill")
//                            .foregroundColor(.white)
//                            .padding(.leading, 10)
//                        
//                        TextField("", text: $viewModel.email)
//                            .foregroundColor(.white)
//                            .padding(.leading, 5)
//                    }
//                }
//            }.padding(.horizontal, 50)
//            HStack{
//              
//                ZStack(alignment: .leading) {
//                    
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color("BrandSecondary"))
//                        .frame(width : 300 ,height: 38)
//                    
//                    if viewModel.password.isEmpty {
//                        Text("Password")
//                            .foregroundColor(.white)
//                            .padding(.leading, 35)
//                    }
//                    
//                    HStack{
//                        
//                        Image(systemName: "key.fill")
//                            .foregroundColor(.white)
//                            .padding(.leading, 10)
//                        HStack{
//                        if showPassword {
//                                        TextField("", text: $viewModel.password)
//                                            .foregroundColor(.white)
//                                            .padding(.leading, 5)
//                                    } else {
//                                        SecureField("", text: $viewModel.password)
//                                            .foregroundColor(.white)
//                                            .padding(.leading, 5)
//                                    }
//                                    
//                                    Button(action: {
//                                        showPassword.toggle()
//                                    }) {
//                                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
//                                            .foregroundColor(.white.opacity(0.7))
//                                    }
//                                            .padding(.trailing, 10)
//                                    }
//                                }
//                            }
//                        }.padding(.horizontal, 50)
//            HStack{
//              
//                ZStack(alignment: .leading) {
//                    
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color("BrandSecondary"))
//                        .frame(width : 300 ,height: 38)
//                    
//                    if viewModel.confirmPassword.isEmpty {
//                        Text("Confirm Password")
//                            .foregroundColor(.white)
//                            .padding(.leading, 35)
//                    }
//                    
//                    HStack{
//                        
//                        Image(systemName: "key.fill")
//                            .foregroundColor(.white)
//                            .padding(.leading, 10)
//                        HStack{
//                        if showConfirmPassword {
//                                        TextField("", text: $viewModel.confirmPassword)
//                                            .foregroundColor(.white)
//                                            .padding(.leading, 5)
//                                    } else {
//                                        SecureField("", text: $viewModel.confirmPassword)
//                                            .foregroundColor(.white)
//                                            .padding(.leading, 5)
//                                    }
//                                    
//                                    Button(action: {
//                                        showConfirmPassword.toggle()
//                                    }) {
//                                        Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
//                                            .foregroundColor(.white.opacity(0.7))
//                                    }
//                                            .padding(.trailing, 10)
//                                    }
//                                }
//                            }
//                        }.padding(.horizontal, 50)
//            Button(action: {
//                viewModel.signUp()
//            }) {
//                if viewModel.isLoading {
//                    ProgressView()
//                        .tint(.white)
//                        .frame(width: 94, height: 38)
//                } else {
//                    Text("Sign up")
//                        .fontWeight(.semibold)
//                        .frame(width: 94, height: 38)
//                }
//            }
//            .background(Color("BrandPrimary"))
//            .foregroundColor(.white)
//            .cornerRadius(22)
//            .padding(.top, 15)
//            .padding(.bottom, 8)
//        
//            .disabled(viewModel.isLoading)
//
//            if let error = viewModel.errorMessage {
//                Text(error)
//                    .foregroundColor(.red)
//                    .font(.system(size: 13))
//                    .padding(.top, 5)
//            }
//            
//            HStack {
//                  Text("Already have an account?")
//                      .foregroundColor(.black)
//
//                  NavigationLink(destination: Loginview()) {
//                      Text("Log in")
//                          .fontWeight(.semibold)
//                          .foregroundColor(Color("BrandPrimary"))
//                  }
//              }
//        }
//        .background(Color("AppBackground"))
//        .ignoresSafeArea()
//        .onChange(of: selectedPickerItem) {
//            if let newItem = selectedPickerItem {
//                didSelectImage(newItem)
//            }
//        }
//
//    }
//    
//    private func didSelectImage(_ item: PhotosPickerItem) {
//        Task {
//            if let data = try? await item.loadTransferable(type: Data.self),
//               let uiImage = UIImage(data: data) {
//                selectedImage = uiImage
//                viewModel.profileImage = uiImage
//            }
//        }
//    }
//}
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
            VStack(spacing: 15) {
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
                          .padding(.top, 90)
                .padding(.horizontal, 20)
                .padding(.horizontal, 20)
                
                PhotosPicker(
                    selection: $selectedPickerItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    ZStack {
                        Circle()
                            .frame(width: 143, height: 143)
                            .foregroundColor(Color("BrandSecondary"))
                        
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 143, height: 143)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 143, height: 143)
                                .foregroundStyle(Color("BrandGray"))
                        }
                    }
                }
                .padding(.bottom, 5)
                
                Text("Add your Image")
                    .foregroundColor(.black.opacity(0.7))
                    .padding(.bottom, 12)
                
                HStack(spacing: 0.9) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("BrandSecondary"))
                            .frame(width: 139, height: 38)
                        
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                                .padding(.leading, 15)
                            
                            TextField("First Name", text: $viewModel.firstName)
                                .foregroundColor(.white.opacity(1.2))
                                .autocapitalization(.words)
                                .disableAutocorrection(true)
                                .padding(.leading, 5)
                                .padding(.trailing, 10)
                        }
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("BrandSecondary"))
                            .frame(width: 139, height: 38)
                        
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                                .padding(.leading, 15)
                            
                            TextField("Last Name", text: $viewModel.lastName)
                                .foregroundColor(.white)
                                .autocapitalization(.words)
                                .disableAutocorrection(true)
                                .padding(.leading, 5)
                                .padding(.trailing, 10)
                        }
                    }
                }
                .padding(.horizontal, 50)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BrandSecondary"))
                        .frame(width: 300, height: 38)
                    
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.white)
                    
                            .padding(.leading, 15)
                        
                        TextField("Contact Number", text: $viewModel.contactNumber)
                            .foregroundColor(.white)
                            .keyboardType(.phonePad)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(.leading, 5)
                            .padding(.trailing, 10)
                    }
                }
                .padding(.horizontal, 50)
                
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("BrandSecondary"))
                            .frame(width: 127, height: 38)
                        
                        HStack(spacing: 5) {
                            Image(systemName: "calendar")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .padding(.trailing, 10)
                            
                            
                            Text("Birth Date")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                            
                        }
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("BrandSecondary"))
                            .frame(width: 50, height: 38)
                        
                        TextField("DD", text: $viewModel.birthDay)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("BrandSecondary"))
                            .frame(width: 50, height: 38)
                        
                        TextField("MM", text: $viewModel.birthMonth)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("BrandSecondary"))
                            .frame(width: 50, height: 38)
                        
                        TextField("YYYY", text: $viewModel.birthYear)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                    }
                }
                .padding(.horizontal, 50)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BrandSecondary"))
                        .frame(width: 300, height: 38)
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.white)
                            .padding(.leading, 12)
                        
                        TextField("Email", text: $viewModel.email)
                            .foregroundColor(.white)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(.leading, 5)
                            .padding(.trailing, 10)
                    }
                }
                .padding(.horizontal, 50)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BrandSecondary"))
                        .frame(width: 300, height: 38)
                    
                    HStack {
                        Image(systemName: "key.fill")
                            .foregroundColor(.white)
                            .padding(.leading, 12)
                        
                        if showPassword {
                            TextField("Password", text: $viewModel.password)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding(.leading, 5)
                        } else {
                            SecureField("Password", text: $viewModel.password)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding(.leading, 5)
                        }
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.trailing, 12)
                        }
                    }
                }
                .padding(.horizontal, 50)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BrandSecondary"))
                        .frame(width: 300, height: 38)
                    
                    HStack {
                        Image(systemName: "key.fill")
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                        
                        if showConfirmPassword {
                            TextField("Confirm Password", text: $viewModel.confirmPassword)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding(.leading, 5)
                        } else {
                            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding(.leading, 5)
                        }
                        
                        Button(action: {
                            showConfirmPassword.toggle()
                        }) {
                            Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.trailing, 10)
                        }
                    }
                }
                .padding(.horizontal, 50)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.system(size: 13))
                        .padding(.horizontal, 50)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }

                if let socialError = socialAuthManager.errorMessage {
                    Text(socialError)
                        .foregroundColor(.red)
                        .font(.system(size: 13))
                        .padding(.horizontal, 50)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }

                Button(action: {
                    viewModel.signUp()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color("BrandPrimary"))
                            .frame(width: 94, height: 38)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Sign up")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                    }
                }
                .disabled(viewModel.isLoading)
                .padding(.top, 15)
                .padding(.bottom, 8)

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
                .padding(.top, 10)

                if socialAuthManager.isLoading {
                    ProgressView()
                        .tint(Color("BrandPrimary"))
                        .padding(.top, 5)
                }

                HStack(spacing: 5) {
                    Text("Already have an account?")
                        .foregroundColor(.black.opacity(0.7))
                        .font(.system(size: 14))
                    
                    NavigationLink(destination: Loginview()) {
                        Text("Log in")
                            .fontWeight(.semibold)
                            .foregroundColor(Color("BrandPrimary"))
                            .font(.system(size: 14))
                    }
                }
                .padding(.bottom, 30)
            }
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

#Preview {
    SignupView()
}

