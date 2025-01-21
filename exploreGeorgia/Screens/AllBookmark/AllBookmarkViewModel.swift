//
//  AllBookmarkViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 14.01.25.
//

import FirebaseFirestore
import FirebaseAuth

final class AllBookmarkViewModel: ObservableObject {
  @Published var bookmarkedPlaces: [SightSeenModel] = []
  @Published var bookmarkedTours: [TourModel] = []
  @Published var isFetching = false
  @Published var isLoaded = true
  @Published var errorMessages = ""
  @Published var pageSize = 10
  private let bookmarkManager: BookmarkActivityProtocol
  private let db = Firestore.firestore()
  private var user: UserModel? = nil
  var buttonsArray = ["app", "users", "tours"]
  
  init(
    bookmarkManager: BookmarkActivityProtocol = BookMarkManager()
  ) {
    self.bookmarkManager = bookmarkManager
    
    fetchData(pageLimit: pageSize, collectionName: "placesFromApp")
  }
  
  func fetchData(pageLimit: Int, collectionName: String) {
    Task {
      do {
        await MainActor.run {
          isLoaded = true
        }
        
        let userID = Auth.auth().currentUser?.uid
        guard let id = userID else { return }
        
        let result: [SightSeenModel] = try await getDocumentsFromBucketList(userId: id, pageLimit: pageLimit, collectionName: collectionName)
        await MainActor.run {
          bookmarkedPlaces = result
          
          isLoaded = false
        }
      } catch {
        await MainActor.run {
          isLoaded = false
          errorMessages = error.localizedDescription
        }
      }
    }
  }
  
  func fetchToursData(pageLimit: Int) {
    Task {
      do {
        await MainActor.run {
          isLoaded = true
        }
        
        let userID = Auth.auth().currentUser?.uid
        guard let id = userID else { return }
        
        let result: [TourModel] = try await getDocumentsFromBucketList(userId: id, pageLimit: pageLimit, collectionName: "tours")
        await MainActor.run {
          bookmarkedTours = result
          print(bookmarkedTours)
          isLoaded = false
        }
      } catch {
        await MainActor.run {
          isLoaded = false
          errorMessages = error.localizedDescription
        }
      }
    }
  }

  func getDocumentsFromBucketList<T: Codable>(
      userId: String,
      pageLimit: Int,
      collectionName: String
  ) async throws -> [T] {
      let userDocRef = db.collection("users").document(userId)
      let userDoc = try await userDocRef.getDocument()

      guard let bucketList = userDoc.data()?["bucketList"] as? [String], !bucketList.isEmpty else {
          return []
      }

      let placesQuery = db.collection(collectionName).whereField("id", in: bucketList).limit(to: pageLimit)
      let placesSnapshot = try await placesQuery.getDocuments()

      let documents: [T] = try placesSnapshot.documents.compactMap { document in
          try document.data(as: T.self)
      }
      return documents
  }
  
  func removeBookmark(index: IndexSet) {
    guard let firstIndex = index.first else { return }
    let place = bookmarkedPlaces[firstIndex]
    bookmarkedPlaces.remove(atOffsets: index)
    
    Task {
      do {
        try await bookmarkManager.toggleBookmark(placeId: place.id ?? "", isBookmarked: true)
      } catch {
        await MainActor.run {
          errorMessages = error.localizedDescription
        }
      }
    }
  }
  
  func removeTourBookmark(index: IndexSet) {
    guard let firstIndex = index.first else { return }
    let place = bookmarkedTours[firstIndex]
    bookmarkedTours.remove(atOffsets: index)
    
    Task {
      do {
        try await bookmarkManager.toggleBookmark(placeId: place.id ?? "", isBookmarked: true)
      } catch {
        await MainActor.run {
          errorMessages = error.localizedDescription
        }
      }
    }
  }

}
