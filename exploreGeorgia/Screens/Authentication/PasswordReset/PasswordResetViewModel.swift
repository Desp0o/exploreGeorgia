//
//  PasswordResetViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 07.01.25.
//

import FirebaseFirestore

protocol ResetPassErrorDelegate: AnyObject {
  func didErrorDuringReseting()
}

protocol ResetPassowrdSuccessMessageDelegate: AnyObject {
  func didRequestSuccessed()
}

protocol ResetPasswordLoadingDelegate: AnyObject {
  func didLoadingStarted()
}

final class PasswordResetViewModel {
  private let authManager: PasswordResetProtocol
  weak var passErrorDelegate: ResetPassErrorDelegate?
  weak var passResetLoadingDelegate: ResetPasswordLoadingDelegate?
  weak var successedMessageDelegate: ResetPassowrdSuccessMessageDelegate?
  var passResetErrMessage = ""
  var passSuccessMessage = ""
  var isloading = false
  
  init(authManager: PasswordResetProtocol = AuthManager()) {
    self.authManager = authManager
  }
  
  func requestPssReset(email: String) {
    guard isValidEmail(email) else {
      passResetErrMessage = "Enter correct email forma"
      passErrorDelegate?.didErrorDuringReseting()
      return
    }
    
    isloading = true
    passResetLoadingDelegate?.didLoadingStarted()
    
    Task {
      do {
        let userExists = try await checkUser(email: email)
        
        if userExists {
          resetUserPassword(email: email)
        } else {
          await MainActor.run {
            isloading = false
            passResetLoadingDelegate?.didLoadingStarted()
            
            passResetErrMessage = "No user with this email was found."
            passErrorDelegate?.didErrorDuringReseting()
          }
        }
      } catch {
        await MainActor.run {
          passResetErrMessage = error.localizedDescription
          passErrorDelegate?.didErrorDuringReseting()
          
          isloading = false
          passResetLoadingDelegate?.didLoadingStarted()
        }
      }
    }
  }
  
  private func checkUser(email: String) async throws -> Bool {
    let db = Firestore.firestore()
    let usersCollection = db.collection("users")
    
    let query = usersCollection.whereField("email", isEqualTo: email)
    
    let querySnapshot = try await query.getDocuments()
    
    return !querySnapshot.documents.isEmpty
  }
  
  private func resetUserPassword(email: String) {
    Task {
      do {
        let test: () = try await authManager.resetPassword(email: email)
        print(test)
        await MainActor.run {
          isloading = false
          passResetLoadingDelegate?.didLoadingStarted()
          
          passSuccessMessage = "Please check you inbox."
          successedMessageDelegate?.didRequestSuccessed()
        }
      } catch {
        await MainActor.run {
          passResetErrMessage = error.localizedDescription
          passErrorDelegate?.didErrorDuringReseting()
          
          isloading = false
          passResetLoadingDelegate?.didLoadingStarted()
        }
      }
    }
  }
}
