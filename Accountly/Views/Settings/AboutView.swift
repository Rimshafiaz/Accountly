//
//  AboutView.swift
//  Accountly
//
//  Created by Rimsha on 23/01/2026.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
       
            Color("AppBackground")
                .ignoresSafeArea()
         
            
            VStack(alignment: .leading, spacing: 24) {
                
                HStack {
                              Text("@ Accountly")
                                  .font(.largeTitle)
                                  .fontWeight(.bold)
                                  .foregroundColor(Color("BrandPrimary"))
                              Spacer()
                          }
                          .padding(.top, 20)
                
                HStack(spacing: 12) {
                    Image(systemName: "book")
                        .font(.title2)
                        .foregroundColor(Color("BrandSecondary").opacity(1.2))
                    
                    Text("About")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(Color("BrandPrimary"))
                    
                    Spacer()

                }
                .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("App Name :")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color("BrandSecondary").opacity(1.2))
                    
                    Text("Accountly")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(Color("BrandPrimary"))
                    
                    Text("This app helps you securely manage and view user profiles in one place.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("BrandPrimary"))

                    Text("You can explore people, view details and update your own profile with ease.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("BrandPrimary"))

                    
                    Text("Designed for clarity, privacy, and performance.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("BrandPrimary"))
                   
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.8), lineWidth: 4)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                        )
                )
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    AboutView()
}
