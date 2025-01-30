//
//  FoodCategoryViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 24.01.25.
//

import FirebaseFirestore

protocol DataFetchingDelegae: AnyObject {
  func didDataFetched()
}

protocol DataLoadingDelegate: AnyObject {
  func DidDataLoaded()
}

final class FoodCategoryViewModel {
  weak var dataDelegate: DataFetchingDelegae?
  weak var loadingDelegate: DataLoadingDelegate?
  private let firebaseManager: FirebaseFetchingServicePorotocol
  var fetchedData: [ResturantModel] = []
  var isLoading = true
  var isFetching = false
  var lastDocument: DocumentSnapshot? = nil
  var hasMoreData = true
  
  init(firebaseManager: FirebaseFetchingServicePorotocol = FirebaseFetchingService()) {
    self.firebaseManager = firebaseManager
  }
  
  func fetchDataFromDB(collectionName: FirebaseCollectionEnum) {
    guard !isFetching && hasMoreData else { return }
    isFetching = true
    
    Task {
      await MainActor.run {
        isLoading = true
      }
      
      do {
        let (places, newLastDocument, hasMore): ([ResturantModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchCollectionFromFirebase(
          collectionName: collectionName,
          pageSize: 10,
          lastDocument: lastDocument,
          userBucketList: []
        )
        
        await MainActor.run {
          fetchedData.append(contentsOf: places)
          lastDocument = newLastDocument
          hasMoreData = hasMore
          dataDelegate?.didDataFetched()
          isFetching = false
          isLoading = false
        }
      } catch {
        await MainActor.run {
          isFetching = false
          isLoading = false
        }
      }
    }
  }
}
