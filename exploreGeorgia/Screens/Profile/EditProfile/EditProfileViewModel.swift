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
  @Published var firstName = ""
  @Published var lastName = ""
  @Published var password = ""
  @Published var rePassword = ""
  @Published var gender = "Not Prefer"
  @Published var isLoading = false
  @Published var errorMessage = ""
  
  let genderOptions = ["Male", "Female", "Not Prefer"]

  init(
    userManager: GetCurrentUserProtocol = UserManager(),
    passwordManager: ChangePasswordProtocol = UserManager()
  ) {
    self.userManager = userManager
    self.passwordManager = passwordManager
    
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
          
          isLoading = false
        }
      } catch {
        errorMessage = "Error fetching user: \(error.localizedDescription)"
        isLoading = false
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
        print("pass changed")
      } catch {
        await MainActor.run {
          errorMessage = error.localizedDescription
        }
      }
    }
  }
  
}
