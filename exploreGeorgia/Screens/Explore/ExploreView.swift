//
//  ExploreView.swift
//  exploreGeorgia
//
//  Created by Despo on 15.01.25.
//

import SwiftUI

struct ExploreView: View {
  @StateObject var vm = ExploreViewModel()
  
  var body: some View {
    ZStack {
      Color.primaryWhite.ignoresSafeArea()
      
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
        }
      }
    }
  }
}

#Preview {
  ExploreView()
}
