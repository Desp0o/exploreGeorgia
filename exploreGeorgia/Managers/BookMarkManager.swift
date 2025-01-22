//
//  BookMarkManager.swift
//  exploreGeorgia
//
//  Created by Despo on 13.01.25.
//

import Firebase
import FirebaseAuth

protocol BookmarkActivityProtocol {
  func toggleBookmark(placeId: String, isBookmarked: Bool) async throws
}

protocol CheckBookmarkProtocol {
  func checkIfBookmarked(placeId: String, currentUser: UserModel) async throws -> Bool
}

protocol GetDocumetnsFromBucketListProtocol {
  func getDocumentsFromBucketList<T: Codable>(
    userId: String,
    pageLimit: Int,
    collectionName: FirebaseCollectionEnum
  ) async throws -> [T]
}

final class BookMarkManager: ObservableObject {
  private let userManager: UserManager
  
  init(userManager: UserManager = UserManager()) {
    self.userManager = userManager
  }
  
  func savePlaceInBookmark(placeId: String, isBookmarked: Bool) {
    Task {
      do {
        try await toggleBookmark(placeId: placeId, isBookmarked: isBookmarked)
      } catch {
        print("Error: \(error.localizedDescription)")
      }
    }
  }
}

extension BookMarkManager: BookmarkActivityProtocol {
  func toggleBookmark(placeId: String, isBookmarked: Bool) async throws {
    guard let userId = Auth.auth().currentUser?.uid else {
      print("User not logged in")
      return
    }
    
    let userRef = Firestore.firestore().collection("users").document(userId)
    
    do {
      if isBookmarked {
        try await userRef.updateData([
          "bucketList": FieldValue.arrayRemove([placeId])
        ])
        print("Bookmark removed successfully")
      } else {
        try await userRef.updateData([
          "bucketList": FieldValue.arrayUnion([placeId])
        ])
        print("Bookmark added successfully")
      }
    } catch {
      throw error
    }
  }
  
}

extension BookMarkManager: CheckBookmarkProtocol {
  func checkIfBookmarked(placeId: String, currentUser: UserModel) async throws -> Bool {
    return currentUser.bucketList.contains(placeId)
  }
}

extension BookMarkManager: GetDocumetnsFromBucketListProtocol {
  func getDocumentsFromBucketList<T: Codable>(
    userId: String,
    pageLimit: Int,
    collectionName: FirebaseCollectionEnum
  ) async throws -> [T] {
    let db = Firestore.firestore()
    let userDocRef = db.collection("users").document(userId)
    let userDoc = try await userDocRef.getDocument()
    
    guard let bucketList = userDoc.data()?["bucketList"] as? [String], !bucketList.isEmpty else {
      return []
    }
    
    let placesQuery = db.collection(collectionName.rawValue).whereField("id", in: bucketList).limit(to: pageLimit)
    let placesSnapshot = try await placesQuery.getDocuments()
    
    let documents: [T] = try placesSnapshot.documents.compactMap { document in
      try document.data(as: T.self)
    }
    return documents
  }
}
