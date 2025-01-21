//
//  ToursBookmarkViewComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 21.01.25.
//

import SwiftUI

struct ToursBookmarkViewComponent: View {
  @ObservedObject var vm: AllBookmarkViewModel
  let data: [TourModel]
  
  var body: some View {
    ForEach(Array(data.enumerated()), id: \.element) { index, tour in
      ZStack {
        HStack {
          Spacer()
          
          Button {
            let indexSet = IndexSet(integer: index)
            withAnimation {
              vm.removeTourBookmark(index: indexSet)
            }
          } label: {
            VStack {
              Image(systemName: "trash")
                .renderingMode(.template)
                .foregroundStyle(.white)
                .offset(x: 5)
            }
            .frame(width: 54, height: 150)
          }
          .background(.red)
          .clipShape(
            .rect(
              topLeadingRadius: 0,
              bottomLeadingRadius: 0,
              bottomTrailingRadius: 12,
              topTrailingRadius: 12
            )
          )
        }
        
        NavigationLink(destination:TourView(tourId: tour.id ?? "").navigationBarHidden(true)
        ) {
          SingleTourFeedView(tour: tour, tourMaxWidth: UIScreen.main.bounds.width - 80, isBookButtonVisible: true)
        }
        .padding(.trailing, 40)
      }
    }
  }
}
