//
//  AuthManager.swift
//  exploreGeorgia
//
//  Created by Despo on 26.12.24.
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

protocol SignupProtocol {
  func createUser(user: RegisteredUserModel) async throws
}

final class AuthManager: SignupProtocol {
  
  func createUser(user: RegisteredUserModel) async throws {
    let authResult = try await Auth.auth().createUser(withEmail: user.email, password: user.password)
    
    let db = Firestore.firestore()
    let userData: [String: Any] = [
      "firstName": user.firstName,
      "lastName": user.lastName,
      "email": user.email
    ]

    try await db.collection("users").document(authResult.user.uid).setData(userData)
  }
}



protocol SigninProtocol {
  func signInUser(with email: String, and password: String) async throws -> AuthDataResult
}

extension AuthManager: SigninProtocol {
  func signInUser(with email: String, and password: String) async throws -> AuthDataResult {
      let signInResult = try await Auth.auth().signIn(withEmail: email, password: password)
      return signInResult
  }
}
