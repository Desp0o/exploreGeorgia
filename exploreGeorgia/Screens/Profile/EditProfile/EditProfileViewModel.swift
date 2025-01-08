//
//  EditProfileViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import Foundation
import FirebaseAuth

final class EditProfileViewModel: ObservableObject {
  private let userManager: GetCurrentUserProtocol
  private let passwordManager: ChangePasswordProtocol
  private let userInfoManager: UserInfoUpdaeProtocol
  private let googleUserDeletionManager: DeleteGoogleUser
  @Published var firstName = ""
  @Published var lastName = ""
  @Published var password = ""
  @Published var rePassword = ""
  @Published var gender = ""
  @Published var isLoading = false
  @Published var errorMessage = ""
  
  let genderOptions = ["Male", "Female", "Not Prefer"]

  init(
    userManager: GetCurrentUserProtocol = UserManager(),
    passwordManager: ChangePasswordProtocol = UserManager(),
    userInfoManager: UserInfoUpdaeProtocol = UserManager(),
    googleUserDeletionManager: DeleteGoogleUser = UserManager()
  ) {
    self.userManager = userManager
    self.passwordManager = passwordManager
    self.userInfoManager = userInfoManager
    self.googleUserDeletionManager = googleUserDeletionManager
    
    fetchUser()
  }
  
  func fetchUser() {
    isLoading = true
    
    Task {
      do {
        let user = try await userManager.getCurrentUser()
        
        await MainActor.run {
          firstName = user?.firstName ?? ""
          lastName = user?.lastName ?? ""
          gender = user?.gender ?? "Not Prefer"
          
          isLoading = false
        }
      } catch {
        await MainActor.run {
          errorMessage = "Error fetching user: \(error.localizedDescription)"
          isLoading = false
        }
      }
    }
  }
  
  func updatePassword() {
    guard password.count > 7 else {
      errorMessage = "The password must be at least 8 characters long."
      print(errorMessage)
      return
    }
    
    guard isValidPassword(password) else {
      errorMessage = "The password must contain at least one uppercase letter, one number, and one special character."
      print(errorMessage)
      return
    }
    
    guard password == rePassword else {
      errorMessage = "The passwords do not match."
      print(errorMessage)
      return
    }
    
    Task {
      do {
        try await passwordManager.changePassword(password: password)
      } catch {
        await MainActor.run {
          errorMessage = error.localizedDescription
        }
      }
    }
  }
  
  func updateUser() {
    guard firstName.count > 1 else {
      errorMessage = "The first name must be at least 2 characters long"
      print(errorMessage)
      return
    }
    
    guard isValidNames(firstName) else {
      errorMessage = "The first name must contain only letters"
      print(errorMessage)
      return
    }
    
    guard lastName.count > 1 else {
      errorMessage = "The last name must be at least 2 characters long"
      print(errorMessage)
      return
    }
    
    guard isValidNames(lastName) else {
      errorMessage = "The last name must contain only letters"
      print(errorMessage)
      return
    }
    
    Task {
      do {
        try await userInfoManager.updateUserInfo(firstName: firstName, lastName: lastName, gender: gender)
      } catch {
        await MainActor.run {
          errorMessage = error.localizedDescription
        }
      }
    }
  }
  
  func userAccountDelete() {
    Task {
      do {
        try await googleUserDeletionManager.removeGoogleUser()
      } catch {
        await MainActor.run {
          errorMessage = error.localizedDescription
        }
      }
    }
  }
}
