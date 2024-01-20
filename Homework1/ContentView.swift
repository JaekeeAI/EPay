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
        ZStack {
            ZStack {
                VStack {
                    logoAndTitle // Display Logo and Title
                    Spacer().frame(maxHeight: 30)
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
            
            ZStack {
                submitButton // Send verification text button
            }
            .frame(maxHeight: .infinity)
        }
    }

    private var logoAndTitle: some View {
        VStack {
            HStack {
                Image("epaylogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                Text("EPay")
                    .bold()
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
            Spacer().frame(maxHeight: 30)
            Text("What's your phone number?")
                .bold()
                .foregroundColor(.white)
                .font(.system(size: 21))
        }
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
                .keyboardType(.numberPad) // Set the type of keyboard to display

            // If # is valid then font is green else it red
            Label(viewModel.errorMessage, systemImage: "")
                        .foregroundColor(viewModel.isPhoneNumberValid ? .green : .red)
        }
    }

    private var submitButton: some View {
        GeometryReader { geometry in // Grab the size of the parent view
            Button {
                isInputFocused = false
            } label: {
                Text("Send Verification Text")
                    .fontWeight(.semibold)
                    .frame(width: 360, height: 50)
                    .foregroundColor(.black)
                    // Make the button lightup if # valid to signal button is clickable
                    .background(viewModel.isPhoneNumberValid ? Color.white : Color(.lightGray))
                    .cornerRadius(12) // Trim the corner of Button
            }
            .disabled(!viewModel.isPhoneNumberValid) // Disable the button if # is invalid
            .position(x: geometry.size.width / 2, y: geometry.size.height - 50) // Position at the bottom
        }
    }
}


#Preview {
    LoginView()
}
