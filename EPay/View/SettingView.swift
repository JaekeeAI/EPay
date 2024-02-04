//
//  SettingView.swift
//  EPay
//
//  Created by Jackie Trinh on 1/29/24.
//
import SwiftUI

struct SettingView: View {
    @EnvironmentObject var userModel: UserModel
    //@Environment(\.dismiss) var dismiss
    @State private var username: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    CustomDivider()
                    usernameField
                    CustomDivider()
                    phoneNumberField
                    CustomDivider()
                    bottomButton
                }
                .foregroundColor(.white)
                .onAppear{print("this is setting view")}
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Settings")
                            .font(.headline)
                            .foregroundColor(Color.white)
                    }
                }
            }
        }
    }
    
    private var usernameField: some View {
        // Username Field
        HStack {
            Text("Username")
                .padding(.leading, 20)
                .frame(width: 120, height: 30, alignment: .leading)
            
            ZStack(alignment: .leading) {
                if username.isEmpty {
                    Text("Shrey")
                        .foregroundColor(Color(.darkGray)) // Placeholder color
                }
                TextField("", text: $username)
                    .foregroundColor(.white) // Text color
            }
        }
        .frame(height: 36)
    }
    
    private var phoneNumberField: some View {
        HStack {
            Text("Phone #")
                .padding(.leading, 20)
                .frame(width: 120, height: 30, alignment: .leading)
            
            ZStack(alignment: .leading) {
                Text(userModel.currentUser?.e164PhoneNumber ?? "N/A")
            }
            
            Spacer()
        }
        .frame(height: 36)
    }
    
    private var bottomButton: some View {
        BottomButton(
            label: "Log out",
            action: {
                userModel.logout()
                print("button in settingview is pressed")
            },
            isEnabled: true
        )
    }
}

#Preview {
    SettingView().environmentObject(UserModel())
}
