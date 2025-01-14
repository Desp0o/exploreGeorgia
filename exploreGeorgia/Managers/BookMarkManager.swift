//
//  BookMarkManager.swift
//  exploreGeorgia
//
//  Created by Despo on 13.01.25.
//

import Firebase
import FirebaseAuth

protocol BookmarkActivityProtocol: AnyObject {
  func toggleBookmark(placeId: String, isBookmarked: Bool) async throws
}

final class BookMarkManager: ObservableObject, BookmarkActivityProtocol {
  
  func savePlaceInBookmark(placeId: String, isBookmarked: Bool) {
    Task {
      do {
        try await toggleBookmark(placeId: placeId, isBookmarked: isBookmarked)
      } catch {
        throw error
      }
    }
  }

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
          print("Error updating bookmark: \(error.localizedDescription)")
      }
  }

}
