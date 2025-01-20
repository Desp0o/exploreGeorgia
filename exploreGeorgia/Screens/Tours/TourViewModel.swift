//
//  TourViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 18.01.25.
//

import FirebaseAuth
import Combine
import SwiftUI

final class TourViewModel: ObservableObject {
  private let firebaseManager: FirebaseSinglePlaceGenericProtocol
  private let bookmarkManager: CheckBookmarkProtocol
  private let userManager: UserManager
  private let paymentManager: FirebasePayemntsProtocol
  @Published var tour: TourModel? = nil
  @Published var isLoading = true
  @Published var isBookMarked = false
  @Published var cardData: [CreditCardModel] = []
  @Published var tourDetailArray: [TourStatistic] = [
    TourStatistic(icon: "clock", title: "Duration", titleValie: ""),
    TourStatistic(icon: "routing", title: "Distance", titleValie: ""),
    TourStatistic(icon: "ranking", title: "Rating", titleValie: ""),
  ]
  let GridColumns = [
    GridItem(),
    GridItem(),
    GridItem(),
    GridItem(),
    GridItem(),
    GridItem(),
    GridItem(),
    GridItem(),
    GridItem(),
    GridItem(),
    GridItem(),
    GridItem()
  ]
  
  init(
    firebaseManager: FirebaseSinglePlaceGenericProtocol = FirebaseFetchingService(),
    bookmarkManager: CheckBookmarkProtocol = BookMarkManager(),
    userManager: UserManager = UserManager(),
    paymentManager: FirebasePayemntsProtocol = FirebaseFetchingService()
  ) {
    self.firebaseManager = firebaseManager
    self.bookmarkManager = bookmarkManager
    self.userManager = userManager
    self.paymentManager = paymentManager
    
    fetchCreditCards()
  }
  
  func fetchSingleTour(with placeId: String, and collection: String) {
    Task {
      do {
        let userID = Auth.auth().currentUser?.uid

        let data: TourModel = try await firebaseManager.fetchSinglePlaceGeneric(with: placeId, and: collection)
        
        let user = try await userManager.getFirebaseUser(with: userID ?? "")
        
        if let user {
          let checkResult = try await bookmarkManager.checkIfBookmarked(placeId: data.id ?? "", currentUser: user)
          
          await MainActor.run {
            isBookMarked = checkResult
          }
        }
        
        await MainActor.run {
          tour = data
          tourDetailArray[0].titleValie = tour?.duration ?? ""
          tourDetailArray[1].titleValie = tour?.distance ?? ""
          tourDetailArray[2].titleValie = tour?.ranking ?? ""
          
          isLoading = false
        }
      } catch {
        print(error.localizedDescription)
        await MainActor.run {
          isLoading = false
        }
      }
    }
  }
  
  func fetchCreditCards() {
    print("🟢")
    Task {
      do {
        let userID = Auth.auth().currentUser?.uid
        
        let cards = try await paymentManager.fetchPayments(userId: userID ?? "", pageSize: 10, lastDocument: nil)
        
        await MainActor.run {
          cardData = cards.payments
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
