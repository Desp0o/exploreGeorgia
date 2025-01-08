//
//  ProfileViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import Foundation
import Combine
import SwiftUICore

final class ProfileViewModel: ObservableObject {
  private let fetchUser: GetCurrentUserProtocol
  private let authManager: LogOutProtocol
  @Published var isLoading = true
  @Published var user: UserModel?
  @Published var errorMessage: String?
  @Published var profileStatistic: [ProfileStatModel] = []
  
  let settingsArray = [
    ProfileSettingsModel(icon: "profile", title: "Edit Profile", location: AnyView(EditProfile())),
    ProfileSettingsModel(icon: "bookmark", title: "Bookmarked", location: AnyView(EditProfile())),
    ProfileSettingsModel(icon: "trip", title: "My Explored", location: AnyView(EditProfile())),
    ProfileSettingsModel(icon: "Settings", title: "Settings", location: AnyView(EditProfile())),
    ProfileSettingsModel(icon: "support", title: "Support", location: AnyView(EditProfile()))
  ]
  
  
  init(
    fetchUser: GetCurrentUserProtocol = UserManager(),
    authManager: LogOutProtocol = AuthManager()
  ) {
    self.fetchUser = fetchUser
    self.authManager = authManager
    
    fetchProfile()
  }
  
  func fetchProfile() {
    isLoading = true
    Task {
      do {
        if let fetchedUser = try await fetchUser.getCurrentUser() {
          await MainActor.run {
            user = fetchedUser
            updateProfileStatistic()
            isLoading = false
          }
        } else {
          await MainActor.run {
            errorMessage = "No user found."
            isLoading = false
          }
        }
      } catch {
        await MainActor.run {
          errorMessage = "Error fetching user: \(error.localizedDescription)"
          isLoading = false
        }
      }
    }
  }
  
  func updateProfileStatistic() {
    profileStatistic = [
      ProfileStatModel(title: "Points", count: user?.points ?? 0),
      ProfileStatModel(title: "Explored", count: user?.explored.count ?? 0),
      ProfileStatModel(title: "Bucket List", count: user?.bucketList.count ?? 0)
    ]
  }
  
  func logOut() {
    Task {
      do {
        try await authManager.userLogOut()
      } catch {
        print(error)
      }
    }
  }
}
