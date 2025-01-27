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
  private let isSmallSize = UIScreen.main.bounds.height <= 700
  @State private var toastMessage = ""
  @State private var toastBgColor = ToastTypes.successfully
  
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
          UserInfoUpdateComponent(editViewModel: editViewModel)
            .ignoresSafeArea()
            .presentationDetents([.fraction(isSmallSize ? 0.52 : 0.42)])
        }
        .sheet(isPresented: $vm.isPrivacyPresented) {
          ProfilePrivacyComponent(editViewModel: editViewModel)
            .ignoresSafeArea()
            .presentationDetents(
              [.fraction(
                editViewModel.isUserFromGoogle ? 0.22 : (isSmallSize ? 0.7 : 0.53)
              )]
            )
        }
        .sheet(isPresented: $vm.isAppereancePresented) {
          ThemeTogglerComponent()
            .ignoresSafeArea()
            .presentationDetents([.fraction(isSmallSize ? 0.15 : 0.1)])
        }
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
