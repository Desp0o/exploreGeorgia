//
//  SingleTourFeedView.swift
//  exploreGeorgia
//
//  Created by Despo on 20.01.25.
//

import SwiftUI

struct SingleTourFeedView: View {
  var body: some View {
    ZStack {
      CachedAsyncImage(url: URL(string: "https://www.onthegotours.com/repository/Palmfringed-beach-in-Mirissa--Sri-Lanka-Tours--On-The-Go-Tours-347441495547421.jpg") )
        .roundedCorners(12)
    }
    .frame(width: UIScreen.main.bounds.width, height: 150)
    .roundedCorners(12)
    .overlay {
      VStack {
        Spacer()
        
        HStack {
          HStack {
            VStack(alignment: .leading) {
              Text("Yankari Game Reserve")
                .styledText(.customBlack, 15, .semibold)
              
              Text("Yankari Game ReserveYankari Game ReserveYankari Game ReserveYankari Game Reserve")
                .styledText(.customBlack, 10, linesCount: 2)
                .frame(maxWidth: 160)
            }
          }
          
          Spacer()
          
          HStack {
            Text("Book Now")
              .styledText(.customBlack, 16, .bold)
            
            Image("bookArrow")
          }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding(.horizontal, 15)
        .background(.black.opacity(0.4))
      }
    }
  }
}
