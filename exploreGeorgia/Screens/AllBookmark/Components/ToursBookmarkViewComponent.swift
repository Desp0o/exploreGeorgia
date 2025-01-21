//
//  ToursBookmarkViewComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 21.01.25.
//

import SwiftUI

struct ToursBookmarkViewComponent: View {
  @ObservedObject var vm: AllBookmarkViewModel
  @State private var opacityPoint: CGFloat = 0
  let data: [TourModel]
  
  var body: some View {
    ForEach(Array(data.enumerated()), id: \.element) { index, tour in
      NavigationLink(destination:TourView(tourId: tour.id ?? "").navigationBarHidden(true)
      ) {
        SingleTourFeedView(tour: tour, tourMaxWidth: .infinity, isBookButtonVisible: true)
          .overlay {
            ZStack {
              Button {
                let indexSet = IndexSet(integer: index)
                withAnimation {
                  vm.removeTourBookmark(index: indexSet)
                }
              } label: {
                OverlayActionButtonIcon(iconName: "trash", tint: .white, scale: 0.8)
              }
              .frame(width: 36, height: 36)
              .padding(10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
          }
          .opacity(opacityPoint)
      }
    }
    .onAppear {
      withAnimation(.easeIn(duration: 0.2)) {
        opacityPoint = 1
      }
    }
  }
}




