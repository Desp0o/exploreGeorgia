//
//  TourCoverComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 18.01.25.
//

import SwiftUI

struct TourCoverComponent: View {
  @ObservedObject var vm: TourViewModel
  
  var body: some View {
    ZStack(alignment: .bottomLeading) {
      CachedAsyncImage(url: URL(string: vm.tour?.cover ?? ""))
        .frame(width: UIScreen.main.bounds.width, height: 315)
        .roundedCorners(12)
      
      VStack(alignment: .leading, spacing: 0) {
        Text(vm.tour?.name ?? "")
          .styledText(.white, 24, .semibold)
        
        HStack {
          Image("locationPin")
            .renderingMode(.template)
            .foregroundStyle(.white)
          
          Text(vm.tour?.adress ?? "")
            .styledText(.white, 18)
          
          Spacer()
        }
      }
      .padding(.leading, 20)
      .padding(.bottom, 20)
    }
    .overlay {
      ZStack() {
        PlaceDetailsNavigationBar(isBookMarked: $vm.isBookMarked, placeID: vm.tour?.id ?? "")
      }
      .frame(maxHeight: .infinity, alignment: .top)
    }
  }
}
