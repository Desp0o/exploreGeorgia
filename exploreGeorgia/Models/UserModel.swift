//
//  UserModel.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

import FirebaseCore
import SwiftUI

struct UserModel: Codable, Identifiable, Hashable {
  var id: String?
  let avatar: String
  let firstName: String
  let lastName: String
  let email: String
  let gender: String
  let points: Int
  let explored: [String]
  let bucketList: [String]
  let achievement: [String]
  let createdAt: Timestamp?
  var dateField: String?
//  var payments: [String]?
  var creditCards: [String]?
  var purchasedTours: String?
}
