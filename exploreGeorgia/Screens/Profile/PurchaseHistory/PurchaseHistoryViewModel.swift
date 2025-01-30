//
//  Untitled.swift
//  exploreGeorgia
//
//  Created by Despo on 21.01.25.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

final class PurchaseHistoryViewModel: ObservableObject {
  private let userMnaagr: GetFirebaseUserProtocol
  @Published var historyData: [PurchasedTourModel] = []
  @Published var isLoading = true
  
  init(userMnaagr: GetFirebaseUserProtocol = UserManager()) {
    self.userMnaagr = userMnaagr
  }
  
  func fetchUserPurchases(pageSize: Int) {
    Task {
      do {
        let userID = Auth.auth().currentUser?.uid ?? ""
        let (tours, _) = try await fetchPurchasedTours(userId: userID, pageSize: pageSize)
        
        await MainActor.run {
          let updatedHistory = tours.map { tour in
            var updatedTour = tour
            let checkDate = updatedTour.date
            let isPast = isDateInPast(checkDate)
            
            updatedTour.date = formatDateString(checkDate) ?? ""
            updatedTour.isActive = !isPast
            return updatedTour
          }
          
          historyData = updatedHistory
          isLoading = false
        }
      } catch {        
        await MainActor.run {
          isLoading = false
        }
      }
    }
  }
  
  func formatDateString(_ input: String) -> String? {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    
    guard let date = inputFormatter.date(from: input) else {
      return nil
    }
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "MMM d, yyyy"
    
    return outputFormatter.string(from: date)
  }
  
  func isDateInPast(_ input: String) -> Bool {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    
    guard let date = inputFormatter.date(from: input) else {
      return false
    }
    
    let currentDate = Date()
    
    return date < currentDate
  }
  
  func fetchPurchasedTours(userId: String, pageSize: Int, lastDocument: DocumentSnapshot? = nil) async throws -> (tours: [PurchasedTourModel], lastDocument: DocumentSnapshot?) {
    let db = Firestore.firestore()
    
    let userDoc = try await db.collection("users").document(userId).getDocument()
    guard let purchasedTourIds = userDoc.data()?["purchasedTours"] as? [String] else {
      return ([], nil)
    }
    
    guard !purchasedTourIds.isEmpty else { return ([], nil) }
    var query = db.collection("purchasedTours")
      .whereField("id", in: purchasedTourIds)
      .limit(to: pageSize)
    
    if let lastDocument = lastDocument {
      query = query.start(afterDocument: lastDocument)
    }
    
    let snapshot = try await query.getDocuments()
    
    let tours = snapshot.documents.compactMap { document -> PurchasedTourModel? in
      let data = document.data()
      
      return PurchasedTourModel(
        id: data["id"] as? String ?? "",
        userId: userId,
        tickets: data["tickets"] as? Int ?? 0,
        date: data["date"] as? String ?? "",
        tourName: data["tourName"] as? String ?? "",
        tourDescription: data["tourDescription"] as? String ?? "",
        tourCover: data["tourCover"] as? String ?? "",
        total: data["total"] as? Int ?? 0,
        isActive: data["isActive"] as? Bool ?? true
      )
    }
    
    let lastDoc = snapshot.documents.last
    return (tours, lastDoc)
  }
}
