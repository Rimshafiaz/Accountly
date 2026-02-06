//
//  MainTabView.swift
//  Accountly
//
//  Created by Rimsha on 23/01/2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
      
            TabView {
                // Tab 1
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                // Tab 2
                MyProfileView()
                    .tabItem {
                        Label("My Profile" , systemImage: "person.circle.fill")
                    }
                //Tab 3
                SettingsView()
                    .tabItem {
                        Label("Settings ", systemImage: "gear")
                    }
            }
        }
    }


#Preview {
    MainTabView()
}
