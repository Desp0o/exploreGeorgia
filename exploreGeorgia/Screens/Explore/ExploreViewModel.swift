//
//  ExploreViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 15.01.25.
//

import Combine

final class ExploreViewModel: ObservableObject {
  private let firebaseManager: FirebaseFetchingServicePorotocol
  private let userManager: GetCurrentUserProtocol
  
  @Published var fetchedPlaces: [SightSeenModel] = []
  private var user: UserModel? = nil
  
  init(
    firebaseManager: FirebaseFetchingServicePorotocol = FirebaseFetchingService(),
    userManager: GetCurrentUserProtocol = UserManager()
  ) {
    self.firebaseManager = firebaseManager
    self.userManager = userManager
  }
  
  func fetchData() {
    Task {
      do {
        let userData = try await userManager.getCurrentUser()
        
        await MainActor.run {
          user = userData
        }
        
        let result = try await firebaseManager.fetchPlaces(
          collectionName: "usersPlaces",
          pageSize: 10,
          lastDocument: nil,
          userBucketList: user?.bucketList ?? [""]
        )
        
        await MainActor.run {
          fetchedPlaces = result.places
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
