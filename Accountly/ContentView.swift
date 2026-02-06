//
//  ContentView.swift
//  Accountly
//
//  Created by Rimsha on 23/01/2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        Group {
            if authManager.isLoggedIn {
                // Show main app when user is logged in
                VStack {
                    MainTabView()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Color("AppBackground")
                        .ignoresSafeArea()
                }
            } else {
                // Show login screen when user is not logged in
                NavigationView {
                    Loginview()
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
