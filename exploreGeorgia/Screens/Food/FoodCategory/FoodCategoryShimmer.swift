//
//  FoodCategoryShimmer.swift
//  exploreGeorgia
//
//  Created by Despo on 31.01.25.
//

import SwiftUI

struct FoodCategoryShimmer: View {
  var body: some View {
    VStack {
      ScrollView {
        VStack(spacing: 50) {
          
          ShimmerEffect()
            .frame(width: 300, height: 30)
            .roundedCorners(6)
          
          
          VStack(spacing: 20) {
            ForEach(0...10, id: \.self) { _ in
              HStack(spacing: 20) {
                ShimmerEffect()
                  .frame(width: UIScreen.main.bounds.width / 2 - 30, height: 150)
                  .roundedCorners(12)
                
                ShimmerEffect()
                  .frame(width: UIScreen.main.bounds.width / 2 - 30, height: 150)
                  .roundedCorners(12)
              }
            }
          }
        }
        .padding(.top, 15)
      }
      .scrollDisabled(true)
    }
    .padding(.horizontal, 20)
  }
}

#Preview {
  FoodCategoryShimmer()
}
