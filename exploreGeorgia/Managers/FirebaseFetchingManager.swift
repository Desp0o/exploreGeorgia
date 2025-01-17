//
//  FirebaseFetchingManager.swift
//  exploreGeorgia
//
//  Created by Despo on 15.01.25.
//

import FirebaseFirestore
import FirebaseStorage

protocol FirebaseFetchingServicePorotocol {
  func fetchPlaces(
    collectionName: String,
    pageSize: Int,
    lastDocument: DocumentSnapshot?,
    userBucketList: [String]
  ) async throws -> (places: [SightSeenModel], lastDocument: DocumentSnapshot?, hasMoreData: Bool)
}

protocol FirebaseSinglePlaceFetchProtocol {
  func fetchPlace(with id: String, and collection: String) async throws -> SightSeenModel
}

protocol FirebaseSingleElementFetching {
  func fetchRandomDocument(collectionName: String) async throws -> DocumentSnapshot?
}

protocol FirebaseSingleUserFetchProtocol {
  func getUser(with userID: String) async throws -> UserModel?
}

protocol FirebasePhotoUrlGeneratorProtocol {
  func generateFirebasePhotoURL(image: UIImage, dbName: String, Id: String) async throws -> String
}


final class FirebaseFetchingService: FirebaseFetchingServicePorotocol {
  let db = Firestore.firestore()
  
  func fetchPlaces(
    collectionName: String,
    pageSize: Int,
    lastDocument: DocumentSnapshot?,
    userBucketList: [String]
  ) async throws -> (places: [SightSeenModel], lastDocument: DocumentSnapshot?, hasMoreData: Bool) {
    let collectionRef = db.collection(collectionName).limit(to: pageSize + 1)
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
    
    let newPlaces = try documentsToProcess.compactMap { document -> SightSeenModel? in
      var model = try document.data(as: SightSeenModel.self)
      if let id = model.id {
        model.isBookmarked = userBucketList.contains(id)
      }
      return model
    }
    
    return (places: newPlaces, lastDocument: documentsToProcess.last, hasMoreData: hasMoreData)
  }  }

extension FirebaseFetchingService: FirebaseSinglePlaceFetchProtocol {
  func fetchPlace(with id: String, and collection: String) async throws -> SightSeenModel {
    let documentRef = db.collection(collection).document(id)
    
    do {
      let documentSnapshot = try await documentRef.getDocument()
      guard documentSnapshot.exists else {
        throw NSError(domain: "fetchPlace", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found"])
      }
      return try documentSnapshot.data(as: SightSeenModel.self)
    } catch {
      throw error
    }
  }
}

extension FirebaseFetchingService: FirebaseSingleElementFetching {
  func fetchRandomDocument(collectionName: String) async throws -> DocumentSnapshot? {
    let querySnapshot = try await db.collection(collectionName).getDocuments()
    let documentCount = querySnapshot.documents.count
    
    let randomIndex = Int.random(in: 0..<documentCount)
    
    let query = db.collection(collectionName).limit(to: randomIndex + 1)
    let snapshot = try await query.getDocuments()
    
    return snapshot.documents[randomIndex]
  }
}

extension FirebaseFetchingService: FirebaseSingleUserFetchProtocol {
  func getUser(with userID: String) async throws -> UserModel? {
    let document = try await db.collection("users").document(userID).getDocument()
    
    if document.exists, let data = document.data() {
      let avatar = data["photoURL"] as? String ?? ""
      let firstName = data["firstName"] as? String ?? ""
      let lastName = data["lastName"] as? String ?? ""
      let email = data["email"] as? String ?? ""
      let gender = data["gender"] as? String ?? ""
      let points = data["points"] as? Int ?? 0
      let explored = data["explored"] as? [String] ?? []
      let bucketList = data["bucketList"] as? [String] ?? []
      let achievement = data["achievement"] as? [String] ?? []
      let createdAt = data["createdAt"] as? Timestamp ?? Timestamp()
      
      return UserModel(
        avatar: avatar,
        firstName: firstName,
        lastName: lastName,
        email: email,
        gender: gender,
        points: points,
        explored: explored,
        bucketList: bucketList,
        achievement: achievement,
        createdAt: createdAt
      )
    } else {
      throw FetchedUserErrors.userDoesntExist(message: "User document does not exist.")
    }
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
