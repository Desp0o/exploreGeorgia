//
//  MainViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import FirebaseFirestore

final class MainViewModel: ObservableObject {
  private let db = Firestore.firestore()
  private let userManager: GetCurrentUserProtocol
  @Published var user: UserModel? = nil
  @Published var errorMessage = ""
  @Published var placesFromApp: [SightSeenModel] = []
  
  
  init(userManager: GetCurrentUserProtocol = UserManager()) {
    self.userManager = userManager
    
    fetchCurrentUser()
    getAppPLaces()
  }
  
  private func fetchCurrentUser() {
    Task {
      do {
        let data = try await userManager.getCurrentUser()
        
        await MainActor.run {
          user = data
        }
      } catch {
        errorMessage = error.localizedDescription
      }
    }
  }
  
  private func getAppPLaces() {
    Task {
      do {
        let data = try await fetchPlaces()
        
        await MainActor.run {
          placesFromApp = data
        }
      } catch {
        print("❌ Error in getAppPlaces:", error)
        
        await MainActor.run {
          errorMessage = "Something went wrong!"
        }
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
