//
//  ScreenMainTitle.swift
//  exploreGeorgia
//
//  Created by Despo on 17.01.25.
//

import SwiftUI

struct ScreenMainTitle: View {
  let mainTitle: String
  let subTitle: String
  
  var body: some View {
    VStack {
      Text(mainTitle)
        .styledText(.customBlue, 24, .semibold)
      
      Text(subTitle)
        .styledText(.customBlue, 16)
    }
  }
}
