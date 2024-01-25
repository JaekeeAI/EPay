//
//  BottomButton.swift
//  Homework1
//
//  Created by Jackie Trinh on 1/23/24.
//

import SwiftUI

struct BottomButton: View {
    let label: String
    var action: () -> Void
    var isEnabled: Bool = true
    var isLoading: Bool = false

    var body: some View {
        GeometryReader { geometry in // grab the screen size
            Button(action: action) {
                if isLoading {
                    CircularLoading() // Use your loading view
                } else {
                    Text(label)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 50)
                }
            }
            .disabled(!isEnabled || isLoading)
            .frame(width: 360, height: 50)
            .foregroundColor(isLoading ? .clear : .black)
            .background(isEnabled ? Color.white : Color(.lightGray))
            .cornerRadius(12)
            // adjust the position of button to be at bottom of the screen
            .position(x: geometry.size.width / 2, y: geometry.size.height - 50)
        }
    }
}

 #Preview {
     VStack {
         BottomButton(label: "BottomButton", action: {print("")})
     }
     .background(Color.black)
 }
 
