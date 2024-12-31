//
//  SignupViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 26.12.24.
//

import SwiftUI

@MainActor
final class SignupViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    
    var authManager: SignupProtocol

    init(authManager: SignupProtocol = AuthManager(), email: String = "", password: String = "") {
        self.authManager = authManager
        self.email = email
        self.password = password
    }
    
    func signUpUser() {
        Task {
            do {
              try await authManager.createUser(email: email, password: password)
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}









//
//  SignupViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 26.12.24.
//

import SwiftUI

//final class SignupViewModel: ObservableObject, SignupProtocol {
//  @Published var email = ""
//  @Published var password = ""
//
//  var authManager: SignupProtocol
//
//  init(authManager: SignupProtocol = AuthManager(), email: String = "", password: String = "") {
//    self.authManager = authManager
//    self.email = email
//    self.password = password
//  }
//
//  func createUser(email: String, password: String) async throws {
//    try await authManager.createUser(email: email, password: password)
//  }
//
//  func signUpUser() {
//    Task {
//      do {
//        try await createUser(email: email, password: password)
//      } catch {
//        // Notify UI about the error
//        print("Error during sign-up: \(error.localizedDescription)")
//      }
//    }
//  }
//}

