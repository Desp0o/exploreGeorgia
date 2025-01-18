//
//  TourViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 18.01.25.
//

import Combine

final class TourViewModel: ObservableObject {
  private let firebaseManager: FirebaseSinglePlaceGenericProtocol
  private let bookmarkManager: CheckBookmarkProtocol
  private let userManager: UserManager
  @Published var tour: TourModel? = nil
  @Published var isLoading = true
  @Published var isBookMarked = false
  @Published var tourDetailArray: [TourStatistic] = [
    TourStatistic(icon: "clock", title: "Duration", titleValie: ""),
    TourStatistic(icon: "routing", title: "Distance", titleValie: ""),
    TourStatistic(icon: "ranking", title: "Rating", titleValie: ""),
  ]
  
  init(
    firebaseManager: FirebaseSinglePlaceGenericProtocol = FirebaseFetchingService(),
    bookmarkManager: CheckBookmarkProtocol = BookMarkManager(),
    userManager: UserManager = UserManager()
  ) {
    self.firebaseManager = firebaseManager
    self.bookmarkManager = bookmarkManager
    self.userManager = userManager
    
    fetchSingleTour(with: "cXdFaot6EpnXxB9xsjhm", and: "tours")
  }
  
  func fetchSingleTour(with placeId: String, and collection: String) {
    Task {
      do {
        let data: TourModel = try await firebaseManager.fetchSinglePlaceGeneric(with: placeId, and: collection)
        let user = try await userManager.getCurrentUser()
        
        if let user {
          let checkResult = try await bookmarkManager.checkIfBookmarked(placeId: data.id, currentUser: user)
          
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
}
