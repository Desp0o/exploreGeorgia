//
//  ExploreViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 15.01.25.
//

import Combine
import FirebaseFirestore

final class ExploreViewModel: ObservableObject {
  private let firebaseManager: FirebaseFetchingServicePorotocol
  @Published var fetchedPlaces: [SightSeenModel] = []
  @Published var isLoading = true
  @Published var isFetching = false
  
  init(
    firebaseManager: FirebaseFetchingServicePorotocol = FirebaseFetchingService()
  ) {
    self.firebaseManager = firebaseManager
  }
  
  func fetchData(pageSize: Int) {
    isLoading = true
    
    Task {
      do {
        let (places, _, _): ([SightSeenModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchCollectionFromFirebase(
          collectionName: .usersPlace,
          pageSize: pageSize,
          lastDocument: nil,
          userBucketList: [""]
        )
        
        await MainActor.run {
          fetchedPlaces = places
          isLoading = false
          isFetching = false
        }
      } catch {
        print(error.localizedDescription)
        await MainActor.run {
          isLoading = false
          isFetching = false
        }
      }
    }
  }
}
