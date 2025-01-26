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
        Spacer()
          .frame(height: 30)
        
        HStack {
          ShimmerEffect()
            .frame(width: 80, height: 37)
            .clipShape(Capsule())
          
          Spacer()
        }
                
        VStack(alignment: .leading) {
          ShimmerEffect()
            .frame(width: 150, height: 30)
          
          ShimmerEffect()
            .frame(width: 200, height: 30)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        VStack {
          ShimmerEffect()
            .frame(maxWidth: .infinity, maxHeight: 20)
            .frame(height: 20)
          
          HStack(spacing: 20) {
            ShimmerEffect()
              .frame(width: 268, height: 250)
              .roundedCorners(12)
            
            Spacer()
          }
        }
        
        VStack {
          ShimmerEffect()
            .frame(maxWidth: .infinity)
            .frame(height: 20)
          
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
      .padding(.top, 40)
      .padding(.horizontal, 20)
      
    }
  }
}

#Preview {
  MainScreenShimmer()
}
