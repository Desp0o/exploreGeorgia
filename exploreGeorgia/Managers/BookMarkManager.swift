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
  @Published var isError = false
  
  init(userManager: UserManager = UserManager()) {
    self.userManager = userManager
  }
  
  func savePlaceInBookmark(placeId: String, isBookmarked: Bool) {
    isError = false
    
    Task {
      do {
        try await toggleBookmark(placeId: placeId, isBookmarked: isBookmarked)
      } catch {
        await MainActor.run {
          isError = true
        }
      }
    }
  }
}

extension BookMarkManager: BookmarkActivityProtocol {
  func toggleBookmark(placeId: String, isBookmarked: Bool) async throws {
    guard let userId = Auth.auth().currentUser?.uid else {
      return
    }
    
    let userRef = Firestore.firestore().collection("users").document(userId)
    
    do {
      if isBookmarked {
        try await userRef.updateData([
          "bucketList": FieldValue.arrayRemove([placeId])
        ])
      } else {
        try await userRef.updateData([
          "bucketList": FieldValue.arrayUnion([placeId])
        ])
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
    
    let placesQuery = db.collection(collectionName.rawValue)
      .limit(to: pageLimit)
    let placesSnapshot = try await placesQuery.getDocuments()
    
    let documents: [T] = placesSnapshot.documents.compactMap { document in
      autoreleasepool {
        guard let id = document.data()["id"] as? String, bucketList.contains(id) else {
          return nil
        }
        return try? document.data(as: T.self)
      }
    }
    
    return documents
  }
}
