//
//  PaymentViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 19.01.25.
//

import Foundation


final class  PaymentViewModel {
  
  func formatCardPlaceholder(_ input: String) -> String {
    let cleanedString = input.components(separatedBy: CharacterSet.letters.inverted).joined()
    
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
  
}
