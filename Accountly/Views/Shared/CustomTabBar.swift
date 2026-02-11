//
//  CustomTabBar.swift
//  Accountly
//
//  Created by Rimsha on 09/02/2026.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                selectedTab = 0
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "house.fill")
                        .font(.system(size: selectedTab == 0 ? 24 : 20))
                        .foregroundColor(.white)
                        .opacity(selectedTab == 0 ? 1.0 : 0.5)
                    
                    Text("Home")
                        .font(.system(size: selectedTab == 0 ? 10 : 8))
                        .foregroundColor(.white)
                        .opacity(selectedTab == 0 ? 1.0 : 0.5)
                }
                .frame(maxWidth: .infinity)
            }
            
            Button(action: {
                selectedTab = 1
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "person.fill")
                        .font(.system(size: selectedTab == 1 ? 24 : 20))
                        .foregroundColor(.white)
                        .opacity(selectedTab == 1 ? 1.0 : 0.5)
                    
                    Text("My Profile")
                        .font(.system(size: selectedTab == 1 ? 10 : 8))
                        .foregroundColor(.white)
                        .opacity(selectedTab == 1 ? 1.0 : 0.5)
                }
                .frame(maxWidth: .infinity)
            }
            
            Button(action: {
                selectedTab = 2
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: selectedTab == 2 ? 24 : 20))
                        .foregroundColor(.white)
                        .opacity(selectedTab == 2 ? 1.0 : 0.5)
                    
                    Text("Settings")
                        .font(.system(size: selectedTab == 2 ? 10 : 8))
                        .foregroundColor(.white)
                        .opacity(selectedTab == 2 ? 1.0 : 0.5)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 12)
        .background(Color("BrandPrimary"))
        .cornerRadius(24)
        .padding(.horizontal, 24)
        .padding(.bottom, 10)
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(0))
}
