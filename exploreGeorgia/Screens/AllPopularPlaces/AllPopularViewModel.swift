//
//  AllPopularViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 15.01.25.
//

import FirebaseFirestore
import FirebaseAuth

final class AllPopularViewModel: ObservableObject {
  @Published var fetchedData: [SightSeenModel] = []
  @Published var isLoading = true
  private let userManager: GetFirebaseUserProtocol
  private let firebaseManager: FirebaseFetchingServicePorotocol
  private var user: UserModel? = nil
  private let collectionName = "placesFromApp"
  
  init(
    userManager: GetFirebaseUserProtocol = UserManager(),
    firebaseManager: FirebaseFetchingServicePorotocol = FirebaseFetchingService()
  ) {
    self.userManager = userManager
    self.firebaseManager = firebaseManager
  }
  
  func fetchData(pageSize: Int) {
    Task {
      do {
        let userID = Auth.auth().currentUser?.uid
        let data = try await userManager.getFirebaseUser(with: userID ?? "")
        
        await MainActor.run {
          user = data
        }
        
        let (places, _, _): ([SightSeenModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchCollectionFromFirebase(
          collectionName: .appPlace,
          pageSize: pageSize,
          lastDocument: nil,
          userBucketList: user?.bucketList ?? [""]
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
