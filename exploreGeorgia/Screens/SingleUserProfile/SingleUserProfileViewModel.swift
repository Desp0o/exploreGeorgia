//
//  SingleUserProfileViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 25.01.25.
//

import FirebaseFirestore

protocol SingleUserFetchDelegate: AnyObject {
  func didUserFetched()
}

protocol SingleUserLoadingDelegate: AnyObject {
  func didLoadingStopped()
}

protocol SingleUserDataDelegate: AnyObject {
  func didDataFetched()
}

final class SingleUserProfileViewModel {
  weak var userDelegate: SingleUserFetchDelegate?
  weak var loadingDelegate: SingleUserLoadingDelegate?
  weak var dataDelegate: SingleUserDataDelegate?
  private let userManager: UserManager
  private let firebaseManager: FetchSingleUserExploredPlacesProtocol
  private var hasMoreData = true
  private var lastDocument: DocumentSnapshot?
  var user: UserModel? = nil
  var fetchedPlaces: [SightSeenModel] = []
  var isLoading = true
  var errorMessage = ""
  
  init(
    userManager: UserManager = UserManager(),
    firebaseManager: FetchSingleUserExploredPlacesProtocol = FirebaseFetchingService()
  ) {
    self.userManager = userManager
    self.firebaseManager = firebaseManager
  }
  
  func fetchUser(userId: String) {
    Task{
      do {
        let currentUser = try await userManager.getFirebaseUser(with: userId)
        
        await MainActor.run {
          user = currentUser
          userDelegate?.didUserFetched()
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  func fetchData(pageSize: Int, userId: String) {
    guard hasMoreData else { return }
    
    
    
    Task {
      await MainActor.run {
        isLoading = true
        loadingDelegate?.didLoadingStopped()
      }
      
      do {
        let result = try await firebaseManager.fetchUserPlaces(
          userId: userId,
          pageSize: pageSize,
          lastDocument: lastDocument
        )
        
        await MainActor.run {
          lastDocument = result.lastDocument
          hasMoreData = result.hasMoreData
          fetchedPlaces.append(contentsOf: result.places)
          isLoading = false
          loadingDelegate?.didLoadingStopped()
          dataDelegate?.didDataFetched()
        }
      } catch {
        await MainActor.run {
          isLoading = false
          loadingDelegate?.didLoadingStopped()
        }
      }
    }
  }
}
