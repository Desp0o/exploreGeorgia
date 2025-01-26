//
//  PlacesFromAppComponents.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import SwiftUI

struct PlacesFromAppComponents: View {
  @EnvironmentObject var vm: MainViewModel
  @State private var lastSelectedID: String?
  @State private var isSomethingChanged = false
  
  var body: some View {
    VStack(spacing: 5) {
      HStack {
        Text("Popular Destinations")
          .styledText(.customBlack, 20, .bold)
        
        Spacer()
        
        NavigationLink {
          AllPopularPlaces()
            .navigationBarHidden(true)
        } label: {
          Text("View all")
            .styledText(.customBlue, 14)
        }
      }
      .padding(.horizontal, 20)
      
      ScrollViewReader { proxy in
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: 20) {
            if vm.placesFromApp.isEmpty {
              ProgressView()
                .tint(.customBlue)
                .frame(width: UIScreen.main.bounds.width - 20, height: 200)
            } else {
              ForEach(vm.placesFromApp, id: \.id) { place in
                NavigationLink(
                  destination: PlaceDetailsView(
                    elementID: place.id ?? "",
                    collectionName: .appPlace,
                    isNavigationDisabled: true
                  ).navigationBarHidden(true)
                ) {
                  SightSeenReusableView(
                    place: place,
                    maxWidth: 268,
                    height: 250,
                    isBookmarkIconHidden: false
                  )
                }
                .onTapGesture {
                  lastSelectedID = place.id
                }
              }
            }
          }
          .padding(.horizontal, 20)
          .id(vm.placesFromApp)
          .id(isSomethingChanged)
        }
        .frame(height: 350)
        .onAppear {
          isSomethingChanged.toggle()
          if let id = lastSelectedID {
            proxy.scrollTo(id, anchor: .leading)
          }
        }
      }
    }
  }
}
