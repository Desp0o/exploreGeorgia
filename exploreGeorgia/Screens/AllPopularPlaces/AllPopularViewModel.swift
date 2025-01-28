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
  var isFetching = false
  var lastDocument: DocumentSnapshot? = nil
  var hasMoreData = true
  
  init(
    userManager: GetFirebaseUserProtocol = UserManager(),
    firebaseManager: FirebaseFetchingServicePorotocol = FirebaseFetchingService()
  ) {
    self.userManager = userManager
    self.firebaseManager = firebaseManager
  }
  
  func fetchData() {
    guard !isFetching && hasMoreData else { return }
    isFetching = true
    
    Task {
      do {
        let userID = Auth.auth().currentUser?.uid
        let data = try await userManager.getFirebaseUser(with: userID ?? "")
        
        await MainActor.run {
          user = data
        }
        
        let (places, newLastDocument, hasMore): ([SightSeenModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchCollectionFromFirebase(
          collectionName: .appPlace,
          pageSize: 10,
          lastDocument: lastDocument,
          userBucketList: user?.bucketList ?? [""]
        )
        
        await MainActor.run {
          lastDocument = newLastDocument
          hasMoreData = hasMore
          fetchedData.append(contentsOf: places)
          isFetching = false
          isLoading = false
        }
      } catch {
        await MainActor.run {
          isLoading = false
          isFetching = false
        }
      }
    }
  }
}
