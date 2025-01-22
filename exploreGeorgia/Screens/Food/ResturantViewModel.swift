//
//  ResturantViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 22.01.25.
//

import Combine
import FirebaseAuth

final class ResturantViewModel: ObservableObject {
  private let firebaseManager: FirebaseSinglePlaceGenericProtocol
  private let userManager: GetFirebaseUserProtocol
  @Published var singleResturant:  ResturantModel? = nil
  @Published var errorMessage: CustomErrorsMessage? = nil
  @Published var isBookMarked = false
  @Published var isLoading = true
  
  init(
    firebaseManager: FirebaseSinglePlaceGenericProtocol = FirebaseFetchingService(),
    userManager: GetFirebaseUserProtocol = UserManager()
  ) {
    self.firebaseManager = firebaseManager
    self.userManager = userManager
    
    fetchData()
  }
  
  func fetchData() {
    Task {
      do {
        let userID = Auth.auth().currentUser?.uid ?? ""
        let currentUser = try await userManager.getFirebaseUser(with: userID)
        let result: ResturantModel = try await firebaseManager.fetchSinglePlaceGeneric(with: "1pOkR761H11Srg8qqD1r", and: "resturant")
        
        await MainActor.run {
          singleResturant = result
          isLoading = false
          
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
}
