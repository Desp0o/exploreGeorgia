//
//  PlacesFromAppComponents.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import SwiftUI

struct PlacesFromAppComponents: View {
  @ObservedObject var vm: MainViewModel
  @State private var lastSelectedID: String?
  
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
      
      ScrollViewReader { proxy in
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: 20) {
            if vm.placesFromApp.isEmpty {
              ProgressView()
                .tint(.customBlue)
                .frame(width: UIScreen.main.bounds.width - 20, height: 200)
            } else {
              ForEach(vm.placesFromApp.prefix(1)) { place in
                NavigationLink(
                  destination: PlaceDetailsView(
                    elementID: place.id ?? ""
                  )
                  .navigationBarHidden(
                    true
                  )
                ) {
                  SightSeenReusableView(
                    place: place
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
        }
        .frame(height: 350)
        .onAppear {
          if let id = lastSelectedID {
            proxy.scrollTo(id, anchor: .leading)
          }
        }
      }
    }
  }
}

#Preview {
  let vm = MainViewModel()
  PlacesFromAppComponents(vm: vm)
}
