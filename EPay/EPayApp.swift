//
//  Homework1App.swift
//  Homework1
//
//  Created by Jackie Trinh on 1/15/24.
//

import SwiftUI

@main
struct EPayApp: App {
    init() {
        Api.shared.appId = "QSQEo5xSmENL" // Set the appId for API
    }

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
