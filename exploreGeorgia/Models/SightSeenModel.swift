//
//  SightSeenModel.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import SwiftUI
import FirebaseFirestore

struct SightSeenModel: Codable, Identifiable, Hashable {
  @DocumentID var id: String?
  let cover: String
  let name: String
  let region: String
  let album: [String]
  let description: String
  let rating: String
  let price: Int
  let adress: String
  let ratingCount: Int
  let latitude: Double
  let longitude: Double
  var isBookmarked: Bool?
}
