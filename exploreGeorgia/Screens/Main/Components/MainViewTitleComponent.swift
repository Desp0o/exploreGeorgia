//
//  MainViewTitleComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import SwiftUI

struct MainViewTitleComponent: View {
  var body: some View {
    VStack(alignment: .leading){
      HStack {
        Text("Explore The")
          .styledText(
            .customBlack,
            24
          )
      }
      
      HStack {
        Text("Beautiful ")
          .styledText(
            .customBlack,
            24
          )
        
        Text("G e o r g i a")
          .styledText(
            .customBlue,
            24,
            .bold
          )
          .overlay {
            Image("arc")
              .renderingMode(.template)
              .offset(y: 20)
              .foregroundStyle(.customBlue)
          }
        
        Spacer()
      }
    }
  }
}

#Preview {
  MainViewTitleComponent()
}
