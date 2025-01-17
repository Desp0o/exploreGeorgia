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
  private let firebaseManager: FirebaseFetchingServicePorotocol
  private let singleElementFetcherManager: FirebaseSingleElementFetching
  @Published var user: UserModel? = nil
  @Published var errorMessage = ""
  @Published var randomFact = ""
  @Published var placesFromApp: [SightSeenModel] = []
  @Published var usersAddedPlacesData: [SightSeenModel] = []
  @Published var isLoading = false
  
  init(
    userManager: GetCurrentUserProtocol = UserManager(),
    firebaseManager: FirebaseFetchingServicePorotocol = FirebaseFetchingService(),
    singleElementFetcherManager: FirebaseSingleElementFetching = FirebaseFetchingService()
  ) {
    self.userManager = userManager
    self.firebaseManager = firebaseManager
    self.singleElementFetcherManager = singleElementFetcherManager
    
    fetchSingleFact()
  }
  
  func getPopularPlaces() {
    isLoading = true
    Task {
      do {
        let data = try await userManager.getCurrentUser()
        
        await MainActor.run {
          user = data
        }
        
        let result = try await firebaseManager.fetchPlaces(
          collectionName: "placesFromApp",
          pageSize: 5,
          lastDocument: nil,
          userBucketList: user?.bucketList ?? [""]
        )
        
        await MainActor.run {
          placesFromApp = result.places
          isLoading = false
        }
      } catch {
        await MainActor.run {
          errorMessage = error.localizedDescription
          isLoading = false
        }
      }
    }
  }
  
  func fetchSingleFact() {
    Task {
      do {
        let fact = try await singleElementFetcherManager.fetchRandomDocument(collectionName: "facts")
        guard let fetchedFact = fact else { return }
        
        if let factData = fetchedFact.data(), let factText = factData["fact"] as? String {
          await MainActor.run {
            randomFact = factText
          }
        } else {
          print("No fact text found.")
        }
      } catch {
        print(error.localizedDescription, "❌")
      }
    }
  }
  
  func fetchUsersAddedPlaces() {
    Task {
      do {
        let userData = try await userManager.getCurrentUser()
        
        await MainActor.run {
          user = userData
        }
        
        let result = try await firebaseManager.fetchPlaces(
          collectionName: "usersPlaces",
          pageSize: 3,
          lastDocument: nil,
          userBucketList: user?.bucketList ?? [""]
        )
        
        await MainActor.run {
          usersAddedPlacesData = result.places
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
