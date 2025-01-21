//
//  PlacesBookmarkViewComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 21.01.25.
//

import SwiftUI

struct PlacesBookmarkViewComponent: View {
  @ObservedObject var vm: AllBookmarkViewModel
  @State private var opacityPoint: CGFloat = 0
  let data: [SightSeenModel]
  let collectionName: String
  
  
  var body: some View {
    ForEach(Array(data.enumerated()), id: \.element) { index, place in
      ZStack {
        HStack {
          Spacer()
          
          Button {
            let indexSet = IndexSet(integer: index)
            withAnimation {
              vm.removeBookmark(index: indexSet)
            }
          } label: {
            VStack {
              Image(systemName: "trash")
                .renderingMode(.template)
                .foregroundStyle(.white)
                .offset(x: 5)
            }
            .frame(width: 54, height: 212)
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
        
        NavigationLink(
          destination: PlaceDetailsView(
            elementID: place.id ?? "",
            collectionName: collectionName
          ).navigationBarHidden(true)
        ) {
          SightSeenReusableView(
            place: place,
            maxWidth: UIScreen.main.bounds.width - 80,
            height: 130,
            isBookmarkIconHidden: true
          )
        }
        .padding(.trailing, 40)
      }
      .opacity(opacityPoint)
    }
    .onAppear {
      withAnimation(.easeIn(duration: 0.2)) {
        opacityPoint = 1
      }
    }
  }
}
