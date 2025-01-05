//
//  LoginViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 05.01.25.
//

import Foundation
import FirebaseAuth

protocol LoginErrorDelegate: AnyObject {
  func didErrorDuringLogin()
}

final class LoginViewModel {
  weak var loginErrorDelegate: LoginErrorDelegate?
  private let authManager: SigninProtocol
  var loginErrorMsg: String?
  
  init(authManager: SigninProtocol = AuthManager()) {
    self.authManager = authManager
  }
  
  func checkUser(email: String, password: String) {
    guard isValidEmail(email) else {
      loginErrorMsg = "Enter correct email format"
      loginErrorDelegate?.didErrorDuringLogin()
      return
    }
    
    guard password.count > 7 else {
      loginErrorMsg = "The password must be at least 8 characters long."
      loginErrorDelegate?.didErrorDuringLogin()
      return
    }
    
    guard isValidPassword(password) else {
      loginErrorMsg = "The password must contain at least one uppercase letter, one number, and one special character."
      loginErrorDelegate?.didErrorDuringLogin()
      return
    }
    
    signInUser(email: email, password: password)
  }
  
  private func signInUser(email: String, password: String) {
    Task {
      do {
        let response = try await authManager.signInUser(with: email, and: password)
        print(response.user)
      } catch let error as NSError {
        if error.domain == AuthErrorDomain {
          switch error.code {
          case AuthErrorCode.invalidCredential.rawValue:
            print("Invalid credentials. Please check your email and password.")
            await MainActor.run {
              loginErrorMsg = "Invalid credentials. Please check your email and password."
              loginErrorDelegate?.didErrorDuringLogin()
            }
          default:
            print("Error: \(error.localizedDescription)")
            await MainActor.run {
              loginErrorMsg = "Error: \(error.localizedDescription)"
              loginErrorDelegate?.didErrorDuringLogin()
            }
          }
        }
      }
    }
  }
  
}



