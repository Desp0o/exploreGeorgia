//
//  TourModel.swift
//  exploreGeorgia
//
//  Created by Despo on 18.01.25.
//

struct TourModel: Codable, IdentifiableAndBookmarkable, Hashable {
  var isBookmarked: Bool?
  var id: String?
  let cover: String
  let name: String
  let adress: String
  let album: [String]
  let duration: String
  let distance: String
  let ranking: String
  let description: String
  let price: Int
  var isBookMarked: Bool?
}
