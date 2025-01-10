//
//  UserPasswordChangeComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

import SwiftUI

struct UserPasswordChangeComponent: View {
  @ObservedObject var vm: EditProfileViewModel
  
  var body: some View {
    VStack(spacing: 20) {
      SecureField("Enter your password", text: $vm.password)
        .styledSecureFIeld()
      
      SecureField("Repeat password", text: $vm.rePassword)
        .styledSecureFIeld()
      
      Button {
        vm.updatePassword()
      } label: {
        Text("Update password")
          .styledText(.customBlack, 16, .bold)
      }
      .customStyledButton()
    }
  }
}

#Preview {
  @ObservedObject var vm = EditProfileViewModel()
  UserPasswordChangeComponent(vm: vm)
}
