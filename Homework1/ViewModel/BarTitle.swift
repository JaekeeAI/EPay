//
//  BarTitle.swift
//  Homework1
//
//  Created by Jackie Trinh on 1/23/24.
//

import SwiftUI

struct BarTitle: ViewModifier {
    var title: String
    var logoImage: String

    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(logoImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 21, height: 21)
                        Text(title)
                            .bold()
                            .foregroundColor(.white)
                            .font(.title)
                    }
                }
            }
    }
}

extension View {
    func barTitle(title: String, logoImage: String) -> some View {
        self.modifier(BarTitle(title: title, logoImage: logoImage))
    }
}

#Preview {
    NavigationView {
        ZStack {
            // Background color
            Color.black.edgesIgnoringSafeArea(.all)

            // A simple text view for demonstration.
            Text("Content View")
                // Apply the custom navigation bar modifier to the Text view.
                .barTitle(title: "EPay", logoImage: "epaylogo")
        }
        
    }
}


