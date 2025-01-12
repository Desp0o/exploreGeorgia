//
//  MainViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import FirebaseFirestore

final class MainViewModel: ObservableObject {
  private let db = Firestore.firestore()
  @Published var placesFromApp: [SightSeenModel] = []
  
  init() {
    getAppPLaces()
  }
  
  private func getAppPLaces() {
    Task {
      do {
        let data = try await fetchPlaces()
        print("🚀 Fetched \(data.count) places")
        
        await MainActor.run {
          placesFromApp = data
          print(placesFromApp)
        }
      } catch {
        print("❌ Error in getAppPlaces:", error)
      }
    }
  }
  
  private func fetchPlaces() async throws -> [SightSeenModel] {
    let collectionRef = db.collection("placesFromApp")
    do {
      let snapshot = try await collectionRef.getDocuments()
      return try snapshot.documents.compactMap { document in
        do {
          let model = try document.data(as: SightSeenModel.self)
          return model
        } catch {
          throw error
        }
      }
    } catch {
      throw error
    }
  }
}
