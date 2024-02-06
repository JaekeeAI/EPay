//
//  RootView.swift
//  EPay
//
//  Created by Jackie Trinh on 1/30/24.
//

import SwiftUI

struct RootView: View {
    
    @StateObject private var userModel = UserModel()

    var body: some View { // The main part of RootView that defines what it looks like.
        
        Group { // Grouping multiple views together.
            if userModel.authToken == nil { // Checking if there is no saved login token.
                LoginView() // If there's no token, show the LoginView, where users can log in.
                    .environmentObject(userModel) 
            } else if userModel.currentUser == nil { // If there's a token but no user data...
                LoadingView() // Show the LoadingView, which means the app is getting the user's data.
                    .environmentObject(userModel) // Giving LoadingView access to 'userModel' to use its data.
            } else { // If there's a token and user data...
                HomeView() // Show the HomeView, which is the main screen after logging in.
                    .environmentObject(userModel) // Giving HomeView access to 'userModel' to use its data.
            }
        }
        .onAppear { // When RootView appears on the screen
            print("this is root view")
            Task { // Start a new task (kind of like doing a separate little job).
                if let authToken = userModel.authToken, userModel.currentUser == nil { // If there's a token but no user data
                    await userModel.loadUserData(authToken: authToken) // Ask 'userModel' to load the user data.
                }
            }
        }
        
        
    }
}


#Preview {
    RootView()
}

/*
 struct RootView: View {
     @StateObject private var userModel = UserModel()

     var body: some View { // The main part of RootView that defines what it looks like.
         Group { // Grouping multiple views together.
             if userModel.authToken == nil { // Checking if there is no saved login token.
                 LoginView() // If there's no token, show the LoginView, where users can log in.
                     .environmentObject(userModel)
             } else if userModel.currentUser == nil { // If there's a token but no user data...
                 LoadingView() // Show the LoadingView, which means the app is getting the user's data.
                     .environmentObject(userModel) // Giving LoadingView access to 'userModel' to use its data.
             } else { // If there's a token and user data...
                 HomeView() // Show the HomeView, which is the main screen after logging in.
                     .environmentObject(userModel) // Giving HomeView access to 'userModel' to use its data.
             }
         }
         .onAppear { // When RootView appears on the screen...
             Task { // Start a new task (kind of like doing a separate little job).
                 if let authToken = userModel.authToken, userModel.currentUser == nil { // If there's a token but no user data
                     await userModel.loadUserData(authToken: authToken) // Ask 'userModel' to load the user data.
                 }
             }
         }
     }
 }
 */
