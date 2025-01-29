//
//  AllToursViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 20.01.25.
//

import Firebase
import FirebaseFirestore

@MainActor
final class AllToursViewModel: ObservableObject {
  private let firebaseManager: FirebaseFetchingServicePorotocol
  private var lastDocument: DocumentSnapshot? = nil
  private var hasMoreData = true
  private var isFetching = false
  
  @Published var fetchedData: [TourModel] = []
  @Published var isLoading = true
  
  init(firebaseManager: FirebaseFetchingServicePorotocol = FirebaseFetchingService()) {
    self.firebaseManager = firebaseManager
    
    fetchTours()
  }
  
  func fetchTours() {
    guard !isFetching && hasMoreData else { return }
    isFetching = true
    
    Task {
      do {
        let (places, newLastDocument, hasMore): ([TourModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchCollectionFromFirebase(
          collectionName: .tours,
          pageSize: 10,
          lastDocument: lastDocument,
          userBucketList: [""]
        )
        
        lastDocument = newLastDocument
        hasMoreData = hasMore
        fetchedData.append(contentsOf: places)
        isLoading = false
        isFetching = false
      } catch {
        isLoading = false
        isFetching = false
      }
    }
  }
}
