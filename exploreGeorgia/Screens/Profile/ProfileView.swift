//
//  ProfileView.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUI

struct ProfileView: View {
  @StateObject var vm = ProfileViewModel()
  
  var body: some View {
    if vm.isLoading {
      VStack {
        ProgressView()
          .scaleEffect(2.0)
          .tint(.customBlue)
      }
      .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height)
    } else {
      ScrollView {
        VStack(spacing: 40) {
          Spacer()
          
          ProfileStatistic(
            user: vm.user,
            statisticArray: vm.profileStatistic
          )
          
          ProfileSettings(settingsArray: vm.settingsArray)
          
          Button{
            vm.logOut()
          } label: {
            Text("Log out")
              .styledText(
                .customBlue,
                16,
                .semibold
              )
          }
        }
        .padding(.horizontal, 20)
      }
      .scrollIndicators(.hidden)
      .scrollBounceBehavior(.basedOnSize)
    }
  }
}

#Preview {
  ProfileView()
}
