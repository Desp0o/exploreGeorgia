//
//  CreditCardValidationError.swift
//  exploreGeorgia
//
//  Created by Despo on 19.01.25.
//

enum CreditCardValidationError: String {
  case noFullname = "Please enter the cardholder's full name"
  case noNumber = "Please enter complete card number"
  case noData = "Please enter card expiration date"
  case expiredCard = "This card has expired"
  case dataBadFormat = "Invalid expiration date format. Please use MM/YY format"
}
