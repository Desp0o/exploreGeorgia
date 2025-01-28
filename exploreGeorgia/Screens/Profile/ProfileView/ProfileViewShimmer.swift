//
//  ProfileViewShimmer.swift
//  exploreGeorgia
//
//  Created by Despo on 28.01.25.
//

import SwiftUI

struct ProfileViewShimmer: View {
    var body: some View {
      VStack {
        ScrollView {
          VStack {
            Spacer()
              .frame(height: 50)
            
            ShimmerEffect()
              .frame(width: 96, height: 96)
              .clipShape(Circle())
            
            VStack {
              ShimmerEffect()
                .frame(width: 100, height: 20)
                .roundedCorners(6)
            }
            
            Spacer()
              .frame(height: 50)
            
            ShimmerEffect()
              .frame(maxWidth: .infinity)
              .frame(height: 60)
              .roundedCorners(12)
            
            Spacer()
              .frame(height: 40)
            
            ShimmerEffect()
              .frame(maxWidth: .infinity)
              .frame(height: 800)
              .roundedCorners(12)
          }
          .padding(.horizontal, 20)
        }
        .scrollDisabled(true)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(.primaryWhite)
    }
}

#Preview {
    ProfileViewShimmer()
}
