//
//  MyProfileView.swift
//  Accountly
//
//  Created by Rimsha on 23/01/2026.
//

import SwiftUI

struct MyProfileView: View {
    var body: some View {
        VStack {
            
            HStack {
                          Text("@  Accountly")
                              .font(.largeTitle)
                              .fontWeight(.bold)
                              .foregroundColor(Color("BrandPrimary"))
                          Spacer()
                      }
                      .padding(.top, 40)
                      .padding(.horizontal,30)

      
      Spacer()        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color("AppBackground")
                .ignoresSafeArea()
        }
    }
}

#Preview {
    MyProfileView()
}
