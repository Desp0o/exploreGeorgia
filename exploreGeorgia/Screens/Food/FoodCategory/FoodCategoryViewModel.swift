//
//  FoodCategoryViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 24.01.25.
//

protocol DataFetchingDelegae: AnyObject {
  func didDataFetched()
}

final class FoodCategoryViewModel {
  weak var dataDelegate: DataFetchingDelegae?
  private let firebaseManager: FirebaseSimpleCollectionFetchProtocol
  var fetchedData: [ResturantModel] = []
  var isLoading = true
  
  init(firebaseManager: FirebaseSimpleCollectionFetchProtocol = FirebaseFetchingService()) {
    self.firebaseManager = firebaseManager
  }
  
  func fetchDataFromDB(collectionName: FirebaseCollectionEnum, pageSize: Int) {
    Task {
      do {
        let result: [ResturantModel] = try await firebaseManager.fetchCollection(collectionName: collectionName, limit: pageSize)
        
        await MainActor.run {
          fetchedData = result
          dataDelegate?.didDataFetched()
          
          isLoading = false
        }
      } catch {
        await MainActor.run {
          isLoading = false
        }
      }
    }
  }
}
