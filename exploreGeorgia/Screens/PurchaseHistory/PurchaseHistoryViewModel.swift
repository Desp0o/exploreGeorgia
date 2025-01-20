//
//  Untitled.swift
//  exploreGeorgia
//
//  Created by Despo on 21.01.25.
//

import Foundation
import Combine

final class PurchaseHistoryViewModel: ObservableObject {
  @Published var tourDate: String = "January 18, 2025 at 11:47:36 PM UTC+4"
  @Published var isTourExpired = false
  
  init() {
    isTourExpired = isDateInPast(tourDate)
    tourDate = formatDateString(tourDate) ?? ""
    print(isTourExpired)
  }
  
  func formatDateString(_ input: String) -> String? {
      let inputFormatter = DateFormatter()
      inputFormatter.dateFormat = "MMMM d, yyyy 'at' h:mm:ss a zzzz"
      inputFormatter.locale = Locale(identifier: "en_US_POSIX")

      guard let date = inputFormatter.date(from: input) else {
          return nil
      }

      let outputFormatter = DateFormatter()
      outputFormatter.dateFormat = "MMMM d, yyyy"

      return outputFormatter.string(from: date)
  }
  

  func isDateInPast(_ input: String) -> Bool {
      let inputFormatter = DateFormatter()
      inputFormatter.dateFormat = "MMMM d, yyyy 'at' h:mm:ss a zzzz"
      inputFormatter.locale = Locale(identifier: "en_US_POSIX")

      guard let date = inputFormatter.date(from: input) else {
          return false
      }

      let currentDate = Date()

      return date < currentDate
  }
}
