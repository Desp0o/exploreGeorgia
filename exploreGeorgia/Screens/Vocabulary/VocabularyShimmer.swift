//
//  VocabularyShimmer.swift
//  exploreGeorgia
//
//  Created by Despo on 28.01.25.
//

import SwiftUI

struct VocabularyShimmer: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        VStack(spacing: 20) {
          ShimmerEffect()
            .frame(width: 310, height: 20)
            .roundedCorners(12)
          
          ShimmerEffect()
            .frame(width: 350, height: 40)
            .roundedCorners(12)
        }.padding(.top, 35)
        
        VStack(spacing: 30) {
          ForEach(0...15, id: \.self) { _ in
            ShimmerEffect()
              .frame(maxWidth: .infinity)
              .frame(height: 55)
              .roundedCorners(12)
          }
        }
        .padding(.top, 30)
        .padding(.horizontal, 30)
      }
    }
  }
}

#Preview {
  VocabularyShimmer()
}
