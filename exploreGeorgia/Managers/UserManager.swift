//
//  UserManager.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct UserModel {
  let avatar: String
  let firstName: String
  let lastName: String
  let email: String
  let gender: String
  let points: Int
  let explored: [String]
  let bucketList: [String]
  let achievement: [String]
  let createdAt: Timestamp?
}

enum FetchedUserErrors: Error {
  case noUserLogged(message: String)
  case userDoesntExist(message: String)
  case unknownError(message: String)
}

protocol GetCurrentUserProtocol {
  func getCurrentUser() async throws -> UserModel?
}

final class UserManager: GetCurrentUserProtocol {
  
  func getCurrentUser() async throws -> UserModel? {
    let db = Firestore.firestore()
    
    guard let fetchedUser = Auth.auth().currentUser else {
      throw FetchedUserErrors.noUserLogged(message: "No user is signed in.")
    }
    
    let document = try await db.collection("users").document(fetchedUser.uid).getDocument()
    
    if document.exists, let data = document.data() {
      let avatar = fetchedUser.photoURL?.absoluteString ?? ""
      let firstName = data["firstName"] as? String ?? ""
      let lastName = data["lastName"] as? String ?? ""
      let email = fetchedUser.email ?? ""
      let gender = data["gender"] as? String ?? ""
      let points = data["points"] as? Int ?? 0
      let explored = data["explored"] as? [String] ?? []
      let bucketList = data["bucketList"] as? [String] ?? []
      let achievement = data["achievement"] as? [String] ?? []
      let createdAt = data["createdAt"] as? Timestamp ?? Timestamp()
      
      return UserModel(
        avatar: avatar,
        firstName: firstName,
        lastName: lastName,
        email: email,
        gender: gender,
        points: points,
        explored: explored,
        bucketList: bucketList,
        achievement: achievement,
        createdAt: createdAt
      )
    } else {
      throw FetchedUserErrors.userDoesntExist(message: "Document does not exist.")
    }
  }
}

protocol ChangePasswordProtocol {
  func changePassword(password: String) async throws
}

extension UserManager: ChangePasswordProtocol {
  func changePassword(password: String) async throws {
    guard let user = Auth.auth().currentUser else {
      print("User is not signed in")
      return
    }

    do {
      try await user.updatePassword(to: password)
      print("Password updated successfully!")
    } catch {
      throw error
    }
  }
}


protocol UserInfoUpdaeProtocol {
  func updateUserInfo(firstName: String, lastName: String, gender: String) async throws
}

extension UserManager: UserInfoUpdaeProtocol {
  func updateUserInfo(firstName: String, lastName: String, gender: String) async throws {
        guard let user = Auth.auth().currentUser else {
            print("User is not signed in")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)

        let userInfo: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "gender": gender
        ]
        
        do {
            try await userRef.updateData(userInfo)
            print("User info updated successfully!")
        } catch {
          throw error
        }
    }
}
