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
                          .padding(.vertical, 20)
                
                HStack(spacing: 12) {
                    Image(systemName: "book")
                        .font(.title2)
                        .foregroundColor(Color("BrandSecondary").opacity(1.2))
                    
                    Text("About")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(Color("BrandPrimary"))
                    

                }
                Spacer()
                    .frame(maxHeight: 24)

                
                VStack(alignment: .leading, spacing: 16) {
                    Text("App Name :")
                        .font(.title.weight(.semibold))
                        .foregroundColor(Color("BrandSecondary").opacity(1.2))
                    
                    Text("Accountly")
                        .font(.title2.weight(.semibold))
                        .foregroundColor(Color("BrandPrimary"))
                    
                    Text("This app helps you securely manage and view user profiles in one place.")
                        .font(.body.weight(.medium))
                        .foregroundColor(Color("BrandPrimary"))

                    Text("You can explore people, view details and update your own profile with ease.")
                        .font(.body.weight(.medium))

                        .foregroundColor(Color("BrandPrimary"))

                    
                    Text("Designed for clarity, privacy, and performance.")
                        .font(.body.weight(.medium))

                        .foregroundColor(Color("BrandPrimary"))
                   
                }
                .frame(maxWidth: .infinity, alignment: .leading)

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
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    AboutView()
}
