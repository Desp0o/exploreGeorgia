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
import FirebaseAuth

final class PlaceDetailsViewModel: ObservableObject {
  private let userManager: GetFirebaseUserProtocol
  private let firebaseSinglePlaceFetcher: FirebaseSinglePlaceGenericProtocol
  @Published var currentPlace: SightSeenModel? = nil
  @Published var isBookmarked = false
  @Published var author: UserModel? = nil
  @Published var selectedImage = ""
  @Published var isLightBoxVisible = false
  @Published var isPresented = false
  @Published var isLoading = true
  @Published var isError = false
  let gridItems = [
    GridItem(.fixed(50), spacing: 20),
    GridItem(.fixed(50), spacing: 20),
    GridItem(.fixed(50), spacing: 20),
    GridItem(.fixed(50), spacing: 20),
    GridItem(.fixed(50), spacing: 20),
  ]
  
  init(
    userManager: GetFirebaseUserProtocol = UserManager(),
    firebaseSinglePlaceFetcher: FirebaseSinglePlaceGenericProtocol = FirebaseFetchingService()
  ) {
    self.userManager = userManager
    self.firebaseSinglePlaceFetcher = firebaseSinglePlaceFetcher
  }
  
  func fetchSinglePlaceByID(with id: String, and collection: FirebaseCollectionEnum) {
    Task {
      do {
        let data: SightSeenModel = try await firebaseSinglePlaceFetcher.fetchSinglePlaceGeneric(with: id, and: collection)

        await MainActor.run {
          print(isLoading, "🥸")
          currentPlace = data
          isLoading = false
          print(isLoading, "🥸")
        }
        
        await checkIfBookmarked(placeId: id)
        
        guard let userID = currentPlace?.user else { return }
        let currentAuthor = try await userManager.getFirebaseUser(with: userID)
        
        await MainActor.run {
         
          author = currentAuthor
          

        }
      } catch {
        print("Error fetching place: \(error.localizedDescription)")
        await MainActor.run {
          isLoading = false
          isError = true
          print(isLoading, "🥸")

        }
      }
    }
  }
  
  private func checkIfBookmarked(placeId: String) async {
    do {
      let userID = Auth.auth().currentUser?.uid
      guard let currentUser = try await userManager.getFirebaseUser(with: userID ?? "") else {
        return
      }
      
      await MainActor.run {
        isBookmarked = currentUser.bucketList.contains(placeId)
      }
    } catch {
      print("Error checking bookmark status: \(error.localizedDescription)")
    }
  }
}
