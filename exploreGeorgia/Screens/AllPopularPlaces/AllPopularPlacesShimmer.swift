//
//  AllPopularPlacesShimmer.swift
//  exploreGeorgia
//
//  Created by Despo on 28.01.25.
//

import SwiftUI

struct AllPopularPlacesShimmer: View {
    var body: some View {
      ScrollView {
        VStack(spacing: 20) {
          VStack {
            ShimmerEffect()
              .frame(width: 260, height: 30)
              .roundedCorners(6)
            ShimmerEffect()
              .frame(width: 150, height: 20)
              .roundedCorners(6)
          }
          
          VStack(spacing: 20) {
            HStack(spacing: 20) {
              ShimmerEffect()
                .frame(width: 160, height: 240)
                .roundedCorners(12)
              ShimmerEffect()
                .frame(width: 160, height: 240)
                .roundedCorners(12)
            }
            
            HStack(spacing: 20) {
              ShimmerEffect()
                .frame(width: 160, height: 240)
                .roundedCorners(12)
              ShimmerEffect()
                .frame(width: 160, height: 240)
                .roundedCorners(12)
            }
            
            HStack(spacing: 20) {
              ShimmerEffect()
                .frame(width: 160, height: 240)
                .roundedCorners(12)
              ShimmerEffect()
                .frame(width: 160, height: 240)
                .roundedCorners(12)
            }
            
            HStack(spacing: 20) {
              ShimmerEffect()
                .frame(width: 160, height: 240)
                .roundedCorners(12)
              ShimmerEffect()
                .frame(width: 160, height: 240)
                .roundedCorners(12)
            }
            
            HStack(spacing: 20) {
              ShimmerEffect()
                .frame(width: 160, height: 240)
                .roundedCorners(12)
              ShimmerEffect()
                .frame(width: 160, height: 240)
                .roundedCorners(12)
            }
            
            HStack(spacing: 20) {
              ShimmerEffect()
                .frame(width: 160, height: 240)
                .roundedCorners(12)
              ShimmerEffect()
                .frame(width: 160, height: 240)
                .roundedCorners(12)
            }
          }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primaryWhite)
      }
      .scrollDisabled(true)
      .padding(.top, 20)
    }
}

#Preview {
    AllPopularPlacesShimmer()
}
