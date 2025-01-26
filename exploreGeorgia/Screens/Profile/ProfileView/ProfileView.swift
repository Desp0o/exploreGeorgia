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
    ZStack {
      Color.primaryWhite.ignoresSafeArea()
      
      if vm.isLoading {
        VStack {
          ProgressView()
            .scaleEffect(1.5)
            .tint(.customBlue)
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height)
      } else {
        ScrollView {
          VStack(spacing: 40) {
            Spacer()
            
            ProfileStatisticComponent()
            ProfileSettingsComponent()
            
            Button{
              vm.logOut()
            } label: {
              Text("Log out")
                .styledText(.customBlue, 16, .semibold)
            }
          }
          .padding(.horizontal, 20)
          .padding(.bottom, 20)
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .sheet(isPresented: $vm.isPresented) {
          EditProfile()
        }
        .onChange(of: vm.isPresented) { newValue in
          if !newValue {
            vm.fetchProfile()
          }
        }
      }
    }
    .onAppear {
      vm.fetchProfile()
    }
    .environmentObject(vm)
  }
}
