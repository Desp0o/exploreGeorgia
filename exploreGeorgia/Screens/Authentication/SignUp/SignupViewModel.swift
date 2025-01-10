//
//  SignupViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 26.12.24.
//

import Foundation

protocol RegisterErrorMessageDelegate: AnyObject {
  func didErrorDuringSignup()
}

protocol RegisterResultMessageDelegate: AnyObject {
  func didRegisterMessageChanged()
}

protocol RegistrationLoadingDelegate: AnyObject {
  func didRegistrationLoaded()
}

final class SignupViewModel {
  weak var errorDelegate: RegisterErrorMessageDelegate?
  weak var regResultDelegate: RegisterResultMessageDelegate?
  weak var regLoadingDelegate: RegistrationLoadingDelegate?
  private let authManager: SignupProtocol
  var errorMessage: String?
  var registerResultMessage: String?
  var isLoading: Bool = false
  
  init(authManager: SignupProtocol = AuthManager()) {
    self.authManager = authManager
  }
  
  func signUpUser(user: RegisteredUserModel) {
    isLoading = true
    regLoadingDelegate?.didRegistrationLoaded()
    
    Task {
      do {
        try await authManager.createUser(user: user)
        await MainActor.run {
          registerResultMessage = "Registration completed successfully"
          regResultDelegate?.didRegisterMessageChanged()
          
          isLoading = false
          regLoadingDelegate?.didRegistrationLoaded()
        }
      } catch {
        await MainActor.run {
          errorMessage = error.localizedDescription
          errorDelegate?.didErrorDuringSignup()
          
          isLoading = false
          regLoadingDelegate?.didRegistrationLoaded()
        }
      }
    }
  }
  
  func checkUser(
    firstName: String,
    lastName: String,
    email: String,
    password: String,
    rePassword: String
  ) {
    guard firstName.count > 1 else {
      errorMessage = ValidationError.shortFirstName.rawValue
      errorDelegate?.didErrorDuringSignup()
      return
    }
    
    guard isValidNames(firstName) else {
      errorMessage = ValidationError.wrongFirsName.rawValue
      errorDelegate?.didErrorDuringSignup()
      return
    }
    
    guard lastName.count > 1 else {
      errorMessage = ValidationError.shortLastName.rawValue
      errorDelegate?.didErrorDuringSignup()
      return
    }
    
    guard isValidNames(lastName) else {
      errorMessage = ValidationError.wrongLastName.rawValue
      errorDelegate?.didErrorDuringSignup()
      return
    }
    
    guard isValidEmail(email) else {
      errorMessage = ValidationError.wrongEmail.rawValue
      errorDelegate?.didErrorDuringSignup()
      return
    }
    
    guard password.count > 7 else {
      errorMessage = ValidationError.shortPassword.rawValue
      errorDelegate?.didErrorDuringSignup()
      return
    }
    
    guard isValidPassword(password) else {
      errorMessage = ValidationError.wrongPassword.rawValue
      errorDelegate?.didErrorDuringSignup()
      return
    }
    
    guard password == rePassword else {
      errorMessage = ValidationError.passNoMatch.rawValue
      errorDelegate?.didErrorDuringSignup()
      return
    }
    
    let user = RegisteredUserModel(firstName: firstName, lastName: lastName, email: email, password: password)
    
    signUpUser(user: user)
  }
}
