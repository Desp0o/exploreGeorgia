//
//  UserDeleteComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

import SwiftUI

struct UserDeleteComponent: View {
  @ObservedObject var vm = EditProfileViewModel()
  
  var body: some View {
    VStack(spacing: 20) {
      if !vm.isUserFromGoogle {
        SecureField("Enter password for delete account", text: $vm.passwordForDelete)
          .styledSecureFIeld()
          .opacity(vm.showInput ? 1 : 0)
          .animation(.easeIn(duration: 0.2), value: vm.showInput)
      }
      
      HStack(spacing: 20) {
        Button {
          withAnimation(.easeIn(duration: 0.2)) {
            if !vm.showInput {
              vm.showInput = true
            } else {
              vm.userAccountDelete()
            }
          }
        } label: {
          Text("Delete account")
            .styledText(.buttonPrimary)
            .frame(maxWidth: .infinity)
        }
        .customStyledButton(bg: .red)
        
        if vm.showInput {
          Button {
            withAnimation(.easeIn(duration: 0.2)) {
              vm.showInput.toggle()
            }
          } label: {
            Text("Cancel")
              .styledText(.buttonPrimary, 18, .bold)
              .frame(maxWidth: .infinity)
          }
          .customStyledButton()
        }
      }
    }
    .ignoresSafeArea(.keyboard, edges: .bottom)
    .padding(.horizontal, 20)
  }
}
