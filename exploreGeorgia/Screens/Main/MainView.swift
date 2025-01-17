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
        
        MainUserComponet(vm: vm)
          .padding(.leading, 20)
        
        MainViewTitleComponent()
          .padding(.leading, 20)
        
        PlacesFromAppComponents(vm: vm)
        
        IntrestingFacts(vm: vm)
          .padding(.horizontal, 20)
        
        PlacesFromUserComponent(vm: vm, tabIndex: $tabIndex)
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
  }
}
