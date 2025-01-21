//
//  TourViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 18.01.25.
//

import FirebaseAuth
import Combine
import SwiftUI
import FirebaseCore
import FirebaseFirestore

final class TourViewModel: ObservableObject {
  private let firebaseManager: FirebaseSinglePlaceGenericProtocol
  private let bookmarkManager: CheckBookmarkProtocol
  private let userManager: UserManager
  private let paymentManager: FirebasePayemntsProtocol
  private let db = Firestore.firestore()
  private var currentUserId = ""
  @Published var tour: TourModel? = nil
  @Published var isLoading = true
  @Published var isBookMarked = false
  @Published var cardData: [CreditCardModel] = []
  @Published var tourDetailArray: [TourStatistic] = [
    TourStatistic(icon: "clock", title: "Duration", titleValie: ""),
    TourStatistic(icon: "routing", title: "Distance", titleValie: ""),
    TourStatistic(icon: "ranking", title: "Rating", titleValie: ""),
  ]
  @Published var selectedDate: Date = Date()
  @Published var pickedPlaces = 0
  @Published var totalAmount = 0
  @Published var isSuccessfullyPurchased = false
  @Published var isPaymentOpened = false
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
    Task {
      do {
        let userID = Auth.auth().currentUser?.uid
        let cards = try await paymentManager.fetchPayments(userId: userID ?? "", pageSize: 10, lastDocument: nil)
        
        await MainActor.run {
          cardData = cards.payments
          currentUserId = userID ?? ""
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  func createPurchase() {
    let newTour = PurchasedTourModel(
      id: UUID().uuidString,
      userId: currentUserId,
      tickets: pickedPlaces,
      date: "\(selectedDate)",
      tourName: tour?.name ?? "",
      tourDescription: tour?.description ?? "",
      tourCover: tour?.cover ?? "",
      total: totalAmount,
      isActive: true
    )
    
    Task {
      do {
        try await addPurchasedTour(purchasedTour: newTour, forUser: currentUserId)
        
        await MainActor.run {
          isPaymentOpened = false
          isSuccessfullyPurchased = true
        }
      } catch {
        print("Failed to add purchased tour: \(error.localizedDescription)")
      }
    }
  }
  
  func addPurchasedTour(purchasedTour: PurchasedTourModel, forUser userId: String) async throws {
    do {
      let purchasedTourRef = db.collection("purchasedTours").document(purchasedTour.id)
      try await purchasedTourRef.setData([
        "id": purchasedTour.id,
        "userId": purchasedTour.userId,
        "tickets": purchasedTour.tickets,
        "date": purchasedTour.date,
        "tourName": purchasedTour.tourName,
        "tourDescription": purchasedTour.tourDescription,
        "tourCover": purchasedTour.tourCover,
        "total": purchasedTour.total,
        "isActive": true
      ])
      
      let userRef = db.collection("users").document(userId)
      
      try await userRef.updateData([
        "purchasedTours": FieldValue.arrayUnion([purchasedTour.id])
      ])
    } catch {
      print(error.localizedDescription)
      throw error
    }
  }
}
