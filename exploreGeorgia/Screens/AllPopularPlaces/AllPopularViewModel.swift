//
//  AllPopularViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 15.01.25.
//

import FirebaseFirestore

final class AllPopularViewModel: ObservableObject {
  private let userManager: GetCurrentUserProtocol
  private let firebaseManager: FirebaseFetchingServicePorotocol
  private var user: UserModel? = nil
  private let collectionName = "placesFromApp"
  private var lastDocument: DocumentSnapshot?
  var isFetching = false
  @Published var isLoading = false
  @Published var hasMoreData = true

  @Published var fetchedData: [SightSeenModel] = [] {
    didSet {
      print("fetchedData updated with \(fetchedData.count) items.  ❌")}
}
  
  
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
