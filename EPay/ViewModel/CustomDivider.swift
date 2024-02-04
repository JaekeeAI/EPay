//
//  CustomDivider.swift
//  EPay
//
//  Created by Jackie Trinh on 1/30/24.
//

import SwiftUI

struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 1) // Height acts as the thickness of the divider
            .foregroundColor(Color(.darkGray)) // Divider color
            .padding([.leading, .trailing], 20) // Padding on left and right
    }
}


#Preview {
    CustomDivider()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
}
