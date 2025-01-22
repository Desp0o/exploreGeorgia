//
//  MainViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

struct FactModel: Codable {
  let fact: String
}

import FirebaseFirestore
import FirebaseAuth

final class MainViewModel: ObservableObject {
  private let db = Firestore.firestore()
  private let userManager: GetFirebaseUserProtocol
  private let firebaseManager: FirebaseFetchingServicePorotocol
  private let firebaseSimpleManager: FirebaseSimpleCollectionFetchProtocol
  @Published var user: UserModel? = nil
  @Published var errorMessage = ""
  @Published var intrestingFacts: [FactModel] = []
  @Published var placesFromApp: [SightSeenModel] = []
  @Published var usersAddedPlacesData: [SightSeenModel] = []
  @Published var fetchedTours: [TourModel] = []
  @Published var isLoading = false
  
  init(
    userManager: GetFirebaseUserProtocol = UserManager(),
    firebaseManager: FirebaseFetchingServicePorotocol = FirebaseFetchingService(),
    firebaseSimpleManager: FirebaseSimpleCollectionFetchProtocol = FirebaseFetchingService()
  ) {
    self.userManager = userManager
    self.firebaseManager = firebaseManager
    self.firebaseSimpleManager = firebaseSimpleManager
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
        
        let (places, _, _): ([SightSeenModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchCollectionFromFirebase(
          collectionName: .appPlace,
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
        let result: [FactModel] = try await firebaseSimpleManager.fetchCollection(collectionName: .fatcs)
        await MainActor.run {
          intrestingFacts = result
        }
      } catch {
        print(error.localizedDescription)
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
        
        let (places, _, _): ([SightSeenModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchCollectionFromFirebase(
          collectionName: .usersPlace,
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
        let (places, _, _): ([TourModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchCollectionFromFirebase(
          collectionName: .tours,
          pageSize: 3,
          lastDocument: nil,
          userBucketList: user?.bucketList ?? [""]
        )
        
        await MainActor.run {
          fetchedTours = places
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
