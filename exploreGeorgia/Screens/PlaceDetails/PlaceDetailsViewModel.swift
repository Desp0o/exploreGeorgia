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

final class PlaceDetailsViewModel: ObservableObject {
  @Published var currentPlace: SightSeenModel? = nil
  @Published var isBookMarked = false
  @Published var author: UserModel? = nil
  private let userManager: GetCurrentUserProtocol
  private let firebaseUserFetcher: FirebaseSingleUserFetchProtocol
  private let firebaseSinglePlaceFetcher: FirebaseSinglePlaceFetchProtocol
  
  let gridItems = [
    GridItem(.fixed(50), spacing: 20),
    GridItem(.fixed(50), spacing: 20),
    GridItem(.fixed(50), spacing: 20),
    GridItem(.fixed(50), spacing: 20),
    GridItem(.fixed(50), spacing: 20),
  ]
  
  init(
    userManager: GetCurrentUserProtocol = UserManager(),
    firebaseUserFetcher: FirebaseSingleUserFetchProtocol = FirebaseFetchingService(),
    firebaseSinglePlaceFetcher: FirebaseSinglePlaceFetchProtocol = FirebaseFetchingService()
  ) {
    self.userManager = userManager
    self.firebaseUserFetcher = firebaseUserFetcher
    self.firebaseSinglePlaceFetcher = firebaseSinglePlaceFetcher
  }
  
  func fetchSinglePlaceByID(with id: String, and collection: String) {
    Task {
      do {
        let data = try await firebaseSinglePlaceFetcher.fetchPlace(with: id, and: collection)
        
        await MainActor.run {
          currentPlace = data
        }
        
        await checkIfBookmarked(placeId: id)

        guard let userID = currentPlace?.user else { return }
        let currentAuthor = try await firebaseUserFetcher.getUser(with: userID)
        
        await MainActor.run {
          author = currentAuthor
        }
      } catch {
        print("Error fetching place: \(error.localizedDescription)")
      }
    }
  }
    
  private func checkIfBookmarked(placeId: String) async {
    do {
      guard let currentUser = try await userManager.getCurrentUser() else {
        print("No user data available")
        return
      }
      
      await MainActor.run {
        isBookMarked = currentUser.bucketList.contains(placeId)
        print(currentUser.bucketList)
        print(isBookMarked)
      }
    } catch {
      print("Error checking bookmark status: \(error.localizedDescription)")
    }
  }
}
