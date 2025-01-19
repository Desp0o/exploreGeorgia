//
//  PaymentViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 19.01.25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol PaymentErrorDelegate: AnyObject {
  func didErrorOccur()
}

protocol PaymentLoadingDelegate: AnyObject {
  func didProcessFinished()
}

final class PaymentViewModel {
  weak var errorDelegate: PaymentErrorDelegate?
  weak var loadingDelegate: PaymentLoadingDelegate?
  private let db = Firestore.firestore()
  var isLoading = false
  var errorMessage = ""

  func formatCardPlaceholder(_ input: String) -> String {
    let cleanedString = input.filter { $0.isLetter || $0.isWhitespace }
    return cleanedString
  }
  
  func formatCreditCardNumber(_ input: String) -> String {
    let digitsOnly = input.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
    
    let formatted = digitsOnly.enumerated().map { index, char -> String in
      return (index % 4 == 0 && index > 0) ? " \(char)" : "\(char)"
    }.joined()
    
    return String(formatted.prefix(19))
  }
  
  func formatExpiryDate(_ expiryDate: String) -> String {
    let cleanedString = expiryDate.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    
    var formattedString = ""
    for (index, character) in cleanedString.enumerated() {
      if index == 2 {
        formattedString.append("/")
      }
      formattedString.append(character)
      
      if formattedString.count == 5 {
        break
      }
    }
    
    return formattedString
  }
  
  func formatCCV(_ ccv: String) -> String {
    let cleanedString = ccv.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    
    var formattedString = ""
    for (_, character) in cleanedString.prefix(3).enumerated() {
      formattedString.append(character)
    }
    
    return formattedString
  }
  
  func attachCardToUser(payment: CreditCardModel) async throws {
    guard let currentUser = Auth.auth().currentUser else {
      print("No user is logged in.")
      return
    }
    
    do {
      let encoder = JSONEncoder()
      let paymentData = try encoder.encode(payment)
      
      if let paymentDictionary = try? JSONSerialization.jsonObject(with: paymentData, options: []) as? [String: Any] {
        try await db.collection("users").document(currentUser.uid).updateData([
          "payments": FieldValue.arrayUnion([paymentDictionary])
        ])
        print("Successfully updated payments field for user \(currentUser.uid)")
      } else {
        print("Failed to convert payment data to dictionary.")
      }
    } catch {
      throw error
    }
  }
  
  func sendCreditCardToDdataBase(cardholder: String, cardNumber: String, cardExpireDate: String) {
    guard !cardholder.isEmpty else {
      errorMessage = CreditCardValidationError.noFullname.rawValue
      errorDelegate?.didErrorOccur()
      return
    }
    
    guard cardNumber.count > 18 else {
      errorMessage = CreditCardValidationError.noNumber.rawValue
      errorDelegate?.didErrorOccur()
      return
    }
    
    guard cardExpireDate.count > 4 else {
      errorMessage = CreditCardValidationError.noData.rawValue
      errorDelegate?.didErrorOccur()
      return
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/yy"
    if let date = dateFormatter.date(from: cardExpireDate) {
      let currentDate = Date()
      if date < currentDate {
        errorMessage = CreditCardValidationError.expiredCard.rawValue
        errorDelegate?.didErrorOccur()
        return
      }
    } else {
      errorMessage = CreditCardValidationError.dataBadFormat.rawValue
      errorDelegate?.didErrorOccur()
      return
    }
    
    isLoading = true
    loadingDelegate?.didProcessFinished()
    
    Task {
      do {
        let payment = CreditCardModel(number: cardNumber, expDate: cardExpireDate, holder: cardholder)
        try await attachCardToUser(payment: payment)
        
        await MainActor.run {
          isLoading = false
          loadingDelegate?.didProcessFinished()
        }
      } catch {
        await MainActor.run {
          isLoading = false
          loadingDelegate?.didProcessFinished()
          
          errorMessage = error.localizedDescription
          errorDelegate?.didErrorOccur()
        }
      }
    }
  }
}
