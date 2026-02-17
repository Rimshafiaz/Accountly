//
//  DOBDatePicker.swift
//  Accountly
//
//  Created by Rimsha on 13/02/2026.
//

import SwiftUI

struct DOBDatePicker: View {
    @Binding var birthDay: String
    @Binding var birthMonth: String
    @Binding var birthYear: String
    @Binding var isPresented: Bool

    @State private var selectedDate = Date()

    private let startYear = 1925
    private let endYear = 2006

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("BrandSecondary"))
                    .frame(maxHeight: 120)

                DatePicker("", selection: $selectedDate, in: dateRange, displayedComponents: [.date])
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .colorScheme(.dark)
                    .environment(\.colorScheme, .dark)
                    .frame(maxHeight: 120)
            }

            HStack {
                Spacer()

                Button("Done") {
                    updateDateFields()
                    isPresented = false
                }
                .font(.system(size: 14))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color("BrandSecondary"))
                .cornerRadius(12)

                Spacer()
            }
        }
        .padding(.horizontal, 40)
    }

    private var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: startYear, month: 1, day: 1)) ?? Date()
        let endDate = calendar.date(from: DateComponents(year: endYear, month: 12, day: 31)) ?? Date()
        return startDate...endDate
    }

    private func updateDateFields() {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: selectedDate)
        birthDay = String(format: "%02d", components.day ?? 1)
        birthMonth = String(format: "%02d", components.month ?? 1)
        birthYear = String(format: "%04d", components.year ?? 2000)
    }
}

#Preview {
    DOBDatePicker(
        birthDay: .constant("15"),
        birthMonth: .constant("03"),
        birthYear: .constant("1998"),
        isPresented: .constant(true)
    )
}
