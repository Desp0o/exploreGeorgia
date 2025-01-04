//
//  LoginViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 05.01.25.
//

protocol LoginErrorDelegate: AnyObject {
  func didErrorDuringLogin()
}

final class LoginViewModel {
  weak var loginErrorDelegate: LoginErrorDelegate?
  var loginErrorMsg: String?
  
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
  }
}
