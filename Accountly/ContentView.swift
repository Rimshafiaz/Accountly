//
//  ContentView.swift
//  Accountly
//
//  Created by Rimsha on 23/01/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    
    var body: some View {
        if authManager.isLoggedIn {
            MainTabContainerView()
        } else {
            NavigationStack {
                Loginview()
            }
        }
    }
}
#Preview {
    ContentView()
}
