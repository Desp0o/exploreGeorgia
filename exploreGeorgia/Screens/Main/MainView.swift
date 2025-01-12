//
//  MainView.swift
//  exploreGeorgia
//
//  Created by Despo on 05.01.25.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
  @StateObject var vm = MainViewModel()
  
  var body: some View {
    VStack{
      MainViewTitleComponent()
      

      ScrollView(.horizontal, showsIndicators: false) {
                  LazyHStack {
                      if vm.placesFromApp.isEmpty {
                          // Show loading or empty state
                          ProgressView()
                              .frame(width: 300, height: 200)
                      } else {
                          ForEach(vm.placesFromApp) { place in
                              SightSeenReusableView(
                                  cover: place.cover,
                                  name: place.name,
                                  locationRegion: place.region,
                                  rating: place.rating,
                                  price: place.price
                              )
                          }
                        
                      }
                  }
              }
      
      
      
      
      
    }
    .padding(.all, 20)
  }
}

#Preview {
  MainView()
}
