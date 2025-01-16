//
//  PlacesFromAppComponents.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import SwiftUI

struct PlacesFromAppComponents: View {
  let data: [SightSeenModel]
  @State private var lastSelectedID: String?
  @State private var isSomethingChanged = false
  let collectionName: String
  
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
        
        NavigationLink {
          AllPopularPlaces()
            .navigationBarHidden(
              true
            )
        } label: {
          Text("View all")
            .styledText(.customVine, 14)
        }
      }
      .padding(.horizontal, 20)
      
      ScrollViewReader { proxy in
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: 20) {
            if data.isEmpty {
              ProgressView()
                .tint(.customBlue)
                .frame(width: UIScreen.main.bounds.width - 20, height: 200)
            } else {
              ForEach(data) { place in
                NavigationLink(
                  destination: PlaceDetailsView(
                    elementID: place.id ?? "",
                    collectionName: collectionName
                  )
                  .navigationBarHidden(true)
                ) {
                  SightSeenReusableView(
                    place: place,
                    maxWidth: 268,
                    height: 250
                  )
                }
                .onTapGesture {
                  lastSelectedID = place.id
                }
              }
            }
          }
          .padding(.horizontal, 20)
          .id(data)
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

//#Preview {
//  let vm = MainViewModel()
//  PlacesFromAppComponents(vm: vm)
//}
