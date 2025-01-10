//
//  LoginViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 05.01.25.
//

import Foundation
import FirebaseAuth
import FirebaseCore

protocol LoginErrorDelegate: AnyObject {
  func didErrorDuringLogin()
}

protocol LoginLoadingDelegate: AnyObject {
  func didLoginLoaded()
}

final class LoginViewModel {
  weak var loginErrorDelegate: LoginErrorDelegate?
  weak var loginLoadingDelegate: LoginLoadingDelegate?
  private let authManager: SigninProtocol
  private let googleAuth: GoogleAuthProtocol
  var loginErrorMsg: String?
  var isLoading = false
  
  init(
    authManager: SigninProtocol = AuthManager(),
    googleAuth: GoogleAuthProtocol = AuthManager()
  ) {
    self.authManager = authManager
    self.googleAuth = googleAuth
  }
  
  func checkUser(email: String, password: String) {
    guard isValidEmail(email) else {
      loginErrorMsg = ValidationError.wrongEmail.rawValue
      loginErrorDelegate?.didErrorDuringLogin()
      return
    }
    
    guard password.count > 7 else {
      loginErrorMsg = ValidationError.shortPassword.rawValue
      loginErrorDelegate?.didErrorDuringLogin()
      return
    }
    
    guard isValidPassword(password) else {
      loginErrorMsg = ValidationError.wrongPassword.rawValue
      loginErrorDelegate?.didErrorDuringLogin()
      return
    }
    
    signInUser(email: email, password: password)
  }
  
  private func signInUser(email: String, password: String) {
    isLoading = true
    loginLoadingDelegate?.didLoginLoaded()
    
    Task {
      do {
        _ = try await authManager.signInUser(with: email, and: password)
        
        await MainActor.run {
          isLoading = false
          loginLoadingDelegate?.didLoginLoaded()
        }
      } catch let error as NSError {
        if error.domain == AuthErrorDomain {
          switch error.code {
          case AuthErrorCode.invalidCredential.rawValue:
            
            await MainActor.run {
              loginErrorMsg = "Invalid credentials. Please check your email and password."
              loginErrorDelegate?.didErrorDuringLogin()
              
              isLoading = false
              loginLoadingDelegate?.didLoginLoaded()
            }
          default:
            print("Error: \(error.localizedDescription)")
            
            await MainActor.run {
              loginErrorMsg = "Error: \(error.localizedDescription)"
              loginErrorDelegate?.didErrorDuringLogin()
              
              isLoading = false
              loginLoadingDelegate?.didLoginLoaded()
            }
          }
        }
      }
    }
  }
  
  func googleSignIn() {
    isLoading = true
    loginLoadingDelegate?.didLoginLoaded()
    
    Task {
      do {
        try await googleAuth.signupWithGoogle()
        
        await MainActor.run {
          isLoading = false
          loginLoadingDelegate?.didLoginLoaded()
        }
      } catch {
        await MainActor.run {
          isLoading = false
          loginLoadingDelegate?.didLoginLoaded()
          
          loginErrorMsg = error.localizedDescription
          loginErrorDelegate?.didErrorDuringLogin()
        }
      }
    }
  }
}
