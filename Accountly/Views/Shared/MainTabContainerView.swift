//
//  MainTabView.swift
//  Accountly
//
//  Created by Rimsha on 23/01/2026.
//



import SwiftUI

struct MainTabContainerView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            switch selectedTab {
            case 0:
                HomeView()
            case 1:
                MyProfileView()
            case 2:
                SettingsView()
            default:
                HomeView()
            }
            
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}
#Preview {
    MainTabContainerView()
}
