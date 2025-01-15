//
//  FirebaseFetchingManager.swift
//  exploreGeorgia
//
//  Created by Despo on 15.01.25.
//

import FirebaseFirestore

protocol FirebaseFetchingServicePorotocol {
  func fetchPlaces(
    collectionName: String,
    pageSize: Int,
    lastDocument: DocumentSnapshot?,
    userBucketList: [String]
  ) async throws -> (places: [SightSeenModel], lastDocument: DocumentSnapshot?, hasMoreData: Bool)
}

protocol FirebaseSingleElementFetching: AnyObject {
  func fetchRandomDocument(collectionName: String) async throws -> DocumentSnapshot?
}

final class FirebaseFetchingService: FirebaseFetchingServicePorotocol {
  private let db = Firestore.firestore()
  
  func fetchPlaces(
    collectionName: String,
    pageSize: Int,
    lastDocument: DocumentSnapshot?,
    userBucketList: [String]
  ) async throws -> (places: [SightSeenModel], lastDocument: DocumentSnapshot?, hasMoreData: Bool) {
    let collectionRef = db.collection(collectionName).limit(to: pageSize)
    let query: Query
    
    if let lastDocument = lastDocument {
      query = collectionRef.start(afterDocument: lastDocument)
    } else {
      query = collectionRef
    }
    
    let snapshot = try await query.getDocuments()
    let newPlaces = try snapshot.documents.compactMap { document -> SightSeenModel? in
      var model = try document.data(as: SightSeenModel.self)
      if let id = model.id {
        model.isBookmarked = userBucketList.contains(id)
      }
      return model
    }
    
    let hasMoreData = !snapshot.documents.isEmpty && snapshot.documents.count == pageSize
    return (places: newPlaces, lastDocument: snapshot.documents.last, hasMoreData: hasMoreData)
  }
  }

extension FirebaseFetchingService: FirebaseSingleElementFetching {
  func fetchRandomDocument(collectionName: String) async throws -> DocumentSnapshot? {
    // 1. Get the total document count
    let querySnapshot = try await db.collection(collectionName).getDocuments()
    let documentCount = querySnapshot.documents.count
    
    // 2. Generate a random index
    let randomIndex = Int.random(in: 0..<documentCount)
    
    // 3. Fetch the document at the random index
    let query = db.collection(collectionName).limit(to: randomIndex + 1)
    let snapshot = try await query.getDocuments()
    
    // Return the document at the random index
    return snapshot.documents[randomIndex]
  }
}

  // Usage Example
//  let fetcher = RandomDocumentFetcher()
//
//  Task {
//      do {
//          if let randomDocument = try await fetcher.fetchRandomDocument() {
//              print("Random Document Data: \(randomDocument.data())")
//          } else {
//              print("No documents found in the collection.")
//          }
//      } catch {
//          print("Error fetching random document: \(error)")
//      }
//  }


