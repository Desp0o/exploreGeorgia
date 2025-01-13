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
  @Published var isLoading = false
  
  init(userManager: GetCurrentUserProtocol = UserManager()) {
    self.userManager = userManager
  }
  
  func fetchCurrentUser() {
    print("✅")
    isLoading = true
    Task {
      do {
        let data = try await userManager.getCurrentUser()
        
        await MainActor.run {
          user = data
          isLoading = false
        }
        
        getAppPlaces()
        
        await MainActor.run {
          isLoading = false
        }
      } catch {
        errorMessage = error.localizedDescription
        isLoading = false
      }
    }
  }
  
  private func getAppPlaces() {
    Task {
      do {
        let data = try await fetchPlaces(userBucketList: user?.bucketList ?? [""])
        
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
  
  private func fetchPlaces(userBucketList: [String]) async throws -> [SightSeenModel] {
    let collectionRef = db.collection("placesFromApp")
    do {
      let snapshot = try await collectionRef.getDocuments()
      return try snapshot.documents.compactMap { document in
        do {
          var model = try document.data(as: SightSeenModel.self)
          // Check if the place id is in the user's bucketList
          if let id = model.id {
            model.isBookmarked = userBucketList.contains(id) ? true : false
          }
          return model
        } catch {
          throw error
        }
      }
    } catch {
      throw error
    }
  }
  
  func toggleBookmark(for id: String) {
    if let index = placesFromApp.firstIndex(where: { $0.id == id }) {
      placesFromApp[index].isBookmarked?.toggle()
      print(placesFromApp[index])
    } else {
      print("Place with id \(id) not found")
    }
  }
}
