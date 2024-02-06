//
//  CustomHeader.swift
//  EPay
//
//  Created by Jackie Trinh on 1/30/24.
//

import SwiftUI

struct CustomHeader: View {
    let leftText: String?
    let middleText: String
    let rightText: String?
    let leftSystemImage: String?
    let rightSystemImage: String?
    var leftAction: () -> Void
    var rightAction: () -> Void

    init(
        leftText: String? = nil,
        middleText: String,
        rightText: String? = nil,
        leftSystemImage: String? = nil,
        rightSystemImage: String? = nil,
        leftAction: @escaping () -> Void = {},
        rightAction: @escaping () -> Void = {}
    ) {
        self.leftText = leftText
        self.middleText = middleText
        self.rightText = rightText
        self.leftSystemImage = leftSystemImage
        self.rightSystemImage = rightSystemImage
        self.leftAction = leftAction
        self.rightAction = rightAction
    }

    var body: some View {
        ZStack {
            // Left Component
            HStack {
                if let leftText = leftText {
                    Button(action: leftAction) {
                        Text(leftText)
                    }
                } else if let leftSystemImage = leftSystemImage {
                    Button(action: leftAction) {
                        Image(systemName: leftSystemImage)
                    }
                }
                Spacer()
            }

            // Middle Component
            HStack {
                Spacer()
                Text(middleText)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }

            // Right Component
            HStack {
                Spacer()
                if let rightText = rightText {
                    Button(action: rightAction) {
                        Text(rightText)
                    }
                } else if let rightSystemImage = rightSystemImage {
                    Button(action: rightAction) {
                        Image(systemName: rightSystemImage)
                    }
                }
            }
        }
        .foregroundColor(.white)
        .padding([.leading, .trailing], 20)
    }
}

#Preview {
    VStack {
        CustomHeader(
            middleText: "Settings",
            leftSystemImage: "chevron.backward"
        )
        Spacer() // Pushes the header to the top
    }
    .background(Color.black)
}

