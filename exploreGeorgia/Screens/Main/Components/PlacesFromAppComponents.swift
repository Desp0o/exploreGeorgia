//
//  PlacesFromAppComponents.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import SwiftUI

struct PlacesFromAppComponents: View {
  @ObservedObject var vm: MainViewModel
  
  var body: some View {
    VStack(spacing: 5) {
      HStack {
        Text("Popular Destinations")
          .styledText(
            .customBlack,
            20,
            .bold
          )
        
        Spacer()
        
        Button {
          
        } label: {
          Text("View all")
            .styledText(
              .customVine,
              14
            )
        }
      }
      .padding(.horizontal, 20)
      
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack( spacing: 20) {
          if vm.placesFromApp.isEmpty {
            ProgressView()
              .frame(width: 300, height: 200)
          } else {
            ForEach(vm.placesFromApp) { place in
              NavigationLink(destination: PlaceDetailsView(elementID: place.id ?? "").navigationBarHidden(true)) {
                SightSeenReusableView(place: place)
              }
            }
          }
        }
        .padding(.horizontal, 20)
      }
      .frame(height: 350)
    }
  }
}

#Preview {
  let vm = MainViewModel()
  PlacesFromAppComponents(vm: vm)
}
