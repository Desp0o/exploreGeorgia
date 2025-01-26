//
//  ThemeTogglerComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

import SwiftUI

struct ThemeTogglerComponent: View {
  @EnvironmentObject var vm: EditProfileViewModel
  
  var body: some View {
    HStack {
      Text("Appereance")
        .styledText(.customBlack, 16, .semibold)
      
      Spacer()
      
      HStack {
        ZStack {
          HStack {
            if vm.isDarkTheme {
              Image(systemName: IconsEnum.sun.rawValue)
                .foregroundStyle(.yellow)
              Spacer()
            } else {
              Spacer()
              Image(systemName: IconsEnum.moon.rawValue)
                .foregroundStyle(.blue)
            }
          }
          .padding(.horizontal, 5)
          
          HStack {
            if vm.isDarkTheme {
              Spacer()
            }
            
            Circle()
              .fill(.customBlue)
              .frame(width: 30, height: 30)
            
            if !vm.isDarkTheme {
              Spacer()
            }
          }
          .zIndex(2)
        }
      }
      .background(.customWhite)
      .clipShape(Capsule())
      .frame(width: 70, height: 30)
      .animation(.easeIn(duration: 0.2), value: vm.isDarkTheme)
      .onTapGesture {
        vm.isDarkTheme.toggle()
      }
    }
  }
}
