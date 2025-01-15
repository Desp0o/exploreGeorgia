//
//  MainViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import FirebaseFirestore

final class MainViewModel: ObservableObject {
  private let db = Firestore.firestore()
  private let userManager: GetCurrentUserProtocol
  private let firebaseManager: FirebaseFetchingServicePorotocol
  @Published var user: UserModel? = nil
  @Published var errorMessage = ""
  @Published var placesFromApp: [SightSeenModel] = []
  @Published var isLoading = false
  
  init(
    userManager: GetCurrentUserProtocol = UserManager(),
    firebaseManager: FirebaseFetchingServicePorotocol = FirebaseFetchingService()
  ) {
    self.userManager = userManager
    self.firebaseManager = firebaseManager
  }
  
  
  func getPopularPlaces() {
    isLoading = true
    Task {
      do {
        let data = try await userManager.getCurrentUser()
        
        await MainActor.run {
          user = data
        }
        
        let result = try await firebaseManager.fetchPlaces(
          collectionName: "placesFromApp",
          pageSize: 5,
          lastDocument: nil,
          userBucketList: user?.bucketList ?? [""]
        )
        
        await MainActor.run {
          placesFromApp = result.places
          isLoading = false
        }
      } catch {
        await MainActor.run {
          errorMessage = error.localizedDescription
          isLoading = false
        }
      }
    }
  }
}
