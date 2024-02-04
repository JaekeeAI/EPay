//
//  LoadingView.swift
//  EPay
//
//  Created by Jackie Trinh on 1/29/24.
//

import SwiftUI

struct LoadingView: View {
    @EnvironmentObject var userModel: UserModel
    
    var body: some View {
        VStack{
            CircularLoading(color: .white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .onAppear() {
            print("this is loading view")
        }
    }
}

#Preview {
    LoadingView()
}
