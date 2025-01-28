//
//  AuthManager.swift
//  exploreGeorgia
//
//  Created by Despo on 26.12.24.
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import GoogleSignInSwift

protocol SignupProtocol {
  func createUser(user: RegisteredUserModel) async throws
}

protocol SigninProtocol {
  func signInUser(with email: String, and password: String) async throws -> AuthDataResult
}

protocol GoogleAuthProtocol {
  func signupWithGoogle() async throws
}

protocol PasswordResetProtocol {
  func resetPassword(email: String) async throws
}

protocol LogOutProtocol {
  func userLogOut() async throws
}


final class AuthManager: SignupProtocol {
  private let noAvatarURL = "https://firebasestorage.googleapis.com/v0/b/explore-georgia-7d646.firebasestorage.app/o/noAvatar.png?alt=media&token=fbc30487-743f-4258-939b-127645fc4786"
  private let auth = Auth.auth()
  
  func createUser(user: RegisteredUserModel) async throws {
    let db = Firestore.firestore()
    
    let authResult = try await auth.createUser(withEmail: user.email, password: user.password)
    let userRef = db.collection("users").document(authResult.user.uid)
    
    let userData: [String: Any] = [
      "id": userRef.documentID,
      "photoURL" : noAvatarURL,
      "firstName": user.firstName,
      "lastName": user.lastName,
      "email": user.email,
      "gender": "Not Prefer",
      "points": 0,
      "explored": [],
      "bucketList": [],
      "achievement": [],
      "createdAt": Timestamp(date: Date())
    ]
    
    try await db.collection("users").document(authResult.user.uid).setData(userData)
  }
}

extension AuthManager: SigninProtocol {
  func signInUser(with email: String, and password: String) async throws -> AuthDataResult {
    let signInResult = try await Auth.auth().signIn(withEmail: email, password: password)
    return signInResult
  }
}

extension AuthManager: GoogleAuthProtocol {
  @MainActor
  func signupWithGoogle() async throws {
    guard let clientID = FirebaseApp.app()?.options.clientID else {
      fatalError("No client ID found in Firebase configuration")
    }
    
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config
    
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first,
          let rootViewController = window.rootViewController else {
      print("There is no root view controller!")
      throw AuthenticationError.unknownError(message: "unknown error")
    }
    
    do {
      let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
      
      let user = userAuthentication.user
      guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
      let accessToken = user.accessToken
      
      let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                     accessToken: accessToken.tokenString)
      
      let authResult = try await Auth.auth().signIn(with: credential)
      let firebaseUser = authResult.user
      
      let db = Firestore.firestore()
      let userRef = db.collection("users").document(firebaseUser.uid)
      
      let documentSnapshot = try await userRef.getDocument()
      if !documentSnapshot.exists {
        let userData: [String: Any] = [
          "id": documentSnapshot.documentID,
          "photoURL": firebaseUser.photoURL?.absoluteString ?? "",
          "firstName": user.profile?.givenName ?? "",
          "lastName": user.profile?.familyName ?? "",
          "email": firebaseUser.email ?? "",
          "gender": "Not Prefer",
          "points": 0,
          "explored": [],
          "bucketList": [],
          "achievement": [],
          "createdAt": Timestamp(date: Date())
        ]
        
        try await userRef.setData(userData, merge: true)
      }
    }
    catch {
      throw error
    }
  }
}

extension AuthManager: PasswordResetProtocol {
  func resetPassword(email: String) async throws {
    try await Auth.auth().sendPasswordReset(withEmail: email)
  }
}

extension AuthManager: LogOutProtocol {
  func userLogOut() async throws {
    do {
      try auth.signOut()
    } catch let signOutError as NSError {
      throw AuthenticationError.unknownError(message: "Error signing out: %@, \(signOutError)")
    }
  }
}
