//
//  FoodViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 24.01.25.
//

import Combine

@MainActor
final class FoodViewModel: ObservableObject {
  private let firebaseManager: FirebaseSimpleCollectionFetchProtocol
  @Published var resturantsData: [ResturantModel] = []
  @Published var drinksData: [ResturantModel] = []
  @Published var bakeryData: [ResturantModel] = []
  @Published var isLoading = true
  
  init(firebaseManager: FirebaseSimpleCollectionFetchProtocol = FirebaseFetchingService()) {
    self.firebaseManager = firebaseManager
    
    fetchData(collectionName: .resturant, limit: 4, assignTo: \.resturantsData)
    fetchData(collectionName: .drinks, limit: 4, assignTo: \.drinksData)
    fetchData(collectionName: .bakery, limit: 4, assignTo: \.bakeryData)
  }
  
  private func fetchData(
    collectionName: FirebaseCollectionEnum,
    limit: Int,
    assignTo keyPath: ReferenceWritableKeyPath<FoodViewModel, [ResturantModel]>
  ) {
    Task {
      do {
        let result: [ResturantModel] = try await firebaseManager.fetchCollection(collectionName: collectionName, limit: limit)
        
        self[keyPath: keyPath] = result
        isLoading = false
      } catch {
        isLoading = false
      }
    }
  }
}
