//
//  SettingsView.swift
//  Accountly
//
//  Created by Rimsha on 23/01/2026.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @Binding var selectedTab: Int
    @State private var navigateToAbout = false
    @State private var showDeleteAlert = false
    @State private var deleteError = ""
    @State private var showDeleteError = false
    @State private var isDeleting = false
    
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
                    .padding(.top, 15)
                          .padding(.bottom, 35)
                
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
                        selectedTab = 1
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
                        if isDeleting { return }
                        showDeleteAlert = true
                    }) {
                        HStack(spacing: 15) {
                            if isDeleting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(width: 24)
                                    .padding(.leading, 15)
                            } else {
                                Image(systemName: "trash.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 24)
                                    .padding(.leading, 15)
                            }

                            Text("Delete Account")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)

                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 40 ,maxHeight: 55)
                        .background(Color.red)
                        .cornerRadius(22)
                        .padding(.horizontal, 40)
                        .opacity(isDeleting ? 0.6 : 1.0)
                    }
                }
                .padding(.horizontal, 5)
                
                Spacer()
              
            }
            .background(Color("AppBackground").ignoresSafeArea())
            .navigationDestination(isPresented: $navigateToAbout) {
                AboutView()
            }
            .alert("Delete Account", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteAccount()
                }
            } message: {
                Text("This action cannot be undone. All your data will be permanently deleted.")
            }
            .alert("Error", isPresented: $showDeleteError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(deleteError)
            }

        }
        
    }
    private func deleteAccount() {
          isDeleting = true

          AuthenticationManager.shared.deleteAccount { success, error in
              DispatchQueue.main.async {
                  isDeleting = false
                  if let error = error {
                      deleteError = error.localizedDescription
                      showDeleteError = true
                  }
              }
          }
      }
}

#Preview {
    SettingsView(selectedTab: .constant(2))
}
