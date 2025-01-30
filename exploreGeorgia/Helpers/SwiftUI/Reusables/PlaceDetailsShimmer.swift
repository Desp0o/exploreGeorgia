//
//  PlaceDetailsShimmer.swift
//  exploreGeorgia
//
//  Created by Despo on 27.01.25.
//

import SwiftUI

struct PlaceDetailsShimmer: View {
  var body: some View {
    
    VStack(alignment: .leading, spacing: 20) {
      ScrollView {
        VStack {
          ShimmerEffect()
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height * 0.4)
            .roundedCorners(12)
          
          VStack(alignment: .leading, spacing: 10) {
            ShimmerEffect()
              .frame(width: 200, height: 20)
              .roundedCorners(6)
            
            ShimmerEffect()
              .frame(width: 100, height: 10)
              .roundedCorners(3)
            
            HStack {
              ShimmerEffect()
                .frame(width: 50, height: 10)
                .roundedCorners(3)
              Spacer()
              ShimmerEffect()
                .frame(width: 50, height: 10)
                .roundedCorners(3)
              Spacer()
              ShimmerEffect()
                .frame(width: 50, height: 10)
                .roundedCorners(3)
            }
            
            HStack(spacing: 20) {
              ForEach(0..<5, id: \.self) { _ in
                ShimmerEffect()
                  .frame(width: 50, height: 50)
                  .roundedCorners(12)
              }
            }
            .padding(.top, 10)
            
            VStack {
              ForEach(0...20, id: \.self) { _ in
                ShimmerEffect()
                  .frame(maxWidth: .infinity)
                  .frame(height: 10)
                  .roundedCorners(12)
              }
            }
          }
        }
      }
      .scrollDisabled(true)
    }
    .padding(.horizontal, 20)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .background(.primaryWhite)
  }
}

#Preview {
  PlaceDetailsShimmer()
}
