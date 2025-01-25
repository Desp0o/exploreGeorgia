//
//  SingleTourFeedView.swift
//  exploreGeorgia
//
//  Created by Despo on 20.01.25.
//

import SwiftUI

struct SingleTourFeedView: View {
  let tour: TourModel
  let tourMaxWidth: CGFloat
  let isBookButtonVisible: Bool
  
  var body: some View {
    ZStack {
      CachedAsyncImage(url: URL(string: tour.cover))
    }
    .frame(maxWidth: tourMaxWidth)
    .frame(height: 150)
    .roundedCorners(12)
    .overlay {
      VStack {
        Spacer()
        HStack {
          HStack {
            VStack(alignment: .leading) {
              Text(tour.name)
                .styledText(.white, 16, .bold)
              
              Text(tour.description)
                .styledText(.white, 10, linesCount: 2)
                .frame(maxWidth: 160)
            }
          }
          
          Spacer()
          
          if isBookButtonVisible {
            HStack {
              Text("Book Now")
                .styledText(.white, 16, .bold)
              
              Image("bookArrow")
            }
          }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding(.horizontal, 10)
        .background(.black.opacity(0.4))
        .roundedCorners(12)
      }
    }
    .shadow(color: .black.opacity(0.5), radius: 4, y: 2)
  }
}
