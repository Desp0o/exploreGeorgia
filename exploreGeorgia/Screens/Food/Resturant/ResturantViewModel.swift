//
//  ResturantViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 22.01.25.
//

import Combine
import FirebaseAuth
import FirebaseFirestore

final class ResturantViewModel: ObservableObject {
  private let firebaseManager: FirebaseSinglePlaceGenericProtocol
  private let userManager: GetFirebaseUserProtocol
  @Published var singleResturant:  ResturantModel? = nil
  @Published var errorMessage: CustomErrorsMessage? = nil
  @Published var isBookMarked = false
  @Published var isLoading = true
  @Published var usersReviweText = ""
  @Published var reviews: [String] = []
  @Published var successMessage = ""
  @Published var isPresent = false
  @Published var isReviewVisible = false
  @Published var commentLoaderTrigger = false
  @Published var infoHeight: CGFloat = 0.6
  
  init(
    firebaseManager: FirebaseSinglePlaceGenericProtocol = FirebaseFetchingService(),
    userManager: GetFirebaseUserProtocol = UserManager()
  ) {
    self.firebaseManager = firebaseManager
    self.userManager = userManager
  }
  
  func fetchData(id: String, collection: FirebaseCollectionEnum) {
    Task {
      do {
        let userID = Auth.auth().currentUser?.uid ?? ""
        let currentUser = try await userManager.getFirebaseUser(with: userID)
        let result: ResturantModel = try await firebaseManager.fetchSinglePlaceGeneric(with: id, and: collection)
        
        await MainActor.run {
          singleResturant = result
          isLoading = false
          reviews = singleResturant?.reviews ?? []
          
          guard let user = currentUser else { return }
          isBookMarked = user.bucketList.contains(result.id ?? "")
        }
      } catch {
        await MainActor.run {
          isLoading = false
          errorMessage = .fetchError
        }
      }
    }
  }
  
  func addUserReview(collection: FirebaseCollectionEnum) {
    guard !usersReviweText.isEmpty else { return }
    
    Task {
      do {
        guard let restaurantId = singleResturant?.id else { return }
        try await updateReviews(
          collectionName: collection,
          restaurantId: restaurantId,
          newReview: usersReviweText
        )
        
        await MainActor.run {
          successMessage = "Review added successfully"
          reviews.insert(usersReviweText, at: 0)
          usersReviweText = ""
        }
      } catch {
        await MainActor.run {
          errorMessage = .feedbackError
        }
      }
    }
  }
  
  func updateReviews(collectionName: FirebaseCollectionEnum , restaurantId: String, newReview: String) async throws {
    let db = Firestore.firestore()
    let restaurantRef = db.collection(collectionName.rawValue).document(restaurantId)
    
    try await restaurantRef.updateData([
      "reviews": FieldValue.arrayUnion([newReview])
    ])
  }
}


