//
//  MyExploresViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 17.01.25.
//

import FirebaseFirestore

protocol MyExploresDelegate: AnyObject {
  func didDataLoaded()
}

protocol MyExploresLoadingDelegate: AnyObject {
  func didLoadingStopped()
}

protocol MyExploresErrorDelegate: AnyObject {
  func didErrorOccurred()
}

final class MyExploresViewModel {
  private let firebaseManager: FirebaseFetchingServicePorotocol
  private var lastDocument: DocumentSnapshot?
  private var hasMoreData = true
  weak var exploresDelegate: MyExploresDelegate?
  weak var loadingDelegate: MyExploresLoadingDelegate?
  weak var errorDeleage: MyExploresErrorDelegate?
  var fetchedPlaces: [SightSeenModel] = []
  var isLoading = true
  var errorMessage = ""
  
  
  init(firebaseManager: FirebaseFetchingServicePorotocol = FirebaseFetchingService()) {
    self.firebaseManager = firebaseManager
    
    fetchData(pageSize: 10)
  }
  
  func fetchData(pageSize: Int) {
    guard hasMoreData else { return }
    
    Task {
      do {
        await MainActor.run {
          loadingDelegate?.didLoadingStopped()
        }
        
        let result = try await firebaseManager.fetchPlaces(
          collectionName: "usersPlaces",
          pageSize: pageSize,
          lastDocument: nil,
          userBucketList: [""]
        )
        
        await MainActor.run {
          lastDocument = result.lastDocument
          hasMoreData = result.hasMoreData
          
          fetchedPlaces = result.places
          exploresDelegate?.didDataLoaded()
          
          isLoading = false
          loadingDelegate?.didLoadingStopped()
        }
      } catch {
        await MainActor.run {
          isLoading = false
          loadingDelegate?.didLoadingStopped()
          
          errorMessage = error.localizedDescription
          errorDeleage?.didErrorOccurred()
        }
      }
    }
  }
}
