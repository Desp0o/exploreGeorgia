//
//  ProfilePrivacyComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 27.01.25.
//

import SwiftUI

struct ProfilePrivacyComponent: View {
  @ObservedObject var editViewModel: EditProfileViewModel
  @State private var isPasswordVisible = false
  @State private var isRePasswordVisible = false
  
  var body: some View {
    VStack(spacing: 20) {
      Text(editViewModel.isUserFromGoogle ? "Delete account" : "Change password or delete account")
        .styledText(.customBlack, 18, .bold)
      
      if !editViewModel.isUserFromGoogle {
        VStack(spacing: 20) {
          ZStack {
            if isPasswordVisible {
              TextField("Enter your password", text: $editViewModel.password)
                .styledTextField()
            } else {
              SecureField("Enter your password", text: $editViewModel.password)
                .styledSecureFIeld()
            }
          }
          .overlay(alignment: .trailing) {
            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
              .foregroundColor(.gray)
              .padding(8)
              .contentShape(Rectangle())
              .onTapGesture {
                isPasswordVisible.toggle()
              }
          }
          
          ZStack {
            if isRePasswordVisible {
              TextField("Enter your password", text: $editViewModel.rePassword)
                .styledTextField()
            } else {
              SecureField("Repeat password", text: $editViewModel.rePassword)
                .styledSecureFIeld()
            }
          }
          .overlay(alignment: .trailing) {
            Image(systemName: isRePasswordVisible ? "eye" : "eye.slash")
              .foregroundColor(.gray)
              .padding(8)
              .contentShape(Rectangle())
              .onTapGesture {
                isRePasswordVisible.toggle()
              }
          }
          
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

