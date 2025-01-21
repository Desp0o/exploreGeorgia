//
//  PurchasedTourModel.swift
//  exploreGeorgia
//
//  Created by Despo on 20.01.25.
//

import SwiftUI

struct PurchasedTourModel: Codable, Identifiable, Hashable {
  var id: String
  var userId: String
  var tickets: Int
  var date: String
  var tourName: String
  var tourDescription: String
  var tourCover: String
  var total: Int
  var isActive: Bool
}
