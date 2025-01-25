//
//  TourSuccessComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 20.01.25.
//

import SwiftUI

struct TourSuccessComponent: View {
  @ObservedObject var vm: TourViewModel
  
  var body: some View {
    ZStack {
      Color.black.opacity(0.8).ignoresSafeArea()
      
      VStack {
        ZStack {
          Image("purchasedTour")
            .resizable()
            .scaledToFill()
            .foregroundStyle(.white)
            .frame(width: 36, height: 36)
        }
        .frame(width: 70, height: 70)
        .background(.customBlue)
        .clipShape(Circle())
        
        Text("Congratulations, your adventure begins!")
          .styledText(.customBlue, 20, .bold, .center)
          .padding(.horizontal, 18)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .zIndex(99)
    .onTapGesture {
      withAnimation {
        vm.isSuccessfullyPurchased = false
      }
    }
  }
}

