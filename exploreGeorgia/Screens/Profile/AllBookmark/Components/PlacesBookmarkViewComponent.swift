//
//  PlacesBookmarkViewComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 21.01.25.
//

import SwiftUI

struct PlacesBookmarkViewComponent: View {
  @EnvironmentObject var vm: AllBookmarkViewModel
  @State private var opacityPoint: CGFloat = 0
  let collectionName: FirebaseCollectionEnum
  
  var body: some View {
    if vm.bookmarkedPlaces.isEmpty {
      NoBookmarksComponent()
    } else {
      LazyVStack(spacing: 20) {
        ForEach(Array(vm.bookmarkedPlaces.enumerated()), id: \.element) { index, place in
          NavigationLink(
            destination: PlaceDetailsView(
              elementID: place.id ?? "",
              collectionName: collectionName,
              isNavigationDisabled: false
            ).navigationBarHidden(true)
          ) {
            SightSeenReusableView(
              place: place,
              maxWidth: UIScreen.main.bounds.width - 40,
              height: 130,
              isBookmarkIconHidden: true
            )
            .overlay {
              ZStack {
                Button {
                  let indexSet = IndexSet(integer: index)
                  withAnimation {
                    vm.removeBookmark(index: indexSet)
                  }
                } label: {
                  OverlayActionButtonIcon(iconName: .trash, tint: .white, scale: 0.8)
                }
                .frame(width: 36, height: 36)
                .padding(20)
              }
              .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
            .opacity(opacityPoint)
          }
          .onAppear {
            if index == vm.bookmarkedPlaces.count - 1 {
              vm.pageSize += 10
              vm.fetchData(pageLimit: vm.pageSize, collectionName: collectionName)
              print(vm.bookmarkedPlaces.count)
            }
          }
        }
        .onAppear {
          withAnimation(.easeIn(duration: 0.2)) {
            opacityPoint = 1
          }
        }
      }
      .padding(.bottom, 20)
    }
  }
}
