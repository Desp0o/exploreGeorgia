//
//  UserManager.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import FirebaseStorage

protocol GetCurrentUserProtocol {
  func getCurrentUser() async throws -> UserModel?
}

protocol ChangePasswordProtocol {
  func changePassword(password: String) async throws
}

protocol UserInfoUpdaeProtocol {
  func updateUserInfo(firstName: String, lastName: String, gender: String) async throws
}

protocol DeleteGoogleUser {
  func removeGoogleUser() async throws
}

protocol DeleteUserWithEmail {
  func deleteUser(email: String, password: String) async throws
}

protocol AvatarUpdateProtocol {
  func updateUserProfileImage(image: UIImage) async throws
}


final class UserManager: GetCurrentUserProtocol {
  
  func getCurrentUser() async throws -> UserModel? {
    let db = Firestore.firestore()
    
    guard let fetchedUser = Auth.auth().currentUser else {
      throw FetchedUserErrors.noUserLogged(message: "No user is signed in.")
    }
    
    let document = try await db.collection("users").document(fetchedUser.uid).getDocument()
    
    if document.exists, let data = document.data() {
      let avatar = data["photoURL"] as? String ?? ""
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

extension UserManager: DeleteGoogleUser {
  func removeGoogleUser() async throws{
    guard let user = Auth.auth().currentUser else {
      print("User is not signed in")
      return
    }
    
    do {
      guard let currentUser = GIDSignIn.sharedInstance.currentUser else {
        print("Google user is not signed in")
        return
      }
      
      guard let idToken = currentUser.idToken?.tokenString else {
        print("Failed to retrieve Google ID token")
        return
      }
      
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: currentUser.accessToken.tokenString)
      
      try await user.reauthenticate(with: credential)
      
      try await user.delete()
      print("Google user successfully removed from Firebase Authentication.")
    } catch let error as NSError {
      switch error.code {
      case AuthErrorCode.requiresRecentLogin.rawValue:
        throw AuthErrorCode.requiresRecentLogin
      default:
        throw error
      }
    }
  }
}

extension UserManager: DeleteUserWithEmail {
  func deleteUser(email: String, password: String) async throws {
    guard let user = Auth.auth().currentUser else {
      print("User is not signed in")
      return
    }
    
    do {
      if let userEmail = user.email {
        let credential = EmailAuthProvider.credential(withEmail: userEmail, password: password)
        try await user.reauthenticate(with: credential)
      }
      
      try await user.delete()
      print("Account deleted successfully!")
    } catch let error as NSError {
      switch error.code {
      case AuthErrorCode.requiresRecentLogin.rawValue:
        throw AuthErrorCode.requiresRecentLogin
      default:
        throw error
      }
    }
  }
}

extension UserManager: AvatarUpdateProtocol {
  func generateAvatarURL(image: UIImage, userId: String) async throws -> String {
    guard let imageData = image.jpegData(compressionQuality: 0.2) else {
      throw NSError(domain: "Image Conversion Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data"])
    }
    
    let storageRef = Storage.storage().reference().child("profile_pictures/\(userId).jpg")
    
    do {
      let _ = try await storageRef.putDataAsync(imageData)
    } catch {
      throw error
    }
    
    do {
      let downloadURL = try await storageRef.downloadURL()

      return downloadURL.absoluteString
    } catch {
      throw error
    }
  }
  
  func updateUserProfileImage(image: UIImage) async throws {
    guard let user = Auth.auth().currentUser else {
      return
    }
    
    let generatedAvatarURL: String
    do {
      generatedAvatarURL = try await generateAvatarURL(image: image, userId: user.uid)
    } catch {
      throw error
    }
    
    let db = Firestore.firestore()
    let userRef = db.collection("users").document(user.uid)
    
    let userInfo: [String: Any] = ["photoURL": generatedAvatarURL]
    
    do {
      try await userRef.updateData(userInfo)
    } catch {
      throw error
    }
  }
}
