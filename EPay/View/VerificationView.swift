//
//  VerificationView.swift
//  Homework1
//
//  Created by Jackie Trinh on 1/20/24.
//

import SwiftUI

struct VerificationView: View {
    @State private var otpFields: [String] = Array(repeating: "", count: 6)
    @State private var showHomeView = false
    @FocusState private var focusedField: Int?
    @State private var isVerifying = false // use to check if it currently verifying OTP Code
    var phoneNumber: String
    @ObservedObject var viewModel: LoginViewModel
    @State private var errorMessage: String? = nil
    @State private var isVerificationSuccessful: Bool = false // Use for border
    @State private var isLoading = false  // Use for CircularLoading animation
    @EnvironmentObject var userModel: UserModel
    
    @State private var cooldownTime: Int = 0

    var body: some View {
        NavigationStack {
            VStack {
                titleText
                otpTextFields
                verificationStatusText
                resendButton
            }
            .background(Color.black)
            .navigationDestination(isPresented: $showHomeView) {
                HomeView()
            }
            .barTitle(title: "EPay", logoImage: "epaylogo")
            .onAppear{
                print("this is verification view")
                isLoading = true // start loading
                Task {
                    await viewModel.sendVerificationToken()
                    isLoading = false  // Stop loading
                }
            }
        }
    }

    private var titleText: some View {
        Text("Verify your number")
            .font(.title2).bold()
            .frame(minHeight: 90)
            .foregroundColor(.white)
    }

    private var otpTextFields: some View {
        HStack { // Generate 6 textfields
            ForEach(0..<6, id: \.self) { index in
                TextField("", text: $otpFields[index])
                    .frame(width: 40, height: 40)
                    .multilineTextAlignment(.center)
                    .keyboardType(.phonePad) // make sure users enter number only
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(getTextFieldColor(for: index))
                    .cornerRadius(5)
                    .focused($focusedField, equals: index)
                    // when users make change to textfield run handleOTPChange
                    .onChange(of: otpFields[index]) { handleOTPChange(at: index) }
                    // focus on first textfield at start
                    .onAppear { if index == 0 && focusedField == nil { focusedField = 0 } }
                    .allowsHitTesting(false) // Disable interaction with textfield
                    .accentColor(.clear) // make text cursor clear
                    .overlay( // change border color when not empty
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(
                                getBorderColor(for: index),
                                lineWidth: 1
                            )
                    )
            }
        }
    }

    private var verificationStatusText: some View {
        Group {
            if !isLoading { // if not loading then show messagee
                if isVerificationSuccessful {
                    Label("Verification Successful", systemImage: "checkmark.circle")
                        .foregroundColor(.green)
                } else if let errorMessage = errorMessage {
                    Label(errorMessage, systemImage: "xmark.octagon")
                        .foregroundColor(.red)
                } else {
                    Text("Verification code sent to \(phoneNumber)")
                        .foregroundStyle(Color(.lightGray))
                }
            }
        }
        .frame(minHeight: 90)
        .font(.subheadline)
    }

    private var resendButton: some View {
        BottomButton(
            label: cooldownTime > 0 ? "Resend in \(cooldownTime)s" : "Resend Code",
            action: {
                startCooldown()
                resetOTPFields()
                isLoading = true  // Start loading
                Task {
                    await viewModel.sendVerificationToken()
                    isLoading = false  // Stop loading
                }
                focusFirstTextField() // after reset set focus on 1st textfield
            },
            isEnabled: cooldownTime == 0, // CD = 0 true then enable else disable it
            isLoading: isLoading  // if it loading then button is disable
        )
    }
    
    private func startCooldown() {
        cooldownTime = 30 // Start from 30 seconds
        
        // start the timer
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if cooldownTime > 0 {
                cooldownTime -= 1
            } else {
                timer.invalidate() // stop the timer
            }
        }
    }

    private func handleOTPChange(at index: Int) {
        let value = otpFields[index]
        errorMessage = nil // Clear error message when editing begins

        switch value.count {
        case 6: // if there 6 digits in a textfield
            handleOTPAutofill(value)
        case 2: // if there 2 digits in a textfield
            handleOTPInput(at: index)
        default:
            handleBackSpace(at: index)
        }
        
        // check if every textfield is filled
        verifyCodeIfComplete()
    }

    private func handleOTPAutofill(_ value: String) {
        let digits = Array(value) // split each code into an array
        // put each digit in array into each individual OTP fields
        for (i, digit) in digits.enumerated() where i < otpFields.count {
            otpFields[i] = String(digit)
        }
        focusedField = otpFields.count - 1 // Focus on the last field
    }

    private func handleOTPInput(at index: Int) {
        // break the input into individual character and store it in an array
        let digits = Array(otpFields[index])
        
        // put the rightmost digit in current textfield
        otpFields[index] = String(digits[0])
        
        // put the leftmost digit in the next textfield
        if index < otpFields.count - 1 {
            otpFields[index + 1] = String(digits[1])
            focusedField = index + 1
        }
    }

    private func handleBackSpace(at index: Int) {
        // move focus back to previous textfield 
        if otpFields[index].isEmpty && index > 0 {
            focusedField = index - 1
        }
    }
    
    private func resetOTPFields() { //Reset all fields to empty
        otpFields = Array(repeating: "", count: 6) // create array with 6 slots all empty
    }
    
    private func focusFirstTextField() { // delay by 0.1 second before reset focus to 1st textfield
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.focusedField = 0
        }
    }

    private func verifyCodeIfComplete() {
        // check if all textfield is filled
        let isOTPComplete = otpFields.allSatisfy { $0.count == 1 }
        // if all textfield is not filled or it currently verifying code then exit this function
        guard isOTPComplete && !isVerifying else { return }

        let code = otpFields.joined()
        isVerifying = true
        isLoading = true
        viewModel.verifyCode(phoneNumber: phoneNumber, code: code) { success, errorString, authToken in
            DispatchQueue.main.async {
                isLoading = false
                isVerifying = false
                handleVerificationResult(success: success, errorString: errorString, authToken: authToken)
            }
        }

    }

    private func handleVerificationResult(success: Bool, errorString: String?, authToken: String?) {
        if success {
            if let authToken = authToken {
                isVerificationSuccessful = true
                errorMessage = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showHomeView = true
                    self.userModel.setAuthToken(authToken: authToken)
                }
            } else {
                errorMessage = "Failed to retrieve authentication token."
                isVerificationSuccessful = false
            }
        } else {
            errorMessage = errorString
            isVerificationSuccessful = false
        }
    }

    
    // This function determines the color of the border based on various conditions
    private func getBorderColor(for index: Int) -> Color {
        if isVerificationSuccessful {
            return Color.green // Green border when verification is successful
        } else if let errorMessage = errorMessage, errorMessage == "Incorrect Code. Try Again" {
            return Color.red // Red border for incorrect code
        } else { // Default border color is black but if not empty then gray
            return otpFields[index].isEmpty ? Color.black : Color.gray
        }
    }
    
    private func getTextFieldColor(for index: Int) -> Color { // for mean function return a color
        if isVerificationSuccessful {
            return Color.green // Green text when verification is successful
        } else if let errorMessage = errorMessage, !errorMessage.isEmpty {
            return Color.red // Red text for error or failed verification
        } else {
            return Color.white // Default color
        }
    }
}

#Preview {
    VerificationView(phoneNumber: "123-456-7890", viewModel: LoginViewModel())
}


