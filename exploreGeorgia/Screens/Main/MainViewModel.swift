//
//  MainViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import FirebaseFirestore
import FirebaseAuth

@MainActor
final class MainViewModel: ObservableObject {
  private let userManager: GetFirebaseUserProtocol
  private let firebaseManager: FirebaseFetchingServicePorotocol
  private let firebaseSimpleManager: FirebaseSimpleCollectionFetchProtocol
  
  @Published var user: UserModel? = nil
  @Published var intrestingFacts: [FactModel] = []
  @Published var placesFromApp: [SightSeenModel] = []
  @Published var usersAddedPlacesData: [SightSeenModel] = []
  @Published var fetchedTours: [TourModel] = []
  @Published var isLoading = true
  
  init(
    userManager: GetFirebaseUserProtocol = UserManager(),
    firebaseManager: FirebaseFetchingServicePorotocol = FirebaseFetchingService(),
    firebaseSimpleManager: FirebaseSimpleCollectionFetchProtocol = FirebaseFetchingService()
  ) {
    self.userManager = userManager
    self.firebaseManager = firebaseManager
    self.firebaseSimpleManager = firebaseSimpleManager
    fetchFeedData()
  }
  
  private func fetchFeedData() {
    Task {
      do {
        let userID = Auth.auth().currentUser?.uid
        
        async let userTask = try userManager.getFirebaseUser(with: userID ?? "")
        async let placesTask = try getPopularPlaces()
        async let factsTask = try fetchSingleFact()
        async let usersPlacesTask = try fetchUsersAddedPlaces()
        async let toursTask = try fetchTours()
        
        let userResult = try? await userTask
        let placesFromAppResult = try? await placesTask
        let interestingFactsResult = try? await factsTask
        let usersAddedPlacesDataResult = try? await usersPlacesTask
        let fetchedToursResult = try? await toursTask
        
        user = userResult
        placesFromApp = placesFromAppResult ?? []
        intrestingFacts = interestingFactsResult ?? []
        usersAddedPlacesData = usersAddedPlacesDataResult ?? []
        fetchedTours = fetchedToursResult ?? []
        isLoading = false
        
      } catch {
        isLoading = false
      }
    }
  }
  
  private func getPopularPlaces() async throws -> [SightSeenModel] {
    let (places, _, _): ([SightSeenModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchCollectionFromFirebase(
      collectionName: .appPlace,
      pageSize: 5,
      lastDocument: nil,
      userBucketList: [""]
    )
    return places
  }
  
  private func fetchSingleFact() async throws -> [FactModel] {
    return try await firebaseSimpleManager.fetchCollection(collectionName: .fatcs, limit: 100)
  }
  
  private func fetchUsersAddedPlaces() async throws -> [SightSeenModel] {
    let (places, _, _): ([SightSeenModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchCollectionFromFirebase(
      collectionName: .usersPlace,
      pageSize: 3,
      lastDocument: nil,
      userBucketList: [""]
    )
    return places
  }
  
  private func fetchTours() async throws -> [TourModel] {
    let (places, _, _): ([TourModel], DocumentSnapshot?, Bool) = try await firebaseManager.fetchCollectionFromFirebase(
      collectionName: .tours,
      pageSize: 3,
      lastDocument: nil,
      userBucketList: [""]
    )
    return places
  }
}
