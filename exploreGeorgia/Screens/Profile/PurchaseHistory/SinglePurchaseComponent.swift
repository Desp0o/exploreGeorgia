//
//  SinglePurchaseComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 20.01.25.
//

import SwiftUI

struct SinglePurchaseComponent: View {
  let tour: PurchasedTourModel
  
  var body: some View {
    ZStack {
      HStack(spacing: 12) {
        CachedAsyncImage(url: URL(string: tour.tourCover))
          .frame(width: 100, height: 120)
          .roundedCorners(12)
          .grayscale(tour.isActive ? 0 : 1)
        
        VStack(alignment: .leading, spacing: 15) {
          VStack(alignment: .leading) {
            Text(tour.tourName)
              .styledText(.customBlack, 16, .bold)
          }
          
          Spacer()
          
          VStack(alignment: .leading) {
            Text("\(tour.date)")
              .styledText(.customBlack, 14)
            
            HStack(spacing: 0) {
              Image(systemName: "figure.stand")
              
              Text(" x \(tour.tickets)")
                .styledText(.customBlack)
            }
            
            Text("Total: \(tour.total)")
              .styledText(.customBlack)
          }
        }
        .opacity(tour.isActive ? 1 : 0.5)
        
        Spacer()
        
        VStack {
          Spacer()
          
          Rectangle()
            .fill(tour.isActive ? .green : .red)
            .frame(width: 85, height: 30)
            .clipShape(
              Capsule()
            )
            .overlay {
              Text(tour.isActive ? "Upcoming" : "Expired")
                .styledText(.customBlack, 14, .semibold)
            }
        }
      }
    }
    .padding(10)
    .frame(maxWidth: .infinity, maxHeight: 140)
    .background(.customWhite)
    .roundedCorners(12)
  }
}

