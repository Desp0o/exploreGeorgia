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
        
        VStack(alignment: .leading) {
          HStack {
            Text("Did you know")
              .styledText(
                .customBlue,
                20,
                .semibold
              )
            Image(systemName: "lightbulb.max.fill")
              .foregroundStyle(.yellow)
          }
          Text("The longest hiking rouad is in Svaneti")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.all, 12)
        .background(.customWhite)
        .roundedCorners(12)
        .padding(.horizontal, 20)
        
        Spacer()
      }
      .padding(.top, 10)
      .onAppear {
        vm.fetchCurrentUser()
      }
    }
    .scrollIndicators(.hidden)
  }
}

#Preview {
  MainView()
}
