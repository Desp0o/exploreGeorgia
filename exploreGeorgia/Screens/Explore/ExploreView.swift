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
  @State private var isSomethingChanged = false
  
  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      Color.primaryWhite.ignoresSafeArea()
      
      ScrollViewReader { proxy in
        ScrollView {
          LazyVStack {
            ForEach(vm.fetchedPlaces, id: \.id) { place in
              
              NavigationLink(
                destination: PlaceDetailsView(
                  elementID: place.id ?? "",
                  collectionName: "usersPlaces"
                ).navigationBarHidden(true)
              ) {
                SightSeenReusableView(
                  place: place,
                  maxWidth: 268,
                  height: 250
                )
              }
            }
            .id(vm.fetchedPlaces)
            .id(isSomethingChanged)
          }
        }
      }
      
      
      AddButtonComponent(
        addButtonScale: $addButtonScale,
        isPresented: $isPresented
      )
      
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    .onAppear {
      vm.fetchData()
      isSomethingChanged.toggle()
    }
    .onChange(of: isAppeared) { _ in
      vm.fetchData()
    }
    .fullScreenCover(isPresented: $isPresented) {
      AddPlaceView(isAppeared: $isAppeared)
        .background(.primaryWhite)
    }
  }
}
