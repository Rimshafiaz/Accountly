//
//  Loginview.swift
//  Accountly
//
//  Created by Rimsha on 23/01/2026.
//

import SwiftUI

struct Loginview: View {
    @StateObject private var viewModel = LoginViewModel()
    var body: some View {
        ScrollView{
            VStack{
                
                HStack {
                    Text("@  Accountly")
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
                            
                            TextField("", text: $viewModel.password)
                                .foregroundColor(.white)
                                .padding(.leading, 5)
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
                .padding(.bottom, 40)
            
                .disabled(viewModel.isLoading)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.system(size: 13))
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

#Preview {
    Loginview()
}
