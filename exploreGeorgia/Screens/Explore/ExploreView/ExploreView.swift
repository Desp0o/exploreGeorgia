//
//  ExploreView.swift
//  exploreGeorgia
//
//  Created by Despo on 15.01.25.
//

import SwiftUI

struct ExploreView: View {
  @StateObject var vm = ExploreViewModel()
  @State private var isPresented = false
  @State private var addButtonScale: CGFloat = 0
  @State private var startingOpacity: CGFloat = 0
  @State var isNewPlaceAdded = false
  
  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      Color.primaryWhite.ignoresSafeArea()
      
      ScrollView {
        VStack {
          if !vm.fetchedPlaces.isEmpty {
            ScreenMainTitle(
              mainTitle: "Discover Real Adventures",
              subTitle: "Share Your Journey..."
            )
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            LazyVStack(spacing: 20) {
              ForEach(vm.fetchedPlaces.indices, id: \.self) { index in
                let place = vm.fetchedPlaces[index]
                
                NavigationLink(
                  destination: PlaceDetailsView(
                    elementID: place.id ?? "",
                    collectionName: .usersPlace,
                    isNavigationDisabled: false
                  ).navigationBarHidden(true)
                ) {
                  PlaceFromUserReusable(place: place)
                    .frame(width: UIScreen.main.bounds.width - 40)
                    .opacity(startingOpacity)
                    .onAppear {
                      withAnimation(.easeOut(duration: 0.5)) {
                        startingOpacity = 1
                      }
                      
                      if index == vm.fetchedPlaces.count - 2 {
                        vm.fetchData()
                      }
                    }
                }
              }
              .id(vm.fetchedPlaces)
            }
          }
        }
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
      }
      .scrollIndicators(.hidden)
      .scrollBounceBehavior(.basedOnSize)
      
      AddButtonComponent(
        addButtonScale: $addButtonScale,
        isPresented: $isPresented,
        icon: .pluIcon
      )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    .fullScreenCover(isPresented: $isPresented) {
      AddPlaceView(isNewPlaceAdded: $isNewPlaceAdded)
        .background(.primaryWhite)
        .onDisappear {
          if isNewPlaceAdded {
            vm.reFetchData()
          }
          isNewPlaceAdded =  false
        }
    }
    .overlay {
      if vm.isFetching {
        ProgressView()
          .scaleEffect(1.5)
          .tint(.customGreen)
      }
      if vm.isLoading {
        ExploreShimmer()
      }
    }
  }
}
