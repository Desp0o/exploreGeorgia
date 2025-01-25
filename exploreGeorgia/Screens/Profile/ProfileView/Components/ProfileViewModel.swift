//
//  ProfileViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import Foundation
import Combine
import SwiftUICore
import FirebaseAuth

final class ProfileViewModel: ObservableObject {
  private let fetchUser: GetFirebaseUserProtocol
  private let authManager: LogOutProtocol
  @Published var isLoading = true
  @Published var user: UserModel?
  @Published var errorMessage: String?
  @Published var profileStatistic: [ProfileStatModel] = []
  
  init(
    fetchUser: GetFirebaseUserProtocol = UserManager(),
    authManager: LogOutProtocol = AuthManager()
  ) {
    self.fetchUser = fetchUser
    self.authManager = authManager
  }
  
  func fetchProfile() {
    Task {
      do {
        let userID = Auth.auth().currentUser?.uid

        if let fetchedUser = try await fetchUser.getFirebaseUser(with: userID ?? "") {
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
      ProfileStatModel(title: "Explored", count: user?.explored.count ?? 0),
      ProfileStatModel(title: "Bucket List", count: user?.bucketList.count ?? 0)
    ]
  }
  
  func logOut() {
    Task {
      do {
        try await authManager.userLogOut()
      } catch {
        errorMessage = error.localizedDescription
      }
    }
  }
}
