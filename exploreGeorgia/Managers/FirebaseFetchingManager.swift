//
//  FirebaseFetchingManager.swift
//  exploreGeorgia
//
//  Created by Despo on 15.01.25.
//

protocol IdentifiableAndBookmarkable {
  var id: String? { get }
  var isBookmarked: Bool? { get set }
}

import FirebaseFirestore
import FirebaseStorage

protocol FirebaseFetchingServicePorotocol {
  func fetchCollectionFromFirebase<T: Codable & IdentifiableAndBookmarkable>(
    collectionName: FirebaseCollectionEnum,
    pageSize: Int,
    lastDocument: DocumentSnapshot?,
    userBucketList: [String]
  ) async throws -> (places: [T], lastDocument: DocumentSnapshot?, hasMoreData: Bool)
}

protocol FirebasePhotoUrlGeneratorProtocol {
  func generateFirebasePhotoURL(image: UIImage, dbName: String, Id: String) async throws -> String
}

protocol FirebaseSinglePlaceGenericProtocol {
  func fetchSinglePlaceGeneric<T: Decodable>(with id: String, and collection: FirebaseCollectionEnum) async throws -> T
}
protocol FirebaseSimpleCollectionFetchProtocol {
  func fetchCollection<T: Decodable>(collectionName: FirebaseCollectionEnum, limit: Int) async throws -> [T]
}


final class FirebaseFetchingService: FirebaseFetchingServicePorotocol {
  let db = Firestore.firestore()
  
  func fetchCollectionFromFirebase<T: Codable & IdentifiableAndBookmarkable>(
    collectionName: FirebaseCollectionEnum,
    pageSize: Int,
    lastDocument: DocumentSnapshot?,
    userBucketList: [String]
  ) async throws -> (places: [T], lastDocument: DocumentSnapshot?, hasMoreData: Bool) {
    let collectionRef = db.collection(collectionName.rawValue).limit(to: pageSize + 1)
    let query: Query
    
    if let lastDocument = lastDocument {
      query = collectionRef.start(afterDocument: lastDocument)
    } else {
      query = collectionRef
    }
    
    let snapshot = try await query.getDocuments()
    let documents = snapshot.documents
    
    let hasMoreData = documents.count > pageSize
    
    let documentsToProcess = hasMoreData ? Array(documents.prefix(pageSize)) : documents
    
    let newPlaces = try documentsToProcess.compactMap { document -> T? in
      var model = try document.data(as: T.self)
      if let id = model.id {
        model.isBookmarked = userBucketList.contains(id)
      }
      return model
    }
    
    return (places: newPlaces, lastDocument: documentsToProcess.last, hasMoreData: hasMoreData)
  }
}

extension FirebaseFetchingService: FirebasePhotoUrlGeneratorProtocol {
  func generateFirebasePhotoURL(image: UIImage, dbName: String, Id: String) async throws -> String {
    guard let imageData = image.jpegData(compressionQuality: 0.2) else {
      throw NSError(domain: "Image Conversion Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data"])
    }
    
    let storageRef = Storage.storage().reference().child("dbName/\(Id).jpg")
    
    do {
      let _ = try await storageRef.putDataAsync(imageData)
    } catch {
      throw error
    }
    
    do {
      let downloadURL = try await storageRef.downloadURL()
      
      return downloadURL.absoluteString
    } catch {
      throw error
    }
  }
}

extension FirebaseFetchingService: FirebaseSinglePlaceGenericProtocol {
  func fetchSinglePlaceGeneric<T: Decodable>(with id: String, and collection: FirebaseCollectionEnum) async throws -> T {
    let documentRef = db.collection(collection.rawValue).document(id)
    
    do {
      let documentSnapshot = try await documentRef.getDocument()
      guard documentSnapshot.exists else {
        throw NSError(domain: "fetchPlace", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found"])
      }
      return try documentSnapshot.data(as: T.self)
    } catch {
      throw error
    }
  }
}

extension FirebaseFetchingService: FirebaseSimpleCollectionFetchProtocol {
  func fetchCollection<T: Decodable>(collectionName: FirebaseCollectionEnum, limit: Int) async throws -> [T] {
    let db = Firestore.firestore()
    let querySnapshot = try await db.collection(collectionName.rawValue).limit(to: limit).getDocuments()
    
    return try querySnapshot.documents.map { document in
      try document.data(as: T.self)
    }
  }
}
