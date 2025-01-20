//
//  MainViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import FirebaseFirestore
import FirebaseAuth

final class MainViewModel: ObservableObject {
  private let db = Firestore.firestore()
  private let userManager: GetFirebaseUserProtocol
  private let firebaseManager: FirebaseFetchingServicePorotocol
  private let singleElementFetcherManager: FirebaseSingleElementFetching
  @Published var user: UserModel? = nil
  @Published var errorMessage = ""
  @Published var randomFact = ""
  @Published var placesFromApp: [SightSeenModel] = []
  @Published var usersAddedPlacesData: [SightSeenModel] = []
  @Published var fetchedTours: [TourModel] = []
  @Published var isLoading = false
  
  init(
    userManager: GetFirebaseUserProtocol = UserManager(),
    firebaseManager: FirebaseFetchingServicePorotocol = FirebaseFetchingService(),
    singleElementFetcherManager: FirebaseSingleElementFetching = FirebaseFetchingService()
  ) {
    self.userManager = userManager
    self.firebaseManager = firebaseManager
    self.singleElementFetcherManager = singleElementFetcherManager
    
    fetchSingleFact()
    fetchTours()
  }
  
  func getPopularPlaces() {
    isLoading = true
    Task {
      do {
        let userID = Auth.auth().currentUser?.uid
        let data = try await userManager.getFirebaseUser(with: userID ?? "")
        
        await MainActor.run {
          user = data
        }
        
        let (places, _, _): ([SightSeenModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchPlaces(
          collectionName: "placesFromApp",
          pageSize: 5,
          lastDocument: nil,
          userBucketList: user?.bucketList ?? [""]
        )
        
        await MainActor.run {
          placesFromApp = places
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
        let userID = Auth.auth().currentUser?.uid
        
        let userData = try await userManager.getFirebaseUser(with: userID ?? "")
        
        await MainActor.run {
          user = userData
        }
        
        let (places, _, _): ([SightSeenModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchPlaces(
          collectionName: "usersPlaces",
          pageSize: 3,
          lastDocument: nil,
          userBucketList: user?.bucketList ?? [""]
        )
        
        await MainActor.run {
          usersAddedPlacesData = places
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  func fetchTours() {
    Task {
      do {
        let (places, _, _): ([TourModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchPlaces(
          collectionName: "tours",
          pageSize: 3,
          lastDocument: nil,
          userBucketList: user?.bucketList ?? [""]
        )
        
        await MainActor.run {
          fetchedTours = places
          print(fetchedTours)
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
