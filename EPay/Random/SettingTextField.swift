/*
//
//  SettingTextField.swift
//  EPay
//
//  Created by Jackie Trinh on 1/30/24.
//
import SwiftUI

struct SettingTextField: View {
    var title: String
    var placeholder: String
    @State private var text: String = ""

    var body: some View {
        HStack {
            Text(title)
                .padding(.leading, 20)
                .frame(width: 120, height: 30, alignment: .leading)
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color(.darkGray)) // Placeholder color
                        .padding(.leading, 4)
                }
                TextField("", text: $text)
                    .foregroundColor(.white) // Text color
            }
        }
        .frame(height: 36)
    }
}



#Preview {
    SettingTextField(title: "username", placeholder: "Shrey")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .foregroundColor(.white)
}

*/
