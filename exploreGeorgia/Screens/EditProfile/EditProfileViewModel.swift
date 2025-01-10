//
//  EditProfileViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import Foundation
import FirebaseAuth
import _PhotosUI_SwiftUI
import SwiftUI

final class EditProfileViewModel: ObservableObject {
  private let userManager: GetCurrentUserProtocol
  private let passwordManager: ChangePasswordProtocol
  private let userInfoManager: UserInfoUpdaeProtocol
  private let googleUserDeletionManager: DeleteGoogleUser
  private let defaultUserDeletionManager: DeleteUserWithEmail
  private let avatarUploadManager: AvatarUpdateProtocol
  @Published var firstName = ""
  @Published var lastName = ""
  @Published var password = ""
  @Published var rePassword = ""
  @Published var gender = ""
  @Published var passwordForDelete = ""
  @Published var isLoading = false
  @Published var isUpdatignInfo = false
  @Published var isUserFromGoogle = false
  @Published var errorMessage = ""
  @Published var currentAvatar = ""
  @Published var completionMessage = ""
  @Published var choosenAvatar: UIImage? = nil
  @Published var selectedAvatarFromPicker: PhotosPickerItem? = nil {
    didSet {
      avatarUpload(from: selectedAvatarFromPicker)
    }
  }
  @AppStorage("Language") var selectedLanguage = "Eng"
  @AppStorage("isDarkTheme") var isDarkTheme = UITraitCollection.current.userInterfaceStyle == .dark

  let genderOptions = ["Male", "Female", "Not Prefer"]
  let languageArr = ["Eng", "Geo"]

  init(
    userManager: GetCurrentUserProtocol = UserManager(),
    passwordManager: ChangePasswordProtocol = UserManager(),
    userInfoManager: UserInfoUpdaeProtocol = UserManager(),
    googleUserDeletionManager: DeleteGoogleUser = UserManager(),
    defaultUserDeletionManager: DeleteUserWithEmail = UserManager(),
    avatarUpdateManager: AvatarUpdateProtocol = UserManager()
  ) {
    self.userManager = userManager
    self.passwordManager = passwordManager
    self.userInfoManager = userInfoManager
    self.googleUserDeletionManager = googleUserDeletionManager
    self.defaultUserDeletionManager = defaultUserDeletionManager
    self.avatarUploadManager = avatarUpdateManager
    
    fetchUser()
    getUserPorivuder()
  }
  
  func fetchUser() {
    isLoading = true
    
    Task {
      do {
        let user = try await userManager.getCurrentUser()
        
        await MainActor.run {
          currentAvatar = user?.avatar ?? ""
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
  
  func getUserPorivuder() {
    Task {
      guard let user = Auth.auth().currentUser else {
        return
      }
      
      for userInfo in user.providerData {
        if userInfo.providerID == "google.com" {
          await MainActor.run {
            isUserFromGoogle = true
          }
        } else {
          await MainActor.run {
            isUserFromGoogle = false
          }
        }
      }
    }
  }
  
  func updatePassword() {
    guard password.count > 7 else {
      errorMessage = ValidationError.shortPassword.rawValue
      return
    }
    
    guard isValidPassword(password) else {
      errorMessage = ValidationError.wrongPassword.rawValue
      return
    }
    
    guard password == rePassword else {
      errorMessage = ValidationError.passNoMatch.rawValue
      return
    }
    
    isUpdatignInfo = true
    
    Task {
      do {
        try await passwordManager.changePassword(password: password)
        
        await MainActor.run {
          isUpdatignInfo = false
          completionMessage = "Password updated successfully"
        }
      } catch {
        await MainActor.run {
          errorMessage = error.localizedDescription
          isUpdatignInfo = false
        }
      }
    }
  }
  
  func updateUser() {
    guard firstName.count > 1 else {
      errorMessage = ValidationError.shortFirstName.rawValue
      return
    }
    
    guard isValidNames(firstName) else {
      errorMessage = ValidationError.wrongFirsName.rawValue
      return
    }
    
    guard lastName.count > 1 else {
      errorMessage = ValidationError.shortLastName.rawValue
      return
    }
    
    guard isValidNames(lastName) else {
      errorMessage = ValidationError.wrongLastName.rawValue
      return
    }
    
    isUpdatignInfo = true
    
    Task {
      do {
        try await userInfoManager.updateUserInfo(firstName: firstName, lastName: lastName, gender: gender)
        
        await MainActor.run {
          isUpdatignInfo = false
          completionMessage = "Your info updated successfully"
        }
      } catch {
        await MainActor.run {
          errorMessage = error.localizedDescription
          isUpdatignInfo = false
        }
      }
    }
  }
  
  func userAccountDelete() {
    isUpdatignInfo = true
    
    Task {
      do {
        guard let user = try await userManager.getCurrentUser() else {
          return
        }
        
        if isUserFromGoogle {
          try await googleUserDeletionManager.removeGoogleUser()
          
          await MainActor.run {
            isUpdatignInfo = false
          }
        } else {
          deleteUserWithEmail(with: user.email)
        }
      } catch {
        await MainActor.run {
          errorMessage = error.localizedDescription
          isUpdatignInfo = false
        }
      }
    }
  }
  
  private func deleteUserWithEmail(with email: String) {
    Task {
      do {
        guard passwordForDelete.count > 7 else {
          await MainActor.run {
            errorMessage = ValidationError.shortPassword.rawValue
            isUpdatignInfo = false
          }
          return
        }
        
        guard isValidPassword(passwordForDelete) else {
          await MainActor.run {
            errorMessage = ValidationError.wrongPassword.rawValue
            isUpdatignInfo = false
          }
          return
        }
        
        try await defaultUserDeletionManager.deleteUser(email: email, password: passwordForDelete)
        
        await MainActor.run {
          isUpdatignInfo = false
        }
      }
      catch {
        errorMessage = error.localizedDescription
        await MainActor.run {
          isUpdatignInfo = false
        }
      }
    }
  }
  
  private func avatarUpload(from selection: PhotosPickerItem?) {
    guard let selection else {
      return
    }
    
    isUpdatignInfo = true
    
    Task {
      if let data = try await selection.loadTransferable(type: Data.self) {
        if let uiImage = UIImage(data: data) {
          await MainActor.run {
            choosenAvatar = uiImage
          }
          
          do {
            try await avatarUploadManager.updateUserProfileImage(image: uiImage)
            
            await MainActor.run {
              isUpdatignInfo = false
              completionMessage = "Profile photo updated successfully"
            }
          } catch {
            await MainActor.run {
              isUpdatignInfo = false
            }
          }
        }
      }
    }
  }
}
