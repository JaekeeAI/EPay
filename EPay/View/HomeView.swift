//
//  HomeView.swift
//  Homework1
//
//  Created by Jackie Trinh on 1/22/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userModel: UserModel
    @State private var navigateToSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        NavigationLink {
                            SettingView()
                        } label: {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.white)
                        }
                    }
                }
                .foregroundColor(.white)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Your Accounts")
                            .font(.headline)
                            .foregroundColor(Color.white)
                    }
                }
            }
        }
    }
}


#Preview {
    HomeView()
}

/*
 struct HomeView: View {
     @State private var navigateToSettings = false

     var body: some View {
         NavigationStack {
             VStack {
                 CustomHeader(
                     middleText: "Your Accounts",
                     rightSystemImage: "person.crop.circle",
                     rightAction: { navigateToSettings = true }
                 )
                 Spacer()
             }
             .background(Color.black)
             .navigationDestination(isPresented: $navigateToSettings) { SettingView()}
         .navigationBarBackButtonHidden(true)
         }
     }
 }
 
 */
