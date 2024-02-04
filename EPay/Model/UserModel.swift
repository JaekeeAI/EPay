//
//  UserModel.swift
//  EPay
//
//  Created by Jackie Trinh on 1/29/24.
//

import Foundation

class UserModel: ObservableObject {
    @Published var currentUser: User? 
    @Published var apiError: ApiError?
    @Published var authToken: String?
    

    init() {
        self.authToken = UserDefaults.standard.string(forKey: "authToken")
        if let authToken = self.authToken {
            Task {
                await loadUserData(authToken: authToken)
            }
        }
    }

    func setAuthToken(authToken: String) {
        self.authToken = authToken // Update the authToken
        UserDefaults.standard.setValue(authToken, forKey: "authToken") // Persist authToken
        Task {
            await loadUserData(authToken: authToken) // load user data right after login
        }
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        authToken = nil
        currentUser = nil
    }


    // Function to load user data using the stored authentication token
    func loadUserData(authToken: String) async {
        do { // Use the authToken to fetch Users
            let userResponse = try await Api.shared.user(authToken: authToken)
            DispatchQueue.main.async {
                self.currentUser = userResponse.user
            }
        } catch let error as ApiError {
            DispatchQueue.main.async {
                self.apiError = error
                print("API Error: \(error)")
            }
        } catch {
            DispatchQueue.main.async {
                self.apiError = ApiError.unknownError
                print("Unknown error occurred")
            }
        }
    }

    // Function to update the username
    func updateUsername(_ newName: String) async {
        guard let authToken = self.authToken else { return }
        do {
            _ = try await Api.shared.setUserName(authToken: authToken, name: newName)
            await loadUserData(authToken: authToken)
        } catch {
            // Handle error
        }
    }
}




