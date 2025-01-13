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
  private let db = Firestore.firestore()
  @Published var currentPlace: SightSeenModel? = nil
  
  let gridItems = [
    GridItem(.fixed(50), spacing: 20),
    GridItem(.fixed(50), spacing: 20),
    GridItem(.fixed(50), spacing: 20),
    GridItem(.fixed(50), spacing: 20),
    GridItem(.fixed(50), spacing: 20),
  ]
  
  func fetchSinglePlaceByID(by id: String) {
    Task {
      do {
        let data = try await fetchPlace(by: id)
        print("🚀")
        
        await MainActor.run {
          currentPlace = data
        }
        
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  
  private func fetchPlace(by id: String) async throws -> SightSeenModel {
    let documentRef = db.collection("placesFromApp").document(id)
    do {
      let documentSnapshot = try await documentRef.getDocument()
      guard documentSnapshot.data() != nil else {
        throw NSError(domain: "fetchPlace", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found"])
      }
      return try documentSnapshot.data(as: SightSeenModel.self)
    } catch {
      throw error
    }
  }
  
}
