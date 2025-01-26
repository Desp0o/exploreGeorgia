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
  @State private var isAppeared = false
  @State private var pageSize = 10
  @State private var startingOpacity: CGFloat = 0
  
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
                    }
                }
                
                if index == vm.fetchedPlaces.count - 4 {
                  Color.white.opacity(0)
                    .frame(width: 1, height: 0)
                    .onAppear {
                      pageSize += 10
                    }
                }
              }
              .id(vm.fetchedPlaces)
              
              if vm.isFetching {
                ProgressView()
                  .scaleEffect(1.2)
                  .padding(.top, 20)
                  .tint(.customBlue)
              }
            }
          }
        }
        .frame(maxWidth: .infinity)
      }
      .scrollIndicators(.hidden)
      .scrollBounceBehavior(.basedOnSize)
      
      AddButtonComponent(
        addButtonScale: $addButtonScale,
        isPresented: $isPresented,
        icon: .pluIcon
      )
      .scaleEffect(addButtonScale)
      .onAppear {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
          addButtonScale = 1.0
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    .onAppear {
      vm.fetchData(pageSize: pageSize)
    }
    .onChange(of: pageSize) { _ in
      vm.fetchData(pageSize: pageSize)
    }
    .fullScreenCover(isPresented: $isPresented) {
      AddPlaceView(isAppeared: $isAppeared)
        .background(.primaryWhite)
        .onDisappear {
          vm.fetchData(pageSize: pageSize)
        }
    }
    .overlay {
      if vm.isLoading {
        ExploreShimmer()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
}
