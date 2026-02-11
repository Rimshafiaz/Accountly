//
//  ProfileDetailView.swift
//  Accountly
//
//  Created by Rimsha on 10/02/2026.
//

import SwiftUI

struct ProfileDetailView: View {
    let user: User
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("BrandPrimary"))

                        Text("Back")
                            .foregroundColor(Color("BrandPrimary"))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
                .padding(.vertical, 20)

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
                .padding(.horizontal, 30)
                .padding(.vertical, 25)

                Text("\(user.firstName) \(user.lastName)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("BrandPrimary"))
                    .padding(.bottom, 30)

                AsyncImage(url: URL(string: user.profileImageURL ?? "")) { phase in
                    switch phase {
                    case .empty:
                        Circle()
                            .fill(Color("BrandSecondary"))
                            .frame(width: 143, height: 143)
                            .overlay {
                                ProgressView()
                                    .tint(.white)
                            }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 143, height: 143)
                            .clipShape(Circle())
                    case .failure(_):
                        Circle()
                            .fill(Color("BrandGray"))
                            .frame(width: 143, height: 143)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 143, height: 143)
                                    .foregroundColor(.black)
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(.bottom, 30)

                VStack(spacing: 12) {
                    ProfileReadOnlyField(
                        icon: "envelope.fill",
                        text: user.email
                    )

                    ProfileReadOnlyField(
                        icon: "phone.fill",
                        text: user.contactNumber
                    )

                    ProfileReadOnlyField(
                        icon: "calendar",
                        text: "\(user.birthDay)-\(user.birthMonth)-\(user.birthYear)"
                    )
                }
                .padding(.horizontal, 43)

                Spacer()
                    .frame(height: 100)
            }
        }
        .background(Color("AppBackground").ignoresSafeArea())
    }
}

struct ProfileReadOnlyField: View {
    let icon: String
    let text: String

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("BrandSecondary"))
                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 60)


            HStack(spacing: 15) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .frame(width: 20)
                    .padding(.leading, 15)

                Text(text)
                    .font(.body)
                    .foregroundColor(.white)

                Spacer()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileDetailView(
            user: User(
                id: "123",
                firstName: "John",
                lastName: "Doe",
                contactNumber: "0304-1234567",
                birthDay: "24",
                birthMonth: "11",
                birthYear: "2002",
                email: "johndoe@example.com",
                profileImageURL: nil
            )
        )
    }
}
