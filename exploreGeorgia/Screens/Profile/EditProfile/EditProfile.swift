//
//  EditProfile.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUI

struct EditProfile: View {
  @StateObject private var vm = EditProfileViewModel()
  
  var body: some View {
    if vm.isLoading {
      VStack {
        ProgressView()
          .scaleEffect(2.0)
          .tint(.customBlue)
      }
    } else {
      VStack(spacing: 50) {
        
        VStack(spacing: 20) {
          TextField("First name", text: $vm.firstName)
            .styledTextField()
          
          TextField("Last name", text: $vm.lastName)
            .styledTextField()
          
          Picker("Gender", selection: $vm.gender) {
            ForEach(vm.genderOptions, id: \.self) { gender in
              Text(gender)
            }
          }
          .pickerStyle(.segmented)
          .onAppear {
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.customBlue)
            let attributes: [NSAttributedString.Key: Any] = [
              .foregroundColor: UIColor.white
            ]
            UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
            UISegmentedControl.appearance().isSpringLoaded = true
          }
          
          Button {
            vm.updateUser()
          } label: {
            Text("Update profile")
              .styledText(.customWhite, 16, .bold)
          }
          .customStyledButton()
        }
        
        VStack(spacing: 20) {
          SecureField("Enter your password", text: $vm.password)
            .styledSecureFIeld()
          
          SecureField("Repeat password", text: $vm.rePassword)
            .styledSecureFIeld()
          
          Button {
            vm.updatePassword()
          } label: {
            Text("Update password")
              .styledText(.customWhite, 16, .bold)
          }
          .customStyledButton()
        }
        
        Button {
          vm.userAccountDelete()
        } label: {
          Text("Delete Accaunt")
        }
        .customStyledButton(bg: .red)
      }
      .padding(.horizontal, 20)
    }
  }
}

#Preview {
  EditProfile()
}
