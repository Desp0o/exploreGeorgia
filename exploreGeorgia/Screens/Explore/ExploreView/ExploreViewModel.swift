//
//  ExploreViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 15.01.25.
//

import Combine
import FirebaseFirestore

@MainActor
final class ExploreViewModel: ObservableObject {
  private let firebaseManager: FirebaseFetchingServicePorotocol
  private var lastDocument: DocumentSnapshot? = nil
  
  var hasMoreData = true
  
  @Published var fetchedPlaces: [SightSeenModel] = []
  @Published var isLoading = true
  @Published var isFetching = false
  
  init(
    firebaseManager: FirebaseFetchingServicePorotocol = FirebaseFetchingService()
  ) {
    self.firebaseManager = firebaseManager
    
    fetchData()
  }
  
  func fetchData() {
    guard !isFetching && hasMoreData else { return }
    isFetching = true
    
    Task {
      do {
        let (places, newLastDocument, hasMore): ([SightSeenModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchCollectionFromFirebase(
          collectionName: .usersPlace,
          pageSize: 10,
          lastDocument: lastDocument,
          userBucketList: [""]
        )
        
        lastDocument = newLastDocument
        hasMoreData = hasMore
        fetchedPlaces.append(contentsOf: places)
        isLoading = false
        isFetching = false
      } catch {
        isLoading = false
        isFetching = false
      }
    }
  }
  
  func reFetchData() {
    Task {
      do {
        let (places, _, _): ([SightSeenModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchCollectionFromFirebase(
          collectionName: .usersPlace,
          pageSize: 10,
          lastDocument: nil,
          userBucketList: [""]
        )
        
        fetchedPlaces = places
      } catch {
        isLoading = false
        isFetching = false
      }
    }
  }
}
