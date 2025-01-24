//
//  FoodViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 24.01.25.
//

import Combine

final class FoodViewModel: ObservableObject {
  private let firebaseManager: FirebaseSimpleCollectionFetchProtocol
  @Published var resturantsData: [ResturantModel] = []
  @Published var isLoading = true
  
  init(firebaseManager: FirebaseSimpleCollectionFetchProtocol = FirebaseFetchingService()) {
    self.firebaseManager = firebaseManager
    
    fetchData(limit: 10)
  }
  
  func fetchData(limit: Int) {
    Task {
      do {
        let result: [ResturantModel] = try await firebaseManager.fetchCollection(collectionName: .resturant, limit: limit)
        
        await MainActor.run {
          resturantsData = result
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
