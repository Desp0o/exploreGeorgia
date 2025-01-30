//
//  ExploreShimmer.swift
//  exploreGeorgia
//
//  Created by Despo on 26.01.25.
//

import SwiftUI

struct ExploreShimmer: View {
    var body: some View {
      VStack(spacing: 30) {
        ScrollView {
          VStack {
            Spacer()
              .frame(height: 20)
            
            VStack {
              ShimmerEffect()
                .frame(width: 300, height: 20)
                .roundedCorners(6)
              
              ShimmerEffect()
                .frame(width: 140, height: 15)
                .roundedCorners(6)
            }
            
            VStack(spacing: 20) {
              ForEach(0...5, id: \.self) { _ in
                ShimmerEffect()
                  .frame(maxWidth: .infinity)
                  .frame(height: 100)
                  .roundedCorners(12)
              }
            }
          }
        }
        .scrollDisabled(true)
      }
      .padding(.horizontal, 20)
    }
}

#Preview {
    ExploreShimmer()
}
