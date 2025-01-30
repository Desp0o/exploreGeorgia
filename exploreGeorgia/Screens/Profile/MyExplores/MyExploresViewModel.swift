//
//  MyExploresViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 17.01.25.
//

import FirebaseFirestore
import FirebaseAuth

protocol MyExploresDelegate: AnyObject {
  func didDataLoaded()
}

protocol MyExploresLoadingDelegate: AnyObject {
  func didLoadingStopped()
}

protocol MyExploresErrorDelegate: AnyObject {
  func didErrorOccurred()
}

final class MyExploresViewModel {
  private var lastDocument: DocumentSnapshot?
  private let db = Firestore.firestore()
  private var hasMoreData = true
  private let firebaseManager: FetchSingleUserExploredPlacesProtocol
  weak var exploresDelegate: MyExploresDelegate?
  weak var loadingDelegate: MyExploresLoadingDelegate?
  weak var errorDeleage: MyExploresErrorDelegate?
  var fetchedPlaces: [SightSeenModel] = []
  var isLoading = true
  var errorMessage = ""
  private var userID = ""
  
  init(firebaseManager: FetchSingleUserExploredPlacesProtocol = FirebaseFetchingService()) {
    self.firebaseManager = firebaseManager
    fetchData(pageSize: 10)
  }
  
  func fetchData(pageSize: Int) {
    guard hasMoreData else { return }
    
    Task {
      do {
        await MainActor.run {
          loadingDelegate?.didLoadingStopped()
        }
        
        let userId = Auth.auth().currentUser?.uid
        
        let result = try await firebaseManager.fetchUserPlaces(
          userId: userId ?? "",
          pageSize: pageSize,
          lastDocument: lastDocument
        )
        
        await MainActor.run {
          userID = userId ?? ""
          lastDocument = result.lastDocument
          hasMoreData = result.hasMoreData
          
          fetchedPlaces.append(contentsOf: result.places)
          
          exploresDelegate?.didDataLoaded()
          isLoading = false
          loadingDelegate?.didLoadingStopped()
        }
      } catch {
        await MainActor.run {
          isLoading = false
          loadingDelegate?.didLoadingStopped()
          
          errorMessage = error.localizedDescription
          errorDeleage?.didErrorOccurred()
        }
      }
    }
  }
  
  func deletePlaceFromDataBase(placeId: String) async throws {
    let db = Firestore.firestore()
    let placesFromUserRef = db.collection("usersPlaces").document(placeId)
    let userRef = db.collection("users").document(userID)
    
    do {
      _ = try await db.runTransaction { (transaction, errorPointer) -> Any? in
        let userSnapshot: DocumentSnapshot
        do {
          userSnapshot = try transaction.getDocument(userRef)
        } catch let fetchError as NSError {
          errorPointer?.pointee = fetchError
          return nil
        }
        
        guard var explored = userSnapshot.data()?["explored"] as? [String] else {
          let error = NSError(domain: "MissingExploredArray", code: 404, userInfo: nil)
          errorPointer?.pointee = error
          return nil
        }
        
        if let index = explored.firstIndex(of: placeId) {
          explored.remove(at: index)
          transaction.updateData(["explored": explored], forDocument: userRef)
          transaction.deleteDocument(placesFromUserRef)
        }
        
        return nil
      }
    } catch {
      throw error
    }
  }
  
  func removePlace(index: Int) {
    let currentItem = fetchedPlaces[index]
    
    Task {
      do {
        try await deletePlaceFromDataBase(placeId: currentItem.id ?? "")
      } catch {
        await MainActor.run {
          errorMessage = error.localizedDescription
          errorDeleage?.didErrorOccurred()
        }
      }
    }
  }
}
