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
  @Published var currentPlace: SightSeenModel? = nil
  @Published var isBookMarked = false
  @Published var author: UserModel? = nil
  private let userManager: GetFirebaseUserProtocol
  private let firebaseSinglePlaceFetcher: FirebaseSinglePlaceGenericProtocol
  
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
        let data: SightSeenModel = try await firebaseSinglePlaceFetcher.fetchSinglePlaceGeneric(with: id, and: collection.rawValue)
        
        await MainActor.run {
          currentPlace = data
          
          print(currentPlace)
          if currentPlace?.user == nil {
            print("🟢")
          }
        }
        
        await checkIfBookmarked(placeId: id)

        guard let userID = currentPlace?.user else { return }
        let currentAuthor = try await userManager.getFirebaseUser(with: userID)
        
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
      let userID = Auth.auth().currentUser?.uid
      guard let currentUser = try await userManager.getFirebaseUser(with: userID ?? "") else {
        print("No user data available")
        return
      }
      
      await MainActor.run {
        isBookMarked = currentUser.bucketList.contains(placeId)
      }
    } catch {
      print("Error checking bookmark status: \(error.localizedDescription)")
    }
  }
}
