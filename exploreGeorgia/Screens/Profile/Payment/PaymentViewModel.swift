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

protocol CardAddedDelegate: AnyObject {
  func cardAddedSuccessfully()
}

final class PaymentViewModel {
  weak var dataDelegate: PaymentDataDelegate?
  weak var errorDelegate: PaymentErrorDelegate?
  weak var loadingDelegate: PaymentLoadingDelegate?
  weak var cardAddDelegate: CardAddedDelegate?
  private let userManager: GetFirebaseUserProtocol
  private let db = Firestore.firestore()
  var creditCards: [CreditCardModel] = []
  var isLoading = false
  var errorMessage = ""
  
  init(
    userManager: GetFirebaseUserProtocol = UserManager()
  ) {
    self.userManager = userManager
    
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
        "number": card.number,
        "expDate": card.expDate,
        "holder": card.holder
      ]
      
      let userRef = db.collection(FirebaseCollectionEnum.users.rawValue).document(card.userId)
      
      try await userRef.updateData([
        "payments": FieldValue.arrayUnion([cardData])
      ])
      
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
    
    Task {
      do {
        await MainActor.run {
          isLoading = true
          loadingDelegate?.didProcessFinished()
        }
        
        let userID = Auth.auth().currentUser?.uid
        
        let payment = CreditCardModel(userId: userID ?? "", number: cardNumber, expDate: cardExpireDate, holder: cardholder)
        try await attachCardToUser(card: payment)
        
        await MainActor.run {
          isLoading = false
          loadingDelegate?.didProcessFinished()
          cardAddDelegate?.cardAddedSuccessfully()
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
      await MainActor.run {
        isLoading = true
        dataDelegate?.didDataFetched()
      }
      
      do {
        let userID = Auth.auth().currentUser?.uid ?? ""
        
        let data = try await userManager.getFirebaseUser(with: userID)
        
        await MainActor.run {
          creditCards = data?.payments ?? []
          isLoading = false
          dataDelegate?.didDataFetched()
        }
        
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  func deleteCreditCard(with card: CreditCardModel) {
    Task {
      do {
        try await removeElementFromPaymentsAndUsers(card: card)
      } catch {
        print(error)
      }
    }
  }
  
  func removeElementFromPaymentsAndUsers(card: CreditCardModel) async throws {
    do {
      let cardData: [String: Any] = [
        "number": card.number,
        "expDate": card.expDate,
        "holder": card.holder
      ]
      
      let userRef = db.collection(FirebaseCollectionEnum.users.rawValue).document(card.userId)
      
      try await userRef.updateData([
        "payments": FieldValue.arrayRemove([cardData])
      ])
      
    } catch {
      throw error
    }
  }}
