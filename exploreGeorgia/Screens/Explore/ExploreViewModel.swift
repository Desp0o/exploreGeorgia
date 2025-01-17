//
//  ExploreViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 15.01.25.
//

import Combine

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
    isFetching = true
    Task {
      do {
        let result = try await firebaseManager.fetchPlaces(
          collectionName: "usersPlaces",
          pageSize: pageSize,
          lastDocument: nil,
          userBucketList: [""]
        )
        
        await MainActor.run {
          fetchedPlaces = result.places
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
