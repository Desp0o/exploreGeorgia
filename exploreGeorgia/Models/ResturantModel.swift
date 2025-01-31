//
//  ResturantModel.swift
//  exploreGeorgia
//
//  Created by Despo on 23.01.25.
//

import SwiftUI

struct ResturantModel: Codable, IdentifiableAndBookmarkable, Identifiable, Equatable, Hashable {
  var id: String?
  let name: String
  let cover: String
  let workingHours: String
  let minCost: Double
  let latitude: Double
  let longitude: Double
  var isBookmarked: Bool?
  let isGlutein: Bool
  let isVegan: Bool
  let isVegetarian: Bool
  let about: String
  var reviews: [String]
  let menu: [String: FoodItem]
  let type: String
  var createdAt: Date?
}

struct FoodItem: Codable, Equatable, Hashable {
    let foodCover: String
    let foodIngredients: String
    let foodName: String
    let foodPrice: Int
}
