//
//  CreditCardModel.swift
//  exploreGeorgia
//
//  Created by Despo on 20.01.25.
//

import Foundation


struct CreditCardModel: Codable, Identifiable, Hashable {
  var id: String?
  var userId: String
  var number: String
  var expDate: String
  var holder: String
}



