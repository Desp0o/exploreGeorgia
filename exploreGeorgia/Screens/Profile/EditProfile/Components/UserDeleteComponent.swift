//
//  UserDeleteComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

import SwiftUI

struct UserDeleteComponent: View {
  @EnvironmentObject var vm: EditProfileViewModel
  
  var body: some View {
    VStack(spacing: 20) {
      if vm.showInput && !vm.isUserFromGoogle {
        SecureField("Enter password for delete account", text: $vm.passwordForDelete)
          .styledSecureFIeld()
      }
      
      HStack(spacing: 20) {
        Button {
          withAnimation(.linear(duration: 0.2)) {
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
        .customStyledButton(bg: vm.showInput ? .red : .customBlue)
        
        if vm.showInput {
          Button {
            withAnimation(.linear(duration: 0.2)) {
              vm.showInput.toggle()
            }
          } label: {
            Text("Cancel")
              .styledText(.customBlack, 18, .bold)
              .frame(maxWidth: .infinity)
          }
          .customStyledButton()
        }
      }
    }
  }
}
