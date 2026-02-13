//
//  HomeView.swift
//  Accountly
//
//  Created by Rimsha on 23/01/2026.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedUser: User?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
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
                .padding(.vertical, 15)
                .padding(.horizontal, 30)
                
                HStack(spacing: 12) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color("BrandSecondary"))
                    
                    Text("Community")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(Color("BrandPrimary"))
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
                
                if viewModel.isLoading {
                    ProgressView()
                        .tint(Color("BrandPrimary"))
                        .padding(.top, 50)
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Color("BrandPrimary"))
                        
                        Text(error)
                            .foregroundColor(Color("BrandPrimary"))
                            .multilineTextAlignment(.center)
                        
                        Button("Retry") {
                            viewModel.fetchAllUsers()
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color("BrandPrimary"))
                        .cornerRadius(10)
                    }
                    .padding(.top, 50)
                } else {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.users) { user in
                            UserCardView(user: user) {
                                selectedUser = user
                            }
                        }
                    }
                    .padding(.horizontal, 43)
                }
                
                Spacer()
                    .frame(minHeight: 100)
            }
        }
        .background(Color("AppBackground").ignoresSafeArea())
        .onAppear {
            viewModel.fetchAllUsers()
        }
        .fullScreenCover(item: $selectedUser) { user in
            NavigationStack {
                ProfileDetailView(user: user)
            }
        }
    }
}

#Preview {
    HomeView()
}
