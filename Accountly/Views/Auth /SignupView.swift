//
//  SignupView.swift
//  Accountly
//
//  Created by Rimsha on 02/02/2026.
//

import SwiftUI
import PhotosUI

struct SignupView: View {
    @StateObject private var viewModel = signUpViewModel()
    @State private var selectedPickerItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("@  Accountly")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("BrandPrimary"))
                    Spacer()
                }
                .padding(.top, 60)
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
                
                Text("Add your Image")
            }
            HStack(spacing: 0.9) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BrandSecondary"))
                        .frame(width : 139, height: 38)

                    if viewModel.firstName.isEmpty {
                        Text("First Name")
                            .foregroundColor(.white)
                            .padding(.leading, 35)
                    }
                    Spacer()
                    HStack {
                        
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                            .padding(.leading, 10)

                        TextField("", text: $viewModel.firstName)
                            .foregroundColor(.white)
                            .padding(.leading, 5)
                    }
                }

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BrandSecondary"))
                        .frame(width : 139, height: 38)

                    if viewModel.lastName.isEmpty {
                        Text("Last Name")
                            .foregroundColor(.white)
                            .padding(.leading, 35)
                    }

                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                            .padding(.leading, 10)

                        TextField("", text: $viewModel.lastName)
                            .foregroundColor(.white)
                            .padding(.leading, 5)
                    }
                }


             }
             .padding(.horizontal, 50)
            HStack(){


                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BrandSecondary"))
                        .frame(width : 300 ,height: 38)
                    
                    if viewModel.contactNumber.isEmpty {
                        Text("Contact Number")
                            .foregroundColor(.white)
                            .padding(.leading, 35)
                    }
                    
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                        
                        TextField("", text: $viewModel.contactNumber)
                            .foregroundColor(.white)
                            .padding(.leading, 4)
                    }
                }
             
            }.padding(.horizontal, 50)
            HStack{
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BrandSecondary"))
                        .frame(width: 127, height: 38)

                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.white)
                           


                        Text("Birth Date")
                            .foregroundColor(.white)

                     
                    }
                    .frame(height: 38)
                }

                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BrandSecondary"))
                        .frame(width: 50, height: 38)
                    
                    if viewModel.birthDay.isEmpty {
                        Text("DD")
                            .foregroundColor(.white)
                    }
                    
                    TextField("", text: $viewModel.birthDay)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                }
                
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BrandSecondary"))
                        .frame(width: 50, height: 38)
                    
                    if viewModel.birthMonth.isEmpty {
                        Text("MM")
                            .foregroundColor(.white)
                    }
                    
                    TextField("", text: $viewModel.birthMonth)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                }
                
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BrandSecondary"))
                        .frame(width: 50, height: 38)
                    
                    if viewModel.birthYear.isEmpty {
                        Text("YYYY")
                            .foregroundColor(.white)
                    }
                    
                    TextField("", text: $viewModel.birthYear)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                }
            }
            .padding(.horizontal, 50)
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
                        
                        TextField("", text: $viewModel.password)
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
                    
                    if viewModel.confirmPassword.isEmpty {
                        Text("Confirm Password")
                            .foregroundColor(.white)
                            .padding(.leading, 35)
                    }
                    
                    HStack{
                        
                        Image(systemName: "key.fill")
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                        
                        TextField("", text: $viewModel.confirmPassword)
                            .foregroundColor(.white)
                            .padding(.leading, 5)
                    }
                }
            }.padding(.horizontal, 50)
            Button(action: {
                viewModel.signUp()
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                        .frame(width: 94, height: 38)
                } else {
                    Text("Sign up")
                        .fontWeight(.semibold)
                        .frame(width: 94, height: 38)
                }
            }
            .background(Color("BrandPrimary"))
            .foregroundColor(.white)
            .cornerRadius(22)
            .padding(.top, 15)
            .padding(.bottom, 40)
        
            .disabled(viewModel.isLoading)

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.system(size: 13))
                    .padding(.top, 5)
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
