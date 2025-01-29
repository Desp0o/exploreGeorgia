//
//  ProfileView.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUI

struct ProfileView: View {
  @StateObject var vm = ProfileViewModel()
  @StateObject var editViewModel = EditProfileViewModel()
  @ObservedObject private var toastManager = ToastManager()
  @State private var toastMessage = ""
  @State private var toastBgColor = ToastTypes.successfully

  private let isSmallSize = UIScreen.main.bounds.height <= 700

  var body: some View {
    ZStack {
      Color.primaryWhite.ignoresSafeArea()
      
      if toastManager.isShown {
        VStack {
          ToastView(
            message: toastMessage,
            bgColor: toastBgColor
          )
          
          Spacer()
        }
        .padding(.horizontal, 20)
        .zIndex(4)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      ScrollView {
        VStack(spacing: 40) {
          Spacer()
          
          ProfileStatisticComponent()
          ProfileSettingsComponent()
          
          Button{
            vm.logOut()
          } label: {
            Text("Log out")
              .styledText(.customGreen, 16, .semibold)
          }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
      }
      .scrollIndicators(.hidden)
      .scrollBounceBehavior(.basedOnSize)
      .sheet(isPresented: $vm.isPresented) {
        UserInfoUpdateComponent(editViewModel: editViewModel)
          .presentationDetents([.fraction(isSmallSize ? 0.52 : 0.42)])
      }
      .sheet(isPresented: $vm.isSecurotyPresented) {
        ProfilePrivacyComponent(editViewModel: editViewModel)
          .presentationDetents(
            [.fraction(
              editViewModel.isUserFromGoogle ? 0.22 : (isSmallSize ? 0.7 : 0.7)
            )]
          )
      }
      .sheet(isPresented: $vm.isAppereancePresented) {
        ThemeTogglerComponent()
          .ignoresSafeArea()
          .presentationDetents([.fraction(isSmallSize ? 0.15 : 0.1)])
      }
      .sheet(isPresented: $vm.isDeleteAccPresented) {
        UserDeleteComponent()
          .presentationDetents([.fraction(isSmallSize ? 0.25 : 0.2)])
      }
    }
    .overlay {
      if vm.isLoading {
        ProfileViewShimmer()
      }
    }
    .onAppear {
      vm.fetchProfile()
    }
    .onChange(of: vm.isPresented) { newValue in
      if !newValue {
        vm.fetchProfile()
      }
    }
    .onReceive(editViewModel.$completionMessage, perform: { message in
      if !message.isEmpty {
        toastBgColor = .successfully
        toastMessage = message
        toastManager.showToast()
      }
    })
    .onReceive(editViewModel.$errorMessage, perform: { message in
      if !message.isEmpty {
        toastBgColor = .error
        toastMessage = message
        toastManager.showToast()
      }
    })
    .environmentObject(vm)
  }
}
