//
//  PlacesFromUserComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 17.01.25.
//

import SwiftUI

struct PlacesFromUserComponent: View {
  @EnvironmentObject var vm: MainViewModel
  @Binding var tabIndex: Int
  
  var body: some View {
    VStack(spacing: 16) {
      HStack {
        Text("Explored Places")
          .styledText(.customBlack, 20, .bold)
        
        Spacer()
        
        Button {
          tabIndex = 1
        } label: {
          Text("View all")
            .styledText(.customGreen, 14)
        }
      }
      
      VStack(spacing: 20) {
        ForEach(vm.usersAddedPlacesData, id: \.id) { place in
          NavigationLink(
            destination: PlaceDetailsView(
              elementID: place.id ?? "",
              collectionName: .usersPlace,
              isNavigationDisabled: false
            )
            .navigationBarHidden(true)
          )
          {
            PlaceFromUserReusable(place: place)
          }
        }
      }
    }
  }
}
