//
//  AllBookmarkViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 14.01.25.
//

import FirebaseFirestore
import FirebaseAuth

class AllBookmarkViewModel: ObservableObject {
  @Published var bookmarkedPlaces: [SightSeenModel] = []
  @Published var isFetching = false
  @Published var isLoaded = true
  private let bookmarkManager = BookMarkManager()
  private var lastDocument: DocumentSnapshot?
  private var hasMoreData = true
  private let pageSize = 4
  private let db = Firestore.firestore()
  
  init() {
    Task {
      await fetchNextPage()
    }
  }
  
  func loadMoreIfNeeded() {
    guard !isFetching && hasMoreData else { return }
    
    Task {
      await fetchNextPage()
    }
  }
  
  func fetchNextPage() async {
    guard !isFetching, hasMoreData else { return }
    
    await MainActor.run {
      isFetching = true
    }
    
    do {
      let bucketList = try await fetchBucketList()
      
      guard !bucketList.isEmpty else {
        await MainActor.run {
          self.hasMoreData = false
          self.isFetching = false
          self.isLoaded = false
        }
        return
      }
      
      var query = db.collection("placesFromApp")
        .whereField(FieldPath.documentID(), in: bucketList)
        .limit(to: pageSize)
      
      if let lastDocument {
        query = query.start(afterDocument: lastDocument)
      }
      
      let snapshot = try await query.getDocuments()
      
      let newPlaces = try snapshot.documents.compactMap { doc -> SightSeenModel? in
        var model = try Firestore.Decoder().decode(SightSeenModel.self, from: doc.data())
        if let id = model.id {
          model.isBookmarked = bucketList.contains(id)
        }
        return model
      }
      
      await MainActor.run {
        self.bookmarkedPlaces.append(contentsOf: newPlaces)        
        self.lastDocument = snapshot.documents.last
        self.hasMoreData = snapshot.documents.count == self.pageSize
      }
    } catch {
      print("Error fetching places: \(error.localizedDescription)")
    }
    
    await MainActor.run {
      isFetching = false
      isLoaded = false
    }
  }
  
  func fetchBucketList() async throws -> [String] {
    guard let user = Auth.auth().currentUser else {
      return []
    }
    
    let snapshot = try await db.collection("users")
      .document(user.uid)
      .getDocument()
    
    return snapshot.get("bucketList") as? [String] ?? []
  }
  
  func removeBookmark(index: IndexSet) {
    guard let firstIndex = index.first else { return }
    
    let place = bookmarkedPlaces[firstIndex]
    
    bookmarkedPlaces.remove(atOffsets: index)
    
    Task {
      do {
        try await bookmarkManager.toggleBookmark(placeId: place.id ?? "", isBookmarked: place.isBookmarked ?? true)
      } catch {
        print("Failed to toggle bookmark: \(error.localizedDescription)")
      }
    }
  }
}
