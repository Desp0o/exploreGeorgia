//
//  SightSeenReusableView.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import SwiftUI

struct SightSeenReusableView: View {
  @StateObject var bookmarkManager = BookMarkManager()
  @State private var isSaved = false
  @State var place: SightSeenModel
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      AsyncImage(url: URL(string: place.cover)) { image in
        image
          .defaultOptions()
          .frame(width: 240, height: 250)
          .roundedCorners(12)
          .overlay(alignment: .topTrailing) {
            Button {
              place.isBookmarked?.toggle()
              bookmarkManager
                .savePlaceInBookmark(
                  placeId: place.id ?? "",
                  isBookmarked: !(place.isBookmarked ?? false)
                )
            } label: {
              ZStack {
                Circle()
                  .fill(.customWhite.opacity(0.7))
                
                Image(systemName: place.isBookmarked ?? false ? "bookmark.fill" : "bookmark")
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
          .frame(width: 240, height: 250)
          .roundedCorners(12)
      }
      
      HStack(spacing: 2) {
        Text(place.name)
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
        
        Text(place.rating)
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
        
        Text(place.region)
          .styledText(
            .customGray,
            14
          )
        
        Spacer()
        
        Text(place.price == 0 ? "Free" : "₾\(place.price)")
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
    .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
  }
}

