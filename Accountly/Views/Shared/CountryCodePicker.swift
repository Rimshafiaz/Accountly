//
//  CountryCodePicker.swift
//  Accountly
//
//  Created by Rimsha on 17/02/2026.
//

import SwiftUI

// MARK: - Country Model
struct Country: Identifiable {
    let id: UUID = UUID()
    let name: String
    let code: String
    let dialCode: String
    let flag: String
}

// MARK: - Country Data Provider
class CountryDataProvider {
    static let shared = CountryDataProvider()

    private let countries: [Country] = [
        Country(name: "United States", code: "US", dialCode: "+1", flag: "🇺🇸"),
        Country(name: "Pakistan", code: "PK", dialCode: "+92", flag: "🇵🇰"),
        Country(name: "India", code: "IN", dialCode: "+91", flag: "🇮🇳"),
        Country(name: "United Kingdom", code: "GB", dialCode: "+44", flag: "🇬🇧"),
        Country(name: "Canada", code: "CA", dialCode: "+1", flag: "🇨🇦"),
        Country(name: "Australia", code: "AU", dialCode: "+61", flag: "🇦🇺"),
        Country(name: "Germany", code: "DE", dialCode: "+49", flag: "🇩🇪"),
        Country(name: "France", code: "FR", dialCode: "+33", flag: "🇫🇷"),
        Country(name: "Saudi Arabia", code: "SA", dialCode: "+966", flag: "🇸🇦"),
        Country(name: "United Arab Emirates", code: "AE", dialCode: "+971", flag: "🇦🇪"),
        Country(name: "China", code: "CN", dialCode: "+86", flag: "🇨🇳"),
        Country(name: "Japan", code: "JP", dialCode: "+81", flag: "🇯🇵"),
        Country(name: "South Korea", code: "KR", dialCode: "+82", flag: "🇰🇷"),
        Country(name: "Malaysia", code: "MY", dialCode: "+60", flag: "🇲🇾"),
        Country(name: "Singapore", code: "SG", dialCode: "+65", flag: "🇸🇬"),
        Country(name: "Bangladesh", code: "BD", dialCode: "+880", flag: "🇧🇩"),
        Country(name: "Sri Lanka", code: "LK", dialCode: "+94", flag: "🇱🇰"),
        Country(name: "Nepal", code: "NP", dialCode: "+977", flag: "🇳🇵"),
        Country(name: "Thailand", code: "TH", dialCode: "+66", flag: "🇹🇭"),
        Country(name: "Indonesia", code: "ID", dialCode: "+62", flag: "🇮🇩"),
        Country(name: "Turkey", code: "TR", dialCode: "+90", flag: "🇹🇷"),
        Country(name: "Italy", code: "IT", dialCode: "+39", flag: "🇮🇹"),
        Country(name: "Spain", code: "ES", dialCode: "+34", flag: "🇪🇸"),
        Country(name: "Netherlands", code: "NL", dialCode: "+31", flag: "🇳🇱"),
        Country(name: "Switzerland", code: "CH", dialCode: "+41", flag: "🇨🇭"),
        Country(name: "Sweden", code: "SE", dialCode: "+46", flag: "🇸🇪"),
        Country(name: "Norway", code: "NO", dialCode: "+47", flag: "🇳🇴"),
        Country(name: "Denmark", code: "DK", dialCode: "+45", flag: "🇩🇰"),
        Country(name: "Brazil", code: "BR", dialCode: "+55", flag: "🇧🇷"),
        Country(name: "Mexico", code: "MX", dialCode: "+52", flag: "🇲🇽"),
        Country(name: "South Africa", code: "ZA", dialCode: "+27", flag: "🇿🇦"),
        Country(name: "New Zealand", code: "NZ", dialCode: "+64", flag: "🇳🇿"),
        Country(name: "Egypt", code: "EG", dialCode: "+20", flag: "🇪🇬"),
        Country(name: "Nigeria", code: "NG", dialCode: "+234", flag: "🇳🇬"),
        Country(name: "Kenya", code: "KE", dialCode: "+254", flag: "🇰🇪"),
        Country(name: "Philippines", code: "PH", dialCode: "+63", flag: "🇵🇭"),
        Country(name: "Vietnam", code: "VN", dialCode: "+84", flag: "🇻🇳"),
        Country(name: "Iran", code: "IR", dialCode: "+98", flag: "🇮🇷"),
        Country(name: "Iraq", code: "IQ", dialCode: "+964", flag: "🇮🇶"),
        Country(name: "Kuwait", code: "KW", dialCode: "+965", flag: "🇰🇼"),
        Country(name: "Qatar", code: "QA", dialCode: "+974", flag: "🇶🇦"),
        Country(name: "Bahrain", code: "BH", dialCode: "+973", flag: "🇧🇭"),
        Country(name: "Oman", code: "OM", dialCode: "+968", flag: "🇴🇲"),
        Country(name: "Jordan", code: "JO", dialCode: "+962", flag: "🇯🇴"),
        Country(name: "Lebanon", code: "LB", dialCode: "+961", flag: "🇱🇧"),
        Country(name: "Morocco", code: "MA", dialCode: "+212", flag: "🇲🇦"),
        Country(name: "Tunisia", code: "TN", dialCode: "+216", flag: "🇹🇳"),
        Country(name: "Algeria", code: "DZ", dialCode: "+213", flag: "🇩🇿"),
        Country(name: "Argentina", code: "AR", dialCode: "+54", flag: "🇦🇷"),
        Country(name: "Colombia", code: "CO", dialCode: "+57", flag: "🇨🇴"),
        Country(name: "Chile", code: "CL", dialCode: "+56", flag: "🇨🇱"),
        Country(name: "Peru", code: "PE", dialCode: "+51", flag: "🇵🇪"),
        Country(name: "Venezuela", code: "VE", dialCode: "+58", flag: "🇻🇪"),
        Country(name: "Poland", code: "PL", dialCode: "+48", flag: "🇵🇱"),
        Country(name: "Belgium", code: "BE", dialCode: "+32", flag: "🇧🇪"),
        Country(name: "Austria", code: "AT", dialCode: "+43", flag: "🇦🇹"),
        Country(name: "Greece", code: "GR", dialCode: "+30", flag: "🇬🇷"),
        Country(name: "Portugal", code: "PT", dialCode: "+351", flag: "🇵🇹"),
        Country(name: "Ireland", code: "IE", dialCode: "+353", flag: "🇮🇪"),
        Country(name: "Czech Republic", code: "CZ", dialCode: "+420", flag: "🇨🇿"),
        Country(name: "Hungary", code: "HU", dialCode: "+36", flag: "🇭🇺"),
        Country(name: "Romania", code: "RO", dialCode: "+40", flag: "🇷🇴"),
        Country(name: "Ukraine", code: "UA", dialCode: "+380", flag: "🇺🇦"),
        Country(name: "Russia", code: "RU", dialCode: "+7", flag: "🇷🇺"),
        Country(name: "Afghanistan", code: "AF", dialCode: "+93", flag: "🇦🇫"),
    ]

    func getCountries() -> [Country] {
        return countries
    }

    func getDefaultCountry() -> Country {
        return countries.first(where: { $0.code == "PK" }) ?? countries[0]
    }
}

// MARK: - Country Code Picker View
struct CountryCodePicker: View {
    @Binding var selectedCountryCode: String
    @Binding var isPresented: Bool

    @State private var selectedCountry: Country
    @State private var searchText = ""

    private let dataProvider = CountryDataProvider.shared

    init(selectedCountryCode: Binding<String>, isPresented: Binding<Bool>) {
        self._selectedCountryCode = selectedCountryCode
        self._isPresented = isPresented
        self._selectedCountry = State(initialValue: CountryDataProvider.shared.getDefaultCountry())
    }

    private var filteredCountries: [Country] {
        if searchText.isEmpty {
            return dataProvider.getCountries()
        } else {
            return dataProvider.getCountries().filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.code.localizedCaseInsensitiveContains(searchText) ||
                $0.dialCode.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        HStack {
            VStack(spacing: 0) {
                searchBarView

                Divider()
                    .background(Color.white.opacity(0.2))

                countryListView
            }
            .background(Color("BrandSecondary"))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.2), radius: 20, y: 5)
            .frame(width: 190)

            Spacer()
        }
//        .padding(.leading, 40)
        .onAppear {
            loadInitialSelection()
        }
    }

    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.7))

            TextField("Search country", text: $searchText)
                .foregroundColor(.white)
                .disableAutocorrection(true)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var countryListView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(filteredCountries) { country in
                    CountryRowView(country: country, isSelected: selectedCountry.id == country.id)
                        .onTapGesture {
                            selectCountry(country)
                        }
                }
            }
        }
        .frame(height: 180)
    }

    private func loadInitialSelection() {
        let countries = dataProvider.getCountries()
        if let country = countries.first(where: { $0.dialCode == selectedCountryCode }) {
            selectedCountry = country
        }
    }

    private func selectCountry(_ country: Country) {
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedCountry = country
            selectedCountryCode = country.dialCode
            // Auto-dismiss on selection
            dismissPicker()
        }
    }

    private func dismissPicker() {
        isPresented = false
    }
}

// MARK: - Country Row View
struct CountryRowView: View {
    let country: Country
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(country.flag)
                .font(.system(size: 24))

            VStack(alignment: .leading, spacing: 2) {
                Text(country.name)
                    .font(.system(size: 16))
                    .foregroundColor(.white)

                Text(country.dialCode)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color("BrandPrimary"))
                    .font(.system(size: 20))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .contentShape(Rectangle())
        .background(
            isSelected ? Color.white.opacity(0.15) : Color.clear
        )
    }
}

// MARK: - Country Code Selector Button
struct CountryCodeSelector: View {
    let countryCode: String
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 4) {
                Text(countryCode)
                    .font(.system(size: 14))
                    .foregroundColor(.white)

                Image(systemName: "chevron.down")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.2))
            )
        }
    }
}

// MARK: - Preview
#Preview {
    VStack {
        CountryCodePicker(
            selectedCountryCode: .constant("+92"),
            isPresented: .constant(true)
        )
    }
    .background(Color("AppBackground"))
}
