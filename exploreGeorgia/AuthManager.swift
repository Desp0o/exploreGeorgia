//
//  AuthManager.swift
//  exploreGeorgia
//
//  Created by Despo on 26.12.24.
//

import FirebaseCore
import FirebaseAuth

protocol SignupProtocol {
  func createUser(email: String, password: String) async throws
}

final class AuthManager: SignupProtocol {
  
  func createUser(email: String, password: String) async throws {
    try await Auth.auth().createUser(withEmail: email, password: password)
  }
  
  func test() {
    
  }
  
}
