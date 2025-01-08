//
//  ProfileSettings.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUI

struct ProfileSettings: View {
  let settingsArray: [ProfileSettingsModel]
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.customWhite)
        .shadow(color: .customBlack.opacity(0.15), radius: 3, y: 2)
      
      VStack(spacing: 0) {
        ForEach(0..<settingsArray.count, id: \.self) { index in
          
          HStack(spacing: 14) {
            Image(settingsArray[index].icon)
              .defaultOptions()
              .frame(width: 24, height: 24)
            
            Text(settingsArray[index].title)
              .styledText(
                .customBlack,
                16,
                .semibold
              )
            
            Spacer()
            
            Image("arrowRight")
          }
          .frame(height: 56)
          .padding(.leading, 16)
          .padding(.trailing, 10)
          
          if index != settingsArray.count - 1 {
            Divider()
          }
        }
      }
    }
    .frame(height: (CGFloat(settingsArray.count) * 56))
  }
}

#Preview {
  ProfileSettings(settingsArray: [])
}
