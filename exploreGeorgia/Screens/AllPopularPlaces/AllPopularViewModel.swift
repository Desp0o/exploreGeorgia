//
//  AllPopularViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 15.01.25.
//

import FirebaseFirestore

final class AllPopularViewModel: ObservableObject {
  @Published var fetchedData: [SightSeenModel] = []
  @Published var isLoading = false
  private let userManager: GetCurrentUserProtocol
  private let firebaseManager: FirebaseFetchingServicePorotocol
  private var user: UserModel? = nil
  private let collectionName = "placesFromApp"
  
  init(
    userManager: GetCurrentUserProtocol = UserManager(),
    firebaseManager: FirebaseFetchingServicePorotocol = FirebaseFetchingService()
  ) {
    self.userManager = userManager
    self.firebaseManager = firebaseManager
  }
  
  func fetchData(pageSize: Int) {
    isLoading = true
    
    Task {
      do {
        let data = try await userManager.getCurrentUser()
        
        await MainActor.run {
          user = data
        }
        
        let result = try await firebaseManager.fetchPlaces(
          collectionName: "placesFromApp",
          pageSize: pageSize,
          lastDocument: nil,
          userBucketList: user?.bucketList ?? [""]
        )
        
        await MainActor.run {
          fetchedData = result.places
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
