//
//  VerificationView.swift
//  Homework1
//
//  Created by Jackie Trinh on 1/20/24.
//

import SwiftUI

struct NoTouch: ViewModifier {
    func body(content: Content) -> some View {
        content
            .allowsHitTesting(false) // Disables touch interactions
    }
}

struct VerificationView: View {
    @State private var otpFields: [String] = Array(repeating: "", count: 6)
    @State private var isVerifying = false // use to check if it
    @State private var showHomeView = false
    @FocusState private var focusedField: Int?
    var phoneNumber: String
    @ObservedObject var viewModel: LoginViewModel
    @State private var errorMessage: String? = nil
    @State private var isVerificationSuccessful: Bool = false // Use for border
    @State private var isLoading = false  // Use for CircularLoading animation

    var body: some View {
        NavigationStack {
            VStack {
                titleText
                otpTextFields
                verificationStatusText
                Spacer()
                resendButton
            }
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .navigationDestination(isPresented: $showHomeView) { HomeView() }
            .barTitle(title: "EPay", logoImage: "epaylogo")
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
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .focused($focusedField, equals: index)
                    .onChange(of: otpFields[index]) { handleOTPChange(at: index) }
                    .onAppear { if index == 0 && focusedField == nil { focusedField = 0 } }
                    .modifier(NoTouch()) // Disable interaction with textfield
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
            label: "Resend Code",
            action: {
                resetOTPFields()
                isLoading = true  // Start loading
                Task {
                    await viewModel.sendVerificationToken()
                    isLoading = false  // Stop loading
                }
                focusFirstTextField() // after reset set focus on 1st textfield
            },
            isEnabled: !isVerifying, // if not verifying the OTP then enable button
            isLoading: isLoading  // if it loading then button is disable
        )
        .frame(maxHeight: .infinity)
    }

    private func handleOTPChange(at index: Int) {
        let value = otpFields[index]
        
        errorMessage = nil // Reset the error message when the user starts editing
        
        if value.count == 2 { // if there more than 2 value in same textfield
            let digits = Array(value)
            otpFields[index] = String(digits[0]) // Keep the leftmost digit in the current field

            if index < otpFields.count - 1 {
                otpFields[index + 1] = String(digits[1]) // Move the rightmost digit to the next field
                focusedField = index + 1
            }
        } else if value.isEmpty && index > 0 { // check if textfield is empty and it not first cell
            focusedField = index - 1
        }
        
        // check if users finish typing the OTP code and verify if it correct
        if otpFields.allSatisfy({ $0.count == 1 }) && !isVerifying {
            let code = otpFields.joined() // combine all the textfield
            isVerifying = true
            isLoading = true
            viewModel.verifyCode(phoneNumber: phoneNumber, code: code) { success, errorString in
                DispatchQueue.main.async {
                    isLoading = false
                    isVerifying = false
                    if success {
                        isVerificationSuccessful = true
                        errorMessage = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // one second delay before going to home screen
                            showHomeView = true
                        }
                    } else {
                        errorMessage = errorString
                        isVerificationSuccessful = false
                    }
                }
            }
        }
    }
    
    private func resetOTPFields() { //Reset all fields to empty
        otpFields = Array(repeating: "", count: 6) // create array with 6 slots all empty
    }
    
    private func focusFirstTextField() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.focusedField = 0
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
}

#Preview {
    VerificationView(phoneNumber: "123-456-7890", viewModel: LoginViewModel())
}


