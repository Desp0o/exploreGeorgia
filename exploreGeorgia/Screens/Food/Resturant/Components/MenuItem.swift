//
//  MenuItem.swift
//  exploreGeorgia
//
//  Created by Despo on 23.01.25.
//

import SwiftUI

struct MenuItem: View {
  let foodCover: String
  let foodName: String
  let ingredients: String
  let price: Int
  
  var body: some View {
    HStack(spacing: 20) {
      CachedAsyncImage(url: URL(string: foodCover))
        .frame(width: 100, height: 100)
        .clipped()
      
      VStack(alignment: .leading, spacing: 6) {
        Text(foodName)
          .styledText(.customBlack, 16, .semibold)
        
        Text(ingredients.suffix(100))
          .styledText(.customBlack, 15, linesCount: 2)
        
        Text("₾ \(price)")
          .styledText(.customVine, 16, .bold)
      }
      
      Spacer()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(.customWhite)
    .roundedCorners(12)
    .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
  }
}

