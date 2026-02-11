//
//  SettingsView.swift
//  Accountly
//
//  Created by Rimsha on 23/01/2026.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @State private var navigateToProfile = false
    @State private var navigateToAbout = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
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
                }                .padding(.horizontal, 30)

                          .padding(.vertical, 35)
                
                HStack(spacing: 12) {
                    Image(systemName: "gear")
                        .font(.title2)
                        .foregroundColor(Color("BrandSecondary").opacity(1.2))
                    
                    Text("Settings")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(Color("BrandPrimary"))
                    
                    Spacer()

                }
                .padding(.bottom, 32)
                .padding(.horizontal,30)
                
                VStack(spacing: 20) {
                    Button(action: {
                        navigateToProfile = true
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 24)
                                .padding(.leading, 15)
                            
                            Text("My Account")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 40 ,maxHeight: 55)
                        .background(Color("BrandSecondary"))
                        .cornerRadius(22)
                        .padding(.horizontal, 40)
                    }
                    
                    Button(action: {
                        authManager.logout()
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 24)
                                .padding(.leading, 15)
                            
                            Text("Log out")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 40 ,maxHeight: 55)
                        .background(Color("BrandSecondary"))
                        .cornerRadius(22)
                        .padding(.horizontal, 40)
                    }
                    
                    Button(action: {
                        navigateToAbout = true
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 24)
                                .padding(.leading, 15)
                            
                            Text("About")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        
                        .frame(maxWidth: .infinity, minHeight: 40 ,maxHeight: 55)
                        .background(Color("BrandSecondary"))
                        .cornerRadius(22)
                        .padding(.horizontal, 40)
                    }
                }
                .padding(.horizontal, 5)
                
                Spacer()
              
            }
            .background(Color("AppBackground").ignoresSafeArea())
            .navigationDestination(isPresented: $navigateToProfile) {
MyProfileView()            }
            .navigationDestination(isPresented: $navigateToAbout) {
                AboutView()
            }
          
        }
        
    }
}

#Preview {
    SettingsView()
}
