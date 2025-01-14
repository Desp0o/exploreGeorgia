//
//  PlaceDetailsViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import Combine
import Foundation
import FirebaseFirestore
import SwiftUI

final class PlaceDetailsViewModel: ObservableObject {
  @Published var currentPlace: SightSeenModel? = nil
  @Published var isBookMarked = false
  private let db = Firestore.firestore()
  private let userManager: GetCurrentUserProtocol
  
  let gridItems = [
    GridItem(.fixed(50), spacing: 20),
    GridItem(.fixed(50), spacing: 20),
    GridItem(.fixed(50), spacing: 20),
    GridItem(.fixed(50), spacing: 20),
    GridItem(.fixed(50), spacing: 20),
  ]
  
  init(
    userManager: GetCurrentUserProtocol = UserManager()
  ) {
    self.userManager = userManager
  }
  
  func fetchSinglePlaceByID(by id: String) {
    Task {
      do {
        let data = try await fetchPlace(by: id)
        
        await MainActor.run {
          currentPlace = data
        }
        
        await checkIfBookmarked(placeId: id)
      } catch {
        print("Error fetching place: \(error.localizedDescription)")
      }
    }
  }
  
  private func fetchPlace(by id: String) async throws -> SightSeenModel {
    let documentRef = db.collection("placesFromApp").document(id)
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
  
  private func checkIfBookmarked(placeId: String) async {
    do {
      guard let currentUser = try await userManager.getCurrentUser() else {
        print("No user data available")
        return
      }
      
      await MainActor.run {
        isBookMarked = currentUser.bucketList.contains(placeId)
      }
    } catch {
      print("Error checking bookmark status: \(error.localizedDescription)")
    }
  }
}
