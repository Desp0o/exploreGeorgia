//
//  ResturantModel.swift
//  exploreGeorgia
//
//  Created by Despo on 23.01.25.
//


struct ResturantModel: Codable, IdentifiableAndBookmarkable {
  var id: String?
  let name: String
  let cover: String
  let workingHours: String
  let minCost: Double
  let latitude: Int
  let longitude: Int
  var isBookmarked: Bool?
  let isGlutein: Bool
  let isVegan: Bool
  let isVegetarian: Bool
  let about: String
  var reviews: [String]
  let menu: [String: FoodItem]
  let type: String
}

struct FoodItem: Codable {
    let foodCover: String
    let foodIngredients: String
    let foodName: String
    let foodPrice: Int
}
