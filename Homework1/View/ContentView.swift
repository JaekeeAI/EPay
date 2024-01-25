//
//  ContentView.swift
//  Homework1
//
//  Created by Jackie Trinh on 1/15/24.
//

import SwiftUI
import PhoneNumberKit

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @FocusState private var isInputFocused: Bool

    var body: some View {
        
        NavigationStack {
            VStack {
                titleText        // What's your phone number?
                phoneNumberInput // Phone number textfield and flag
                Spacer()
                sendCodeButton
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .contentShape(Rectangle())
            .onTapGesture { isInputFocused = false }
            .onAppear { isInputFocused = true }
            .barTitle(title: "EPay", logoImage: "epaylogo")
        }
    }
    
    private var sendCodeButton: some View {
        ZStack { // Send Verification Button
            BottomButton(
                label: "Send Verification Text",
                action: {
                    isInputFocused = false
                    viewModel.GoToVerificationView = true
                    Task { await viewModel.sendVerificationToken() }
                },
                isEnabled: viewModel.isPhoneNumberValid // if # valid enable button
            )
        }
        .frame(maxHeight: .infinity)
        // Redirect to VerificationView
        .navigationDestination(isPresented: $viewModel.GoToVerificationView) {
            VerificationView(phoneNumber: viewModel.phoneNumber, viewModel: viewModel)
        }
    }
    
    private var titleText: some View {
        Text("What's your phone number?")
            .font(.title2).bold()
            .frame(minHeight: 90)
            .foregroundColor(.white)
    }

    private var phoneNumberInput: some View {
        VStack {
            // Setup textfield/flag/prefix/format/error handling from PhoneNumberKit
            PhoneNumberTextFieldWrapper(text: $viewModel.phoneNumber)
                // whenever phone number changes call validatePhoneNumber # to update errorMessage
                .onChange(of: viewModel.phoneNumber) { viewModel.validatePhoneNumber() }
                .frame(width:350, height: 30)
                .focused($isInputFocused) // focus on the textfield is isInputFocused true
                .keyboardType(.numberPad) // Set the type of keyboard to display (numpad bc +1)

            // If # is valid then font is green else it red
            Label(viewModel.errorMessage, systemImage: "")
                .foregroundColor(viewModel.isPhoneNumberValid ? .green : .red)
                .font(.subheadline)
                .frame(minHeight: 90)
        }
    }
}

#Preview {
    LoginView()
}
