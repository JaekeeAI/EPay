//
//  Homework1App.swift
//  Homework1
//
//  Created by Jackie Trinh on 1/15/24.
//

import SwiftUI

@main
struct EPayApp: App {
    
    // 
    @StateObject private var userModel = UserModel()
    
    init() {
        Api.shared.appId = "QSQEo5xSmENL" // Set the appId for API
    }
    
    var body: some Scene {
        WindowGroup {
            if userModel.authToken != nil && userModel.currentUser == nil {
                LoadingView().environmentObject(userModel)
            } else if userModel.currentUser != nil {
                HomeView().environmentObject(userModel)
            } else {
                LoginView().environmentObject(userModel)
            }
        }
    }}

