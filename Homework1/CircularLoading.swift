//
//  CircularLoading.swift
//  Homework1
//
//  Created by Jackie Trinh on 1/23/24.
//

import SwiftUI

struct CircularLoading: View {
    @State private var isSpinning = false

    var body: some View {
        Circle()
            .trim(from: 0, to: 0.5) // Trim the circle to create a 'C' shape
            .stroke(LinearGradient(colors: [.black], startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 5, lineCap: .round))
            .frame(width: 21, height: 21)
            .rotationEffect(Angle(degrees: isSpinning ? 360 : 0))
            .onAppear {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    isSpinning = true
                }
            }
    }
}

#Preview {
    CircularLoading()
}
