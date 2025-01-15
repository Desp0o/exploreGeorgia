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
  @Published var isFetching = false
  @Published var isLoaded = true
  @Published var errorMessages = ""
  private let bookmarkManager: BookmarkActivityProtocol
  private let db = Firestore.firestore()
  private var user: UserModel? = nil
  
  init(
    bookmarkManager: BookmarkActivityProtocol = BookMarkManager()
  ) {
    self.bookmarkManager = bookmarkManager
  }
  
  func fetchData(pageLimit: Int) {
    Task {
      do {
        let userID = Auth.auth().currentUser?.uid
        guard let id = userID else { return }
        
        let result = try await getPlacesFromBucketList(userId: id, pageLimit: pageLimit)
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
  
  func getPlacesFromBucketList(userId: String, pageLimit: Int) async throws -> [SightSeenModel] {
    let userDocRef = db.collection("users").document(userId)
    let userDoc = try await userDocRef.getDocument()
    
    guard let bucketList = userDoc.data()?["bucketList"] as? [String], !bucketList.isEmpty else {
      return []
    }
    
    let placesQuery = db.collection("placesFromApp").whereField("id", in: bucketList).limit(to: pageLimit)
    let placesSnapshot = try await placesQuery.getDocuments()
    
    let places = placesSnapshot.documents.compactMap { document -> SightSeenModel? in
      let data = document.data()
      
      return SightSeenModel(
        id: document.documentID,
        cover: data["cover"] as? String ?? "",
        name: data["name"] as? String ?? "",
        region: data["region"] as? String ?? "",
        album: data["album"] as? [String] ?? [],
        description: data["description"] as? String ?? "",
        rating: data["rating"] as? String ?? "0.0",
        price: data["price"] as? Int ?? 0,
        adress: data["adress"] as? String ?? "",
        ratingCount: data["ratingCount"] as? Int ?? 0,
        latitude: data["latitude"] as? Double ?? 0.0,
        longitude: data["longitude"] as? Double ?? 0.0,
        isBookmarked: true
      )
    }
    return places
  }
  
  func removeBookmark(index: IndexSet) {
    guard let firstIndex = index.first else { return }
    let place = bookmarkedPlaces[firstIndex]
    bookmarkedPlaces.remove(atOffsets: index)
    
    Task {
      do {
        try await bookmarkManager.toggleBookmark(placeId: place.id ?? "", isBookmarked: place.isBookmarked ?? true)
      } catch {
        await MainActor.run {
          errorMessages = error.localizedDescription
        }
      }
    }
  }
}
