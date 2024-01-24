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
            ZStack {
                VStack {
                    VStack {
                        Spacer().frame(maxHeight: 90)
                        titleText
                        phoneNumberInput // Phone number textfield and flag
                        Spacer().frame(maxHeight: 500)
                    }
                    .padding()
                    .frame(maxHeight: .infinity)
                    .background(Color.black)
                    .contentShape(Rectangle())
                    .onTapGesture { isInputFocused = false }
                    .onAppear { isInputFocused = true }
                    .edgesIgnoringSafeArea(.all)
                }
                .ignoresSafeArea(.keyboard) // Prevent keyboard from pushing the View up
                .barTitle(title: "EPay", logoImage: "epaylogo") 
                
                //==============================
                // Send verification text button
                ZStack {
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
                //==============================
            }
        }
    }
    
    private var titleText: some View {
        Text("What's your phone number?")
            .font(.title2)
            .bold()
            .foregroundColor(.white)
    }

    private var phoneNumberInput: some View {
        VStack {
            // Setup textfield/flag/prefix/format/error handling from PhoneNumberKit
            PhoneNumberTextFieldWrapper(text: $viewModel.phoneNumber)
                // whenever phone number changes call validatePhoneNumber # to update errorMessage
                .onChange(of: viewModel.phoneNumber) { viewModel.validatePhoneNumber() }
                .frame(width:350, height: 30)
                .padding()
                .focused($isInputFocused) // focus on the textfield is isInputFocused true
                .keyboardType(.numberPad) // Set the type of keyboard to display (numpad bc +1)
                .frame(minHeight: 90)

            // If # is valid then font is green else it red
            Label(viewModel.errorMessage, systemImage: "")
                .foregroundColor(viewModel.isPhoneNumberValid ? .green : .red)
                .font(.subheadline)
        }
    }
}

#Preview {
    LoginView()
}
