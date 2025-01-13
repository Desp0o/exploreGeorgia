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
    VStack(spacing: 30) {
      MainUserComponet(vm: vm)
        .padding(.leading, 20)
      
      MainViewTitleComponent()
        .padding(.leading, 20)
      
      PlacesFromAppComponents(vm: vm)
      
      Spacer()
    }
    .padding(.top, 10)
    .onAppear {
      vm.fetchCurrentUser()
    }
  }
}

#Preview {
  MainView()
}
