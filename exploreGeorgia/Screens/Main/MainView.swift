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
  @StateObject private var viewModel = YourViewModel()

  var body: some View {
    ScrollView {
      VStack(spacing: 30) {
        
        VStack {
                    Button("Add Example Sight") {
                        viewModel.addNewSight()
                    }
                }
        
        MainUserComponet(vm: vm)
          .padding(.leading, 20)
        
        MainViewTitleComponent()
          .padding(.leading, 20)
        
        PlacesFromAppComponents(vm: vm)
        
        IntrestingFacts(vm: vm)
          .padding(.horizontal, 20)

        Spacer()
      }
      .padding(.top, 10)
      .onAppear {
        vm.getPopularPlaces()
        vm.fetchSingleFact()
      }
    }
    .scrollIndicators(.hidden)
  }
}

#Preview {
  MainView()
}
