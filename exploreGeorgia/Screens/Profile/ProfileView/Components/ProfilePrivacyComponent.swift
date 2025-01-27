//
//  ProfilePrivacyComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 27.01.25.
//

import SwiftUI

struct ProfilePrivacyComponent: View {
  @ObservedObject var editViewModel: EditProfileViewModel
  
  var body: some View {
    VStack(spacing: 20) {
      Text(editViewModel.isUserFromGoogle ? "Delete account" : "Change password or delete account")
        .styledText(.customBlack, 18, .bold)
      
      if !editViewModel.isUserFromGoogle {
        VStack(spacing: 20) {
          SecureField("Enter your password", text: $editViewModel.password)
            .styledSecureFIeld()
          
          SecureField("Repeat password", text: $editViewModel.rePassword)
            .styledSecureFIeld()
          
          Button {
            editViewModel.updatePassword()
          } label: {
            Text("Update password")
              .styledText(.buttonPrimary, 16, .bold)
              .frame(maxWidth: .infinity)
          }
          .customStyledButton()
        }
      }
      
      UserDeleteComponent()
    }
    .padding(.horizontal, 20)
    .padding(.bottom, 10)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.primaryWhite)
  }
}

