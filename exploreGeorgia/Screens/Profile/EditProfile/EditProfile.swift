//
//  EditProfile.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUI

struct EditProfile: View {
  @Environment(\.colorScheme) var colorScheme
  @StateObject private var vm = EditProfileViewModel()
  @ObservedObject private var toastManager = ToastManager()
  @ObservedObject private var alertManager = CustomAlertManager()
  @State private var toastMessage = ""
  @State private var alertBoxMessage = ""
  
  var body: some View {
    ZStack(alignment: .top) {
      Color.primaryWhite.ignoresSafeArea()
      
      if toastManager.isShown {
        ToastView(
          message: toastMessage,
          bgColor: .successfully
        )
      }
      
      if alertManager.isShown {
        CustomAlert(
          alertManager: alertManager,
          alertMessage: alertBoxMessage,
          errorType: .error
        )
        .zIndex(999)
      }
      
      VStack{
        if vm.isUpdatignInfo {
          ProgressView()
            .scaleEffect(1.5)
            .tint(.customBlue)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .zIndex(99)
      
      ScrollView {
        if vm.isLoading {
          VStack {
            ProgressView()
              .scaleEffect(1.5)
              .tint(.customBlue)
          }
          .frame(maxWidth: .infinity)
          .padding(.top, 200)
          
        } else {
          VStack(spacing: 50) {
            UserAvatarChangeComponent()
            UserInfoUpdateComponent()
            
            if !vm.isUserFromGoogle {
              UserPasswordChangeComponent()
            }
            
            VStack(spacing: 20) {
              ThemeTogglerComponent()
              LanguageSelectorComponent()
            }
            
            UserDeleteComponent()
          }
          .padding(.horizontal, 20)
        }
      }
      .scrollBounceBehavior(.basedOnSize)
      .scrollIndicators(.hidden)
    }
    .preferredColorScheme(vm.isDarkTheme ? .dark : .light)
    .onReceive(vm.$completionMessage) { message in
      if !message.isEmpty {
        toastMessage = message
        toastManager.showToast()
      }
    }
    .onReceive(vm.$errorMessage) { error in
      if !error.isEmpty {
        alertBoxMessage = error
        alertManager.showAlert()
      }
    }
    .environmentObject(vm)
  }
}

//
//#Preview {
//  EditProfile()
//}
