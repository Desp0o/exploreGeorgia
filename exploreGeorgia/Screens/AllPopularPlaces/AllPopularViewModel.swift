//
//  AllPopularViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 15.01.25.
//

import FirebaseFirestore
import FirebaseAuth

@MainActor
final class AllPopularViewModel: ObservableObject {
  @Published var fetchedData: [SightSeenModel] = []
  @Published var isLoading = true
  private let userManager: GetFirebaseUserProtocol
  private let firebaseManager: FirebaseFetchingServicePorotocol
  var isFetching = false
  var lastDocument: DocumentSnapshot? = nil
  var hasMoreData = true
  
  init(
    userManager: GetFirebaseUserProtocol = UserManager(),
    firebaseManager: FirebaseFetchingServicePorotocol = FirebaseFetchingService()
  ) {
    self.userManager = userManager
    self.firebaseManager = firebaseManager
    
    fetchData()
  }
  
  func fetchData() {
    guard !isFetching && hasMoreData else { return }
    isFetching = true
    
    Task {
      do {
        let (places, newLastDocument, hasMore): ([SightSeenModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchCollectionFromFirebase(
          collectionName: .appPlace,
          pageSize: 10,
          lastDocument: lastDocument,
          userBucketList: [""]
        )
        
        lastDocument = newLastDocument
        hasMoreData = hasMore
        fetchedData.append(contentsOf: places)
        isFetching = false
        isLoading = false
        
      } catch {
        isLoading = false
        isFetching = false
      }
    }
  }
}
