//
//  PlacesFromAppComponents.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import SwiftUI

struct PlacesFromAppComponents: View {
  @EnvironmentObject var vm: MainViewModel
  
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
            .styledText(.customGreen, 14)
        }
      }
      .padding(.horizontal, 20)
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 20) {
          if vm.placesFromApp.isEmpty {
            ProgressView()
              .tint(.customGreen)
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
                  height: 250
                )
              }
            }
          }
        }
        .padding(.horizontal, 20)
        .frame(height: 350)
      }
    }
  }
}
