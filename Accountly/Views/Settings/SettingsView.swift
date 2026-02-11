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

                          .padding(.top, 40)
                          .padding(.bottom,20)
                
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
                            
                            Text("My Account")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .frame(width: 293, height: 49)
                        .background(Color("BrandSecondary"))
                        .cornerRadius(20)
                    }
                    
                    Button(action: {
                        authManager.logout()
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 24)
                            
                            Text("Log out")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .frame(width: 293, height: 49)
                        .background(Color("BrandSecondary"))
                        .cornerRadius(20)
                    }
                    
                    Button(action: {
                        navigateToAbout = true
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 24)
                            
                            Text("About")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .frame(width: 293, height: 49)
                        .background(Color("BrandSecondary"))
                        .cornerRadius(20)
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
