//
//  MyProfileView.swift
//  Accountly
//
//  Created by Rimsha on 23/01/2026.
//

import SwiftUI
import PhotosUI

struct MyProfileView: View {
    @StateObject private var viewModel = MyProfileViewModel()
    @State private var selectedPickerItem: PhotosPickerItem?
    @State private var showPassword = false
    @State private var showDatePicker = false
    @State private var showCountryPicker = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerSection
                contentSection
            }
        }
        .background(Color("AppBackground").ignoresSafeArea())
        .onAppear {
            viewModel.fetchCurrentUserProfile()
        }
        .onChange(of: selectedPickerItem) {
            if let newItem = selectedPickerItem {
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        viewModel.profileImage = uiImage
                    }
                }
            }
        }
    }

    private var headerSection: some View {
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
        .padding(.top, 15)
        .padding(.bottom, 35)
        .padding(.horizontal, 30)
       
    }

    private var contentSection: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.errorMessage {
                errorView(error)
            } else if viewModel.currentUser != nil {
                profileContent
            }
        }
    }

    private var loadingView: some View {
        ProgressView()
            .tint(Color("BrandPrimary"))
            .padding(.top, 50)
    }

    private func errorView(_ error: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(Color("BrandPrimary"))

            Text(error)
                .foregroundColor(Color("BrandPrimary"))
                .multilineTextAlignment(.center)

            Button("Retry") {
                viewModel.fetchCurrentUserProfile()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 12)
            .background(Color("BrandPrimary"))
            .cornerRadius(10)
        }
        .padding(.top, 50)
    }

    private var profileContent: some View {
        VStack(spacing: 20) {
            userNameSection
            profileImageSection
            if let validationError = viewModel.validationError {
                validationErrorView(validationError)
            }
            profileFieldsSection
            actionButtonsSection
        }
    }

    private func validationErrorView(_ error: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.white)
            Text(error)
                .font(.system(size: 12))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.red.opacity(0.9))
        .cornerRadius(10)
    }

    private var userNameSection: some View {
        Text("\(viewModel.firstName) \(viewModel.lastName)")
            .font(.title)
            .fontWeight(.medium)
            .foregroundColor(Color("BrandPrimary"))
    }

    private var profileImageSection: some View {
        Group {
            if viewModel.isEditMode {
                profileImagePicker
            } else {
                profileImageDisplay
            }
        }
    }

    private var profileImagePicker: some View {
        PhotosPicker(
            selection: $selectedPickerItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            ZStack {
                Circle()
                    .frame(width: 143, height: 143)
                    .foregroundColor(Color("BrandSecondary"))

                if let profileImage = viewModel.profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 85, height: 85)
                        .clipShape(Circle())
                } else if let urlString = viewModel.profileImageURL,
                          let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 143, height: 143)
                            .foregroundStyle(Color("BrandGray"))
                    }
                    .frame(width: 143, height: 143)
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 143, height: 143)
                        .foregroundStyle(Color("BrandGray"))
                }
            }
        }
    }

    private var profileImageDisplay: some View {
        AsyncImage(url: URL(string: viewModel.profileImageURL ?? "")) { phase in
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
                    .fill(Color("BrandSecondary"))
                    .frame(width: 143, height: 143)
                    .overlay {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 143, height: 143)
                            .foregroundStyle(Color("BrandGray"))
                    }
            @unknown default:
                EmptyView()
            }
        }
    }

    private var profileFieldsSection: some View {
        VStack(spacing: 10) {
            nameFields
            contactField
            dobField
            emailField
            passwordField
        }
        .padding(.horizontal, 43)
        .padding(.top, 20)
    }

    private var nameFields: some View {
        Group {
            if viewModel.isEditMode {
                HStack(spacing: 10) {
                firstNameField
                lastNameField
                }
            } else {
                ProfileInfoField(
                    icon: "person.fill",
                    text: "\(viewModel.firstName) \(viewModel.lastName)"
                )
            }
        }
    }

    private var firstNameField: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("BrandSecondary"))
                .frame(maxWidth: .infinity, minHeight: 40)

            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.white)
                    .padding(.leading, 15)

                TextField("First Name", text: $viewModel.firstName)
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
            }
        }
    }

    private var lastNameField: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("BrandSecondary"))
                .frame(maxWidth: .infinity, minHeight: 40)

            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.white)
                    .padding(.leading, 15)

                TextField("Last Name", text: $viewModel.lastName)
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
            }
        }
    }

    private var contactField: some View {
        Group {
            if viewModel.isEditMode {
                HStack(spacing: 8) {
                    
                    Button {
                        showCountryPicker = true
                    } label: {
                        HStack(spacing: 2) {
                            Text(viewModel.countryCode)
                                .font(.system(size: 13))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 8))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 8)
                        .frame(height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("BrandSecondary"))
                        )
                    }

                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("BrandSecondary"))
                            .frame(maxWidth: .infinity, minHeight: 40)

                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.white)
                                .padding(.leading, 15)

                            TextField("Contact Number", text: $viewModel.contactNumber)
                                .foregroundColor(.white)
                                .keyboardType(.phonePad)
                           
                        }
                       
                    }
                    
                }
                if showCountryPicker {
                    CountryCodePicker(
                        selectedCountryCode: $viewModel.countryCode,
                        isPresented: $showCountryPicker
                    )
                }
                  
            } else {
                ProfileInfoField(
                    icon: "phone.fill",
                    text: viewModel.contactNumber.isEmpty ? "" : "\(viewModel.countryCode) \(viewModel.contactNumber)"
                )
            }
        }
    }

    private var dobField: some View {
        VStack(spacing: 10) {
            if viewModel.isEditMode {
                HStack(spacing: 22) {
                    birthDayField
                    birthMonthField
                    birthYearField
                }

                if showDatePicker {
                    DOBDatePicker(
                        birthDay: $viewModel.birthDay,
                        birthMonth: $viewModel.birthMonth,
                        birthYear: $viewModel.birthYear,
                        isPresented: $showDatePicker
                    )
                    
                }

               
            } else {
                ProfileInfoField(
                    icon: "calendar",
                    text: "\(viewModel.birthDay)-\(viewModel.birthMonth)-\(viewModel.birthYear)"
                )
            }
        }
    }

    private var birthDayField: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("BrandSecondary"))
                .frame(maxWidth: .infinity, minHeight: 40)

            Text(viewModel.birthDay.isEmpty ? "DD" : viewModel.birthDay)
                .foregroundColor(viewModel.birthDay.isEmpty ? .white.opacity(0.5) : .white)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .contentShape(Rectangle())
                .onTapGesture {
                    showDatePicker = true
                }
        }
    }

    private var birthMonthField: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("BrandSecondary"))
                .frame(maxWidth: .infinity, minHeight: 40)

            Text(viewModel.birthMonth.isEmpty ? "MM" : viewModel.birthMonth)
                .foregroundColor(viewModel.birthMonth.isEmpty ? .white.opacity(0.5) : .white)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .contentShape(Rectangle())
                .onTapGesture {
                    showDatePicker = true
                }
        }
    }

    private var birthYearField: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("BrandSecondary"))
                .frame(maxWidth: .infinity, minHeight: 40)

            Text(viewModel.birthYear.isEmpty ? "YYYY" : viewModel.birthYear)
                .foregroundColor(viewModel.birthYear.isEmpty ? .white.opacity(0.5) : .white)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .contentShape(Rectangle())
                .onTapGesture {
                    showDatePicker = true
                }
        }
    }

    private var emailField: some View {
        Group {
            if viewModel.isEditMode {
                EditableProfileField(
                    icon: "envelope.fill",
                    text: $viewModel.email,
                    isEditable: false
                )
            } else {
                ProfileInfoField(
                    icon: "envelope.fill",
                    text: viewModel.email
                )
            }
        }
    }

    private var passwordField: some View {
        Group {
            if viewModel.isEditMode {
                passwordEditField
            } else {
                ProfileInfoField(
                    icon: "lock.fill",
                    text: "********"
                )
            }
        }
    }

    private var passwordEditField: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("BrandSecondary"))
                    .frame(maxWidth: .infinity, minHeight: 40)

                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.white)
                        .padding(.leading, 15)

                    if showPassword {
                        TextField("New Password (optional)", text: $viewModel.password)
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    } else {
                        SecureField("New Password (optional)", text: $viewModel.password)
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }

                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.trailing, 15)
                    }
                }
            }

            if !viewModel.password.isEmpty {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BrandSecondary"))
                        .frame(maxWidth: .infinity, minHeight: 40)

                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white)
                            .padding(.leading, 15)

                        if showPassword {
                            TextField("Confirm Password", text: $viewModel.confirmPassword)
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        } else {
                            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }

                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.trailing, 15)
                        }
                    }
                }
            }
        }
    }

    private var actionButtonsSection: some View {
        HStack(spacing: 15) {
            if viewModel.isEditMode {
           
                cancelButton
                saveChangesButton
            } else {
              
                editInfoButton
            }
        }
        .padding(.top,15)
        .padding(.horizontal, 43)
        .padding(.bottom, 300)
    }

    private var editInfoButton: some View {
        Button(action: {
            viewModel.isEditMode = true
            viewModel.loadUserDataForEditing()
        }) {
            HStack(spacing: 8) {
                Image(systemName: "pencil")
                    .font(.system(size: 12))
                Text("Edit Info")
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 40)
            
            .background(Color("BrandPrimary"))
            .cornerRadius(20)
            .padding(.horizontal, 100)
            
        }
    }

    private var cancelButton: some View {
        Button(action: {
        
            viewModel.isEditMode = false
            viewModel.fetchCurrentUserProfile()
        }) {
            HStack(spacing: 8) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 12))
                Text("Cancel")
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 40)
            .background(Color.red)
            .cornerRadius(20)
        }
    }

    private var saveChangesButton: some View {
        Button(action: {
            viewModel.saveChanges()
        }) {
            HStack(spacing: 8) {
                if viewModel.isSaving {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 12))
                    Text("Save")
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 40)
            .background(Color("BrandPrimary"))
            .cornerRadius(20)
        }
        .disabled(viewModel.isSaving || !viewModel.hasChanges)
        .opacity(!viewModel.hasChanges ? 0.5 : 1.0)
    }
}

struct ProfileInfoField: View {
    let icon: String
    let text: String

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("BrandSecondary"))
                .frame(maxWidth: .infinity, minHeight: 40)

            HStack(spacing: 15) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .frame(width: 20)
                    .padding(.leading, 15)

                Text(text)
                    .font(.system(size: 14))
                    .foregroundColor(.white)

                Spacer()
            }
        }
    }
}

struct EditableProfileField: View {
    let icon: String
    @Binding var text: String
    let isEditable: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("BrandSecondary"))
                .frame(maxWidth: .infinity, minHeight: 40)


            HStack(spacing: 15) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .frame(width: 20)
                    .padding(.leading, 15)

                if isEditable {
                    TextField("", text: $text)
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.horizontal, 43)
                } else {
                    Text(text)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }

                Spacer()
            }
        }
    }
}

#Preview {
    MyProfileView()
}
