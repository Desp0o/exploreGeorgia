//
//  SingleUserProfileViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 25.01.25.
//

import FirebaseAuth

protocol SingleUserFetchDelegate: AnyObject {
  func didUserFetched()
}

final class SingleUserProfileViewModel {
  weak var userDelegate: SingleUserFetchDelegate?
  private let userManager: UserManager
  var user: UserModel? = nil
  
  init(userManager: UserManager = UserManager()) {
    self.userManager = userManager    
  }
  
  func fetchUser(userId: String) {
    Task{
      do {
        let currentUser = try await userManager.getFirebaseUser(with: userId)
        
        await MainActor.run {
          user = currentUser
          userDelegate?.didUserFetched()
        }
      }
    }
  }
}
