//
//  UserInfoUpdateComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

import SwiftUI

struct UserInfoUpdateComponent: View {
  @ObservedObject var vm: EditProfileViewModel
  
  var body: some View {
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
        
        UISegmentedControl.appearance().backgroundColor = .customWhite
      }
      
      Button {
        vm.updateUser()
      } label: {
        Text("Update personal info")
          .styledText(.customBlack, 16, .bold)
      }
      .customStyledButton()
    }
  }
}

#Preview {
  @ObservedObject var vm = EditProfileViewModel()
  UserInfoUpdateComponent(vm: vm)
}
