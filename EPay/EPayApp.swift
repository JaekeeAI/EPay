//
//  Homework1App.swift
//  Homework1
//
//  Created by Jackie Trinh on 1/15/24.
//

import SwiftUI

@main
struct EPayApp: App {
    @StateObject private var userModel = UserModel()
    
    init() {
        Api.shared.appId = "QSQEo5xSmENL" // Set the appId for API
    }
    
    var body: some Scene {
        WindowGroup {
            if userModel.authToken == nil {
                LoginView().environmentObject(userModel)
            } else {
                // LoadingView is not necessary here unless you need to load data every time authToken is set
                HomeView().environmentObject(userModel)
            }
        }
    }
}

