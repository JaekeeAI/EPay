//
//  PhoneNumberTextFieldWrapper.swift
//  Homework1
//
//  Created by Jackie Trinh on 1/20/24.
//

import Foundation
import SwiftUI
import PhoneNumberKit

// Set default region in textfield to be US
class DefaultPhoneNumberTextField: PhoneNumberTextField {
    override var defaultRegion: String {
        get {
            return "US"
        }
        set { } // exists for backward compatibility
    }
}

struct PhoneNumberTextFieldWrapper: UIViewRepresentable {
    @Binding var text: String

    // make the textfield view and enable it's features
    func makeUIView(context: Context) -> DefaultPhoneNumberTextField {
        let textField = DefaultPhoneNumberTextField()
        textField.withFlag = true
        textField.withExamplePlaceholder = true
        textField.withPrefix = true
        textField.delegate = context.coordinator
        
        // Customizing fonand color
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        return textField
    }
    
    // Update the latest thing written
    func updateUIView(_ uiView: DefaultPhoneNumberTextField, context: Context) {
        uiView.text = text
    }
    
    // Coordinate UI communication between Ulkit and SwiftUI
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Bridge communication between textfield and the SwiftUI
    // Listen to textfield changes
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: PhoneNumberTextFieldWrapper

        // Initialize the helper that know who parent is
        init(_ parent: PhoneNumberTextFieldWrapper) {
            self.parent = parent
        }
        
        // when textfield say something, helper listen
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? "" // helper telling parent what textfield said
        }
    }
}
