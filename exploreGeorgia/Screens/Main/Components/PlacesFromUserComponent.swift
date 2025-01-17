//
//  PlacesFromUserComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 17.01.25.
//

import SwiftUI

struct PlacesFromUserComponent: View {
  @ObservedObject var vm: MainViewModel
  @Binding var tabIndex: Int
  
  var body: some View {
    VStack(spacing: 16) {
      HStack {
        Text("Popular Destinations")
          .styledText(
            .customBlack,
            20,
            .bold
          )
        
        Spacer()
        
        Button {
          tabIndex = 1
        } label: {
          Text("View all")
            .styledText(.customVine, 14)
        }
      }
      
      LazyVStack(spacing: 16) {
        ForEach(vm.usersAddedPlacesData, id: \.id) { place in
          NavigationLink(destination: PlaceDetailsView(elementID: place.id ?? "", collectionName: "usersPlaces").navigationBarHidden(true)) {
            PlaceFromUserReusable(place: place)
          }
        }
      }
    }
  }
}
