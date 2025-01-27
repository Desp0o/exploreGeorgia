//
//  FoodViewShimmer.swift
//  exploreGeorgia
//
//  Created by Despo on 27.01.25.
//

import SwiftUI

struct FoodViewShimmer: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 30) {
        ShimmerEffect()
          .frame(width: 200, height: 30)
          .roundedCorners(6)
        
        VStack(spacing: 20) {
          HStack{
            ShimmerEffect()
              .frame(width: 180, height: 20)
              .roundedCorners(6)
            Spacer()
            ShimmerEffect()
              .frame(width: 100, height: 15)
              .roundedCorners(6)
          }
          
          
          HStack(spacing: 20) {
            VStack {
              ShimmerEffect()
                .frame(width: 170, height: 140)
                .roundedCorners(12)
              
              ShimmerEffect()
                .frame(width: 170, height: 15)
                .roundedCorners(6)
            }
            
            VStack {
              ShimmerEffect()
                .frame(width: 170, height: 140)
                .roundedCorners(12)
              
              ShimmerEffect()
                .frame(width: 170, height: 15)
                .roundedCorners(6)
            }
          }
          
          HStack(spacing: 20) {
            VStack {
              ShimmerEffect()
                .frame(width: 170, height: 140)
                .roundedCorners(12)
              
              ShimmerEffect()
                .frame(width: 170, height: 15)
                .roundedCorners(6)
            }
            
            VStack {
              ShimmerEffect()
                .frame(width: 170, height: 140)
                .roundedCorners(12)
              
              ShimmerEffect()
                .frame(width: 170, height: 15)
                .roundedCorners(6)
            }
          }
        }
        
        VStack(spacing: 20) {
          HStack{
            ShimmerEffect()
              .frame(width: 180, height: 20)
              .roundedCorners(6)
            Spacer()
            ShimmerEffect()
              .frame(width: 150, height: 15)
              .roundedCorners(6)
          }
          
          ShimmerEffect()
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .roundedCorners(12)
          ShimmerEffect()
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .roundedCorners(12)
          ShimmerEffect()
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .roundedCorners(12)
        }
        
        VStack(spacing: 20) {
          HStack{
            ShimmerEffect()
              .frame(width: 180, height: 20)
              .roundedCorners(6)
            Spacer()
            ShimmerEffect()
              .frame(width: 150, height: 15)
              .roundedCorners(6)
          }
          
          HStack(spacing: 20) {
            ShimmerEffect()
              .frame(width: 180, height: 180)
              .roundedCorners(12)
            ShimmerEffect()
              .frame(width: 180, height: 180)
              .roundedCorners(12)
          }
          
          HStack(spacing: 20) {
            ShimmerEffect()
              .frame(width: 180, height: 180)
              .roundedCorners(12)
            ShimmerEffect()
              .frame(width: 180, height: 180)
              .roundedCorners(12)
          }
        }
      }
      .padding(.horizontal, 20)
    }
    .scrollDisabled(true)
    .background(.primaryWhite)
  }
}

#Preview {
  FoodViewShimmer()
}
