//
//  SightSeenReusableView.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import SwiftUI

struct SightSeenReusableView: View {
  @State private var isSaved = false
  let cover: String
  let name: String
  let locationRegion: String
  let rating: String
  let price: Int
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      AsyncImage(url: URL(string: cover)) { image in
        image
          .defaultOptions()
          .frame(width: 240, height: 280)
          .roundedCorners(12)
          .overlay(alignment: .topTrailing) {
            Button {
              isSaved.toggle()
            } label: {
              ZStack {
                Circle()
                  .fill(.customWhite.opacity(0.7))
                
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                  .renderingMode(.template)
                  .foregroundStyle(.customBlue)
              }
            }
            .offset(x: -10, y: 10)
            .frame(width: 34, height: 34)
          }
      } placeholder: {
        Image("imagePlaceholder")
          .defaultOptions()
          .frame(width: 240, height: 280)
          .roundedCorners(12)
      }
      
      HStack(spacing: 2) {
        Text(name)
          .styledText(
            .customBlack,
            18,
            .semibold
          )
        
        Spacer()
        
        Image(systemName: "star.fill")
          .resizable()
          .renderingMode(.template)
          .foregroundStyle(.yellow)
          .frame(width: 12, height: 12)
        
        Text(rating)
          .styledText(
            .customBlack,
            13,
            .semibold
          )
      }
      
      HStack(spacing: 2) {
        Image("locationPin")
          .renderingMode(.template)
          .foregroundStyle(.customGray)
          .frame(width: 16, height: 16)
        
        Text(locationRegion)
          .styledText(
            .customGray,
            14
          )
        
        Spacer()
        
        Text(price == 0 ? "Free" : "₾\(price)")
          .styledText(
            .customVine,
            14,
            .semibold
          )
      }
    }
    .padding(.all, 14)
    .frame(maxWidth: 268)
    .background(.customWhite)
    .roundedCorners(12)
  }
}

#Preview {
  SightSeenReusableView(
    cover: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdTpiRtSARf284eAa-H61EUwtXktXw-XvILA&s",
    name: "Tbilisi, Old City",
    locationRegion: "Tbilisi",
    rating: "4.7",
    price: 0
  )
}
