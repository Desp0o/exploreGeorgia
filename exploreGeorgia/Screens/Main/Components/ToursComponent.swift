//
//  ToursComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 20.01.25.
//

import SwiftUI

struct ToursComponent: View {
  @EnvironmentObject var vm: MainViewModel
  
  var body: some View {
    VStack {
      HStack {
        Text("Popular Tours")
          .styledText(.customBlack, 20, .bold)
        
        Spacer()
        
        NavigationLink {
          AllToursView()
            .navigationBarHidden(true)
        } label: {
          Text("View all")
            .styledText(.customGreen, 14)
        }
      }
      
      if !vm.fetchedTours.isEmpty {
        VStack(spacing: 20) {
          HStack(spacing: 20) {
            NavigationLink {
              TourView(tourId: vm.fetchedTours[0].id ?? "")
                .navigationBarHidden(true)
            } label: {
              SingleTourFeedView(tour: vm.fetchedTours[0], tourMaxWidth: UIScreen.main.bounds.width / 2 - 30, isBookButtonVisible: false)
            }
            
            NavigationLink {
              TourView(tourId: vm.fetchedTours[1].id ?? "")
                .navigationBarHidden(true)
            } label: {
              SingleTourFeedView(tour: vm.fetchedTours[1], tourMaxWidth: UIScreen.main.bounds.width / 2 - 30, isBookButtonVisible: false)
            }
          }
          
          NavigationLink {
            TourView(tourId: vm.fetchedTours[2].id ?? "").navigationBarHidden(true)
          } label: {
            SingleTourFeedView(tour: vm.fetchedTours[2], tourMaxWidth: .infinity, isBookButtonVisible: true)
          }
        }
      }
    }
  }
}
