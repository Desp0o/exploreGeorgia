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

final class SignupViewModel {
    weak var errorDelegate: RegisterErrorMessageDelegate?
    var firstName = ""
    var lastName = ""
    var email = ""
    var password = ""
    var errorMessage: String?
    
    var authManager: SignupProtocol

    init(authManager: SignupProtocol = AuthManager()) {
        self.authManager = authManager
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
  
  func checkUser(
    firstNameValue: String,
    lastNameValue: String,
    emailValue: String,
    pwdValue: String,
    rePwdValue: String
  ) {
    firstName = firstNameValue
    lastName = lastNameValue
    email = emailValue
    password = pwdValue
    
    guard firstName.count > 1 else {
      errorMessage = "The first name must be at least 2 characters long"
      errorDelegate?.didErrorDuringSignup()
      return
    }
    
    guard isValidNames(firstName) else {
      errorMessage = "The first name must contain only letters"
      errorDelegate?.didErrorDuringSignup()
      return
    }
    
    guard lastName.count > 1 else {
      errorMessage = "The last name must be at least 2 characters long"
      errorDelegate?.didErrorDuringSignup()
      return
    }
    
    guard isValidNames(lastName) else {
      errorMessage = "The last name must contain only letters"
      errorDelegate?.didErrorDuringSignup()
      return
    }
    
    guard isValidEmail(email) else {
      errorMessage = "Enter correct email format"
      errorDelegate?.didErrorDuringSignup()
      return
    }
    
    guard password.count > 7 else {
      errorMessage = "The password must be at least 8 characters long."
      errorDelegate?.didErrorDuringSignup()
      return
    }
    
    guard isValidPassword(password) else {
      errorMessage = "The password must contain at least one uppercase letter, one number, and one special character."
      errorDelegate?.didErrorDuringSignup()
      return
    }
    
    guard password == rePwdValue else {
      errorMessage = "The passwords do not match."
      errorDelegate?.didErrorDuringSignup()
      return
    }
    
    print(firstName, lastName, email, password)
  }
}









