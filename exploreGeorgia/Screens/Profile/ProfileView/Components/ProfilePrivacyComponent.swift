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
      
      
      if !editViewModel.isUserFromGoogle {Text("Change password")
          .styledText(.customBlack, 18, .bold)
        
        VStack(spacing: 20) {
          ZStack {
            TextField("Enter your password", text: $editViewModel.password)
              .styledTextField()
              .opacity(isPasswordVisible ? 1 : 0)
            SecureField("Enter your password", text: $editViewModel.password)
              .styledSecureFIeld()
              .opacity(isPasswordVisible ? 0 : 1)
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
            TextField("Enter your password", text: $editViewModel.rePassword)
              .styledTextField()
              .opacity(isRePasswordVisible ? 1 : 0)
            SecureField("Repeat password", text: $editViewModel.rePassword)
              .styledSecureFIeld()
              .opacity(isRePasswordVisible ? 0 : 1)
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
      } else {
        Text("Google users can't change passwords")
          .styledText(.customBlack, 16)
      }
    }
    .ignoresSafeArea(.keyboard, edges: .bottom)
    .padding(.horizontal, 20)
    .padding(.bottom, 10)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.primaryWhite)
  }
}

