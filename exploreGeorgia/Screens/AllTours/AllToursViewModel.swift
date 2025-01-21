//
//  AllToursViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 20.01.25.
//

import Firebase

final class AllToursViewModel: ObservableObject {
  private let firebaseManager: FirebaseFetchingServicePorotocol
  @Published var fetchedData: [TourModel] = []
  @Published var isLoading = true
  
  init(firebaseManager: FirebaseFetchingServicePorotocol = FirebaseFetchingService()) {
    self.firebaseManager = firebaseManager
  }
  
  func fetchTours(pageSize: Int) {
    Task {
      do {
        let (places, _, _): ([TourModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchPlaces(
          collectionName: "tours",
          pageSize: pageSize,
          lastDocument: nil,
          userBucketList: [""]
        )
        
        await MainActor.run {
          fetchedData = places
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
