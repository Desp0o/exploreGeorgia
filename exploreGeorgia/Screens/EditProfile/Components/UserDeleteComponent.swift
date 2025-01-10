//
//  UserDeleteComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

import SwiftUI

struct UserDeleteComponent: View {
  @ObservedObject var vm: EditProfileViewModel
  @Binding var showInput: Bool
  
  var body: some View {
    VStack(spacing: 20) {
      if showInput && !vm.isUserFromGoogle {
        SecureField("Enter password for delete account", text: $vm.passwordForDelete)
          .styledSecureFIeld()
      }
      
      HStack(spacing: 20) {
        Button {
          withAnimation(.linear(duration: 0.2)) {
            if !showInput {
              showInput = true
            } else {
              vm.userAccountDelete()
            }
          }
        } label: {
          Text("Delete account")
            .styledText(.customWhite)
        }
        .customStyledButton(bg: showInput ? .red : .customBlue)
        
        if showInput {
          Button {
            withAnimation(.linear(duration: 0.2)) {
              showInput.toggle()
            }
          } label: {
            Text("Cancel")
              .styledText(
                .customWhite,
                18,
                .bold
              )
          }
          .customStyledButton()
        }
      }
    }
  }
}

//#Preview {
//  @Previewable @State var isShow = true
//  UserDeleteComponent(vm: $EditProfileViewModel(), showInput: $isShow)
//}
