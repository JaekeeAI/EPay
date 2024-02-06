//
//  BarTitle.swift
//  Homework1
//
//  Created by Jackie Trinh on 1/23/24.
//

import SwiftUI

struct BarTitle: ViewModifier {
    
    // Properties to hold title and logo image name
    var title: String
    var logoImage: String
    
    func body(content: Content) -> some View {
        content
            .toolbar { // Configure toolbar items for navigationBar
                ToolbarItem(placement: .principal) { // principal put it in middle
                    HStack {
                        Image(logoImage)
                            .resizable() // allow image to be resized
                            .scaledToFill() // scale the image to it frame
                            .frame(width: 21, height: 21)
                        Text(title)
                            .font(.title).bold()
                            .foregroundColor(.white)
                    }
                }
            }
    }
}

// Extends the View protocol to include the barTitle method for easy modification of any view.
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


