//
//  HomeView.swift
//  Accountly
//
//  Created by Rimsha on 23/01/2026.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        
        ScrollView{
            VStack{
                HStack {
                    Text("@  Accountly")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("BrandPrimary"))
                    Spacer()
                }
                .padding(.top, 40)
                .padding(.horizontal,30)
                HStack(){


                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("BrandSecondary"))
                            .frame(width : 316 ,height: 108)
                        Circle()
                            .frame(width: 57, height: 56)
                            .foregroundColor(Color("BrandGray"))//                        if viewModel.contactNumber.isEmpty {
//                            Text("Contact Number")
//                                .foregroundColor(.white)
//                                .padding(.leading, 35)
//                        }
                        
                        HStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                    .scaledToFit()
                                    .frame(width: 31, height: 31)
                                .foregroundColor(.white)
                                .padding(.leading, 10)
                            
//                            TextField("", text: $viewModel.contactNumber)
//                                .foregroundColor(.white)
//                                .padding(.leading, 4)
                        }
                    }
                 
                }.padding(.horizontal, 50)
                
                Spacer()        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color("AppBackground")
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    HomeView()
}
