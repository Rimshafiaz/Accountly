//
//  UserCardView.swift
//  Accountly
//
//  Created by Rimsha on 09/02/2026.
//

import SwiftUI

struct UserCardView: View {
    let user: User
    let action: () -> Void

    init(user: User, action: @escaping () -> Void = {}) {
        self.user = user
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("BrandSecondary"))
                    .frame(width: 316, height: 108)

                HStack(spacing: 15) {
                AsyncImage(url: URL(string: user.profileImageURL ?? "")) { phase in
                    switch phase {
                    case .empty:
                        Circle()
                            .fill(Color("BrandGray"))
                            .frame(width: 57, height: 57)
                            .overlay {
                                ProgressView()
                                    .tint(.white)
                            }
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 57, height: 57)
                            .clipShape(Circle())
                        
                    case .failure(_):
                        Circle()
                            .fill(Color("BrandGray"))
                            .frame(width: 57, height: 57)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .resizable()
                                        .scaledToFit()
                                        .frame(width: 31, height: 31)
                                    .foregroundColor(.black)
                                    .padding(.leading, 2 )
                            }
                        
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 57, height: 57)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(user.firstName) \(user.lastName)")
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                    
                    Text(user.email)
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                    
                    Text(user.contactNumber)
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                    
                    Text("\(user.birthDay)/\(user.birthMonth)/\(user.birthYear)")
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.leading, 15)
        }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 316, height: 108)
    }
}
#Preview {
    let mockUser = User(
        id: "123",
        firstName: "John",
        lastName: "Doe",
        contactNumber: "0304-1234567",
        birthDay: "24",
        birthMonth: "11",
        birthYear: "2002",
        email: "johndoe@example.com",
        profileImageURL: "https://example.com/profile.jpg"
    )
    
    UserCardView(user: mockUser) {
        print("Tapped on \(mockUser.firstName)")
    }
    .frame(width: 316, height: 108)
    .padding()
    .background(Color("AppBackground"))
}
