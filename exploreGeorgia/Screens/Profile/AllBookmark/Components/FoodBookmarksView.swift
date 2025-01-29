//
//  FoodBookmarksView.swift
//  exploreGeorgia
//
//  Created by Despo on 26.01.25.
//

import SwiftUI

import SwiftUI

struct FoodBookmarksView: View {
  @EnvironmentObject var vm: AllBookmarkViewModel
  @State private var opacityPoint: CGFloat = 0
  let collection: FirebaseCollectionEnum
  
  var body: some View {
    if vm.bookmarkedFoods.isEmpty {
      NoBookmarksComponent()
    } else {
      LazyVStack(spacing: 20) {
        ForEach(Array(vm.bookmarkedFoods.enumerated()), id: \.element) { index, resturant in
          NavigationLink(destination: ResturantView(place: resturant, collection: collection)
            .navigationBarHidden(true)
          ) {
            FoodViewSingleComponent(
              cover: resturant.cover,
              name: resturant.name,
              type: resturant.type,
              elementWidth: .infinity
            )
              .overlay {
                ZStack {
                  Button {
                    let indexSet = IndexSet(integer: index)
                    withAnimation {
                      vm.removeFoodBookmark(index: indexSet)
                    }
                  } label: {
                    OverlayActionButtonIcon(iconName: .trash, scale: 0.8)
                  }
                  .frame(width: 36, height: 36)
                  .padding(10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
              }
              .opacity(opacityPoint)
          }
          .onAppear {
            if index == vm.bookmarkedFoods.count {
              
              vm.fetchFoods(pageLimit: 10, collectionName: collection)
            }
          }
        }
        .onAppear {
          withAnimation(.easeIn(duration: 0.2)) {
            opacityPoint = 1
          }
        }
      }
      .padding(.horizontal, 20)
      .padding(.bottom, 20)
    }
  }
}




