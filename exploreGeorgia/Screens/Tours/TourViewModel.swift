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
  @Published var isLightBoxVisible = false
  @Published var selectedImage = ""
  @Published var startingDate: Date = Date().addingTimeInterval(86400)
  @Published var isCalendarShown = false
  @Published var errorMessage = ""
  
  init(
    firebaseManager: FirebaseSinglePlaceGenericProtocol = FirebaseFetchingService(),
    bookmarkManager: CheckBookmarkProtocol = BookMarkManager(),
    userManager: UserManager = UserManager()
  ) {
    self.firebaseManager = firebaseManager
    self.bookmarkManager = bookmarkManager
    self.userManager = userManager
    
    fetchCreditCards()
  }
  
  func fetchSingleTour(with placeId: String, and collection: FirebaseCollectionEnum) {
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
        await MainActor.run {
          isLoading = false
        }
      }
    }
  }
  
  func fetchCreditCards() {
    Task {
      do {
        let userID = Auth.auth().currentUser?.uid ?? ""
        let currentUser = try await userManager.getFirebaseUser(with: userID)
        
        await MainActor.run {
          cardData = currentUser?.payments ?? []
          currentUserId = userID
        }
      } catch {
        await MainActor.run {
          errorMessage = "Could not retrieve credit cards."
        }
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
        await MainActor.run {
          errorMessage = "Failed to purchase the tour."
        }
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
      throw error
    }
  }
}
