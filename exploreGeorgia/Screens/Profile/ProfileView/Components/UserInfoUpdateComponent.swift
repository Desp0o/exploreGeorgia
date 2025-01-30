//
//  UserInfoUpdateComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

import SwiftUI

struct UserInfoUpdateComponent: View {
  @ObservedObject var editViewModel: EditProfileViewModel
  
  var body: some View {
    VStack(spacing: 20) {
      Text("Profile info")
        .styledText(.customBlack, 18, .bold)
      
      TextField("First name", text: $editViewModel.firstName)
        .styledTextField()
      
      TextField("Last name", text: $editViewModel.lastName)
        .styledTextField()
      
      Picker("Gender", selection: $editViewModel.gender) {
        ForEach(editViewModel.genderOptions, id: \.self) { gender in
          Text(gender)
        }
      }
      .pickerStyle(.segmented)
      .onAppear {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.customGreen)
        let attributes: [NSAttributedString.Key: Any] = [
          .foregroundColor: UIColor.white
        ]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
        UISegmentedControl.appearance().isSpringLoaded = true
        UISegmentedControl.appearance().backgroundColor = UIColor.customWhite
      }
      
      Button {
        editViewModel.updateUser()
      } label: {
        Text("Update personal info")
          .styledText(.buttonPrimary, 16, .bold)
          .frame(maxWidth: .infinity)
      }
      .customStyledButton()
    }
    .ignoresSafeArea(.keyboard, edges: .bottom)
    .padding(.horizontal, 20)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.primaryWhite)
  }
}
