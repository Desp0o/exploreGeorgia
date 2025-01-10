//
//  ProfileView.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUI

struct ProfileView: View {
  @StateObject var vm = ProfileViewModel()
  @State var isPresented = false
  
  var body: some View {
    ZStack {
      Color.primaryWhite.ignoresSafeArea()
      
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
            
            ProfileSettings(isPresented: $isPresented)
            
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
        .sheet(isPresented: $isPresented) {
          EditProfile()
        }
        .onChange(of: isPresented, { oldValue, newValue in
          if !newValue {
            vm.fetchProfile()
          }
        })
      }
    }
  }
}

#Preview {
  ProfileView()
}
