//
//  LanguageSelectorComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

import SwiftUI

struct LanguageSelectorComponent: View {
  @EnvironmentObject var vm: EditProfileViewModel
  
  var body: some View {
    HStack {
      Text("Language")
        .styledText(.customBlack, 16, .semibold)
      
      Spacer()
      
      Picker("Language", selection: $vm.selectedLanguage) {
        ForEach(vm.languageArr, id: \.self) { gender in
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
      .frame(width: 150)
    }
  }
}
