//
//  PaymentViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 19.01.25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol PaymentDataDelegate: AnyObject {
  func didDataFetched()
}

protocol PaymentErrorDelegate: AnyObject {
  func didErrorOccur()
}

protocol PaymentLoadingDelegate: AnyObject {
  func didProcessFinished()
}

final class PaymentViewModel {
  weak var dataDelegate: PaymentDataDelegate?
  weak var errorDelegate: PaymentErrorDelegate?
  weak var loadingDelegate: PaymentLoadingDelegate?
  private let paymentsManager: FirebasePayemntsProtocol
  private let userManager: GetCurrentUserProtocol
  private let db = Firestore.firestore()
  var creditCards: [CreditCardModel] = []
  var isLoading = false
  var errorMessage = ""
  
  init(
    userManager: GetCurrentUserProtocol = UserManager(),
    paymentsManager: FirebasePayemntsProtocol = FirebaseFetchingService()
  ) {
    self.userManager = userManager
    self.paymentsManager = paymentsManager
    
    fetchAllUserPayments()
  }
  
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
  
  func attachCardToUser(card: CreditCardModel) async throws {
    let db = Firestore.firestore()
    
    do {
      let cardData: [String: Any] = [
        "userId": card.userId,
        "number": card.number,
        "expDate": card.expDate,
        "holder": card.holder
      ]
      
      var documentRef: DocumentReference? = nil
      documentRef = db.collection("payments").addDocument(data: cardData) { error in
        if let error = error {
          print("Error saving credit card: \(error)")
        } else if let documentRef = documentRef {
          print("Credit card successfully saved with ID: \(documentRef.documentID)")
          
          let userRef = db.collection("users").document(card.userId)
          userRef.updateData([
            "creditCards": FieldValue.arrayUnion([documentRef.documentID])
          ]) { error in
            if let error = error {
              print("Error updating user's creditCards array: \(error)")
            } else {
              print("Credit card ID added to user's creditCards array")
            }
          }
        }
      }
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
        let userID = Auth.auth().currentUser?.uid
        
        let payment = CreditCardModel(userId: userID ?? "", number: cardNumber, expDate: cardExpireDate, holder: cardholder)
        try await attachCardToUser(card: payment)
        
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
  
  
  func fetchAllUserPayments() {
    Task {
      do {
        let user = Auth.auth().currentUser?.uid
        
        let data = try await paymentsManager.fetchPayments(userId: user ?? "", pageSize: 10, lastDocument: nil)
        print(data, "⚠️")
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
