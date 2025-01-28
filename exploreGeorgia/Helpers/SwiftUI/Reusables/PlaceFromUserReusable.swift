//
//  PlaceFromUserReusable.swift
//  exploreGeorgia
//
//  Created by Despo on 17.01.25.
//

import SwiftUI

struct PlaceFromUserReusable: View {
  let place: SightSeenModel
  
  var body: some View {
    HStack(spacing: 16) {
      CachedAsyncImage(url: URL(string: place.cover))
        .frame(width: 80, height: 80)
        .roundedCorners(12)
      
      VStack(alignment: .leading) {
        Text(place.name)
          .styledText(.customBlack, 16, .semibold)
        
        Text(place.description.prefix(100))
          .styledText(.customGray, 14, .regular, .leading)
          .frame(maxWidth: 250, alignment: .leading)
        
        Spacer()
        
        HStack {
          Image("locationPin")
            .renderingMode(.template)
            .resizable()
            .scaledToFill()
            .foregroundColor(.customGray)
            .frame(width: 16, height: 16)
          
          Text(place.region)
            .styledText(.customGray, 15)
        }
      }
      
      Spacer()
      
      Image("arrowRight")
    }
    .padding(10)
    .frame(maxWidth: .infinity)
    .frame(height: 100)
    .background(.customWhite)
    .roundedCorners(12)
    .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
    .overlay {
      ZStack {
        if place.isFood ?? false {
          Image(systemName: "fork.knife.circle.fill")
            .foregroundStyle(.customGreen)
            .scaleEffect(1.2)
            .offset(x: -10, y: 10)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
  }
}

