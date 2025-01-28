//
//  MainScreenShimmer.swift
//  exploreGeorgia
//
//  Created by Despo on 26.01.25.
//

import SwiftUI

struct MainScreenShimmer: View {
  var body: some View {
    ZStack {
      Color.primaryWhite.ignoresSafeArea()
      
      VStack(spacing: 30) {
        
        HStack {
          ShimmerEffect()
            .frame(width: 80, height: 37)
            .clipShape(Capsule())
          
          Spacer()
        }
        
        VStack(alignment: .leading) {
          ShimmerEffect()
            .frame(width: 150, height: 30)
            .roundedCorners(6)
          
          ShimmerEffect()
            .frame(width: 200, height: 30)
            .roundedCorners(6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        VStack {
          HStack {
            ShimmerEffect()
              .frame(width: 150, height: 20)
              .roundedCorners(6)

            Spacer()
            ShimmerEffect()
              .frame(width: 50, height: 20)
              .roundedCorners(6)
          }
          
          HStack(spacing: 20) {
            ShimmerEffect()
              .frame(width: 268, height: 250)
              .roundedCorners(12)
            
            Spacer()
          }
        }
        
        VStack {
          HStack {
            ShimmerEffect()
              .frame(width: 150, height: 20)
              .roundedCorners(6)

            Spacer()
            
            ShimmerEffect()
              .frame(width: 50, height: 20)
              .roundedCorners(6)
          }
          
          ShimmerEffect()
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .roundedCorners(12)
          
          ShimmerEffect()
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .roundedCorners(12)
        }
        
        Spacer()
      }
      .padding(.top, 20)
      .padding(.horizontal, 20)
      .ignoresSafeArea()
    }
  }
}

#Preview {
  MainScreenShimmer()
}
