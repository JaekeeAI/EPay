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
    @Published var GoToVerificationView = false
    private let phoneNumberKit = PhoneNumberKit()

    // Method to check if phone number is valid
    func validatePhoneNumber() {
        do {
            // Attenpt to parse # and check if it valid
            let phoneNumberObject = try phoneNumberKit.parse(phoneNumber)
            phoneNumber = phoneNumberKit.format(phoneNumberObject, toType: .e164)
            errorMessage = "Phone number is valid"
            isPhoneNumberValid = true
        } catch {
            errorMessage = "Enter a valid phone number"
            isPhoneNumberValid = false
        }
    }
    
    // Method to send verification token
    func sendVerificationToken() async {
        do {
            let _ = try await Api.shared.sendVerificationToken(e164PhoneNumber: phoneNumber)

            DispatchQueue.main.async {
                self.GoToVerificationView = true
            }
        } catch let apiError as ApiError {
            DispatchQueue.main.async {
                self.errorMessage = apiError.message
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to send verification token"
            }
        }
    }
    
    // Add in LoginViewModel
    func verifyCode(phoneNumber: String, code: String, completion: @escaping (Bool, String?) -> Void) {
        Task {
            do {
                let _ = try await Api.shared.checkVerificationToken(e164PhoneNumber: phoneNumber, code: code)
                completion(true, nil)
            } catch let error as ApiError {
                let message = error.message.contains("Incorrect verification code") ? "Incorrect Code. Try Again" : error.message
                completion(false, message)
            } catch {
                completion(false, "An error occurred.")
            }
        }
    }
}
