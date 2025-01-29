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
  let maxWidth: CGFloat
  let height: CGFloat
  let isBookmarkIconHidden: Bool
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      CachedAsyncImage(url: URL(string: place.cover))
        .frame(height: height)
        .frame(maxWidth: maxWidth - 28)
        .roundedCorners(12)
      
      HStack(spacing: 2) {
        Text(place.name)
          .styledText(.customBlack, 18, .semibold, .leading, linesCount: 1)
        
        Spacer()
        
        if place.user == nil {
          Image(systemName: "star.fill")
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.yellow)
            .frame(width: 12, height: 12)
          
          Text(place.rating)
            .styledText(.customBlack, 13, .semibold)
        }
      }
      
      HStack(spacing: 2) {
        Image("locationPin")
          .renderingMode(.template)
          .foregroundStyle(.customGray)
          .frame(width: 16, height: 16)
        
        Text(place.region)
          .styledText(.customGray, 14, linesCount: 1)
        
        Spacer()
        
        Text(place.price == 0 ? "Free" : "₾\(place.price)")
          .styledText(
            .customGreen, 14, .semibold)
      }
    }
    .padding(.all, 14)
    .frame(width: maxWidth)
    .background(.customWhite)
    .roundedCorners(12)
    .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
  }
}

