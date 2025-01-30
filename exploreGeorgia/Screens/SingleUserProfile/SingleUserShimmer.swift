//
//  SingleUserShimmer.swift
//  exploreGeorgia
//
//  Created by Despo on 30.01.25.
//

import SwiftUI

struct SingleUserShimmer: View {
    var body: some View {
      ScrollView {
        VStack(spacing: 40) {
          
          VStack(spacing: 12) {
            ShimmerEffect()
              .frame(width: 120, height: 30)
              .roundedCorners(6)
            
            ShimmerEffect()
              .frame(width: 96, height: 96)
              .clipShape(Circle())
          }
          
          
          
          VStack(spacing: 20) {
            ForEach(0...6, id: \.self) { _ in
              ShimmerEffect()
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .roundedCorners(12)
            }
          }
          .padding(.horizontal, 20)
        }
      }
      .padding(.top, 25)
      .background(.primaryWhite)
    }
}

#Preview {
    SingleUserShimmer()
}
