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
import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
  private let fetchUser: GetFirebaseUserProtocol
  private let authManager: LogOutProtocol
  @Published var isLoading = true
  @Published var isFirstLoad = true
  @Published var user: UserModel?
  @Published var errorMessage: String?
  @Published var profileStatistic: [ProfileStatModel] = []
  @Published var isPresented = false
  @Published var isSecurotyPresented = false
  @Published var isAppereancePresented = false
  @Published var isDeleteAccPresented = false
  
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
          user = fetchedUser
          updateProfileStatistic()
          isLoading = false
          isFirstLoad = false
        } else {
          errorMessage = "No user found."
          isLoading = false
          isFirstLoad = false
        }
      } catch {
        errorMessage = "Error fetching user: \(error.localizedDescription)"
        isLoading = false
        isFirstLoad = false
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
