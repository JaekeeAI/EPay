//
//  LoginViewModel.swift
//  Homework1
//
//  Created by Jackie Trinh on 1/20/24.
//

import Foundation
import SwiftUI
import PhoneNumberKit

// ViewModel class for handling login logic and state management
class LoginViewModel: ObservableObject {
    @Published var phoneNumber = ""
    @Published var errorMessage = ""
    @Published var isPhoneNumberValid = false
    private let phoneNumberKit = PhoneNumberKit()

    // Method to validate phone number
    func validatePhoneNumber() {
        do {
            // Attenpt to parse # and check if it valid
            let _ = try phoneNumberKit.parse(phoneNumber)
            errorMessage = "Phone number is valid"
            isPhoneNumberValid = true
        } catch {
            errorMessage = "Enter a valid phone number"
            isPhoneNumberValid = false
        }
    }
}
