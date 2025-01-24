//
//  FoodViewSingleComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 24.01.25.
//

import SwiftUI

struct FoodViewSingleComponent: View {
  let cover: String
  let name: String
  let type: String
  let elementWidth: CGFloat
  
  var body: some View {
    VStack {
      ZStack(alignment: .topTrailing) {
        CachedAsyncImage(url: URL(string: cover))
          .frame(height: 140)
          .frame(maxWidth: elementWidth)
          .roundedCorners(12)
          .shadow(color: .black.opacity(0.30), radius: 4, y: 2)
        
        Text(type)
          .styledText(.customBlack, 13, .semibold)
          .padding(4)
          .background(.customVine)
          .roundedCorners(5)
          .offset(x:-10, y: 10)
      }
      
      HStack {
        Text(name)
          .styledText(.customBlack, 16, .bold)
          .padding(.leading, 5)
        
        Spacer()
      }
    }
    .roundedCorners(12)
  }
}
