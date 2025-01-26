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
  @Binding var tabIndex: Int
  
  var body: some View {
    ScrollView {
      VStack(spacing: 30) {
        Group {
          MainUserComponet()
          MainViewTitleComponent()
        }
        .padding(.leading, 20)
        
        PlacesFromAppComponents()
        
        Group {
          IntrestingFacts()
          PlacesFromUserComponent(tabIndex: $tabIndex)
          ToursComponent()
        }
        .padding(.horizontal, 20)
        
        Spacer()
      }
      .padding(.top, 10)
      .onAppear {
        vm.getPopularPlaces()
        vm.fetchSingleFact()
        vm.fetchUsersAddedPlaces()
      }
    }
    .scrollIndicators(.hidden)
    .background(.primaryWhite)
    .environmentObject(vm)
    .overlay {
      if vm.isLoading {
        MainScreenShimmer()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
}
