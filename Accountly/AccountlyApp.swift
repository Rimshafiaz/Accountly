//
//  AccountlyApp.swift
//  Created by Rimsha on 23/01/2026.
//

import SwiftUI
import FirebaseCore

@main
struct AccountlyApp: App {

    @StateObject private var authManager = AuthenticationManager.shared

    init() {
        let options = FirebaseOptions(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!)!
        options.databaseURL = "https://accountly-fb448-default-rtdb.firebaseio.com/"
        FirebaseApp.configure(options: options)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
        }
    }
}

