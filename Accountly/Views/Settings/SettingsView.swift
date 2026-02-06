//
//  SettingsView.swift
//  Accountly
//
//  Created by Rimsha on 23/01/2026.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color("AppBackground")
                .ignoresSafeArea()

            VStack {
                HStack {
                    Text("@  Accountly")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("BrandPrimary"))
                    Spacer()
                }
                .padding(.top, 40)
                .padding(.horizontal, 30)

                Spacer()
            }
        }
    }
}

#Preview {
    SettingsView()
}
