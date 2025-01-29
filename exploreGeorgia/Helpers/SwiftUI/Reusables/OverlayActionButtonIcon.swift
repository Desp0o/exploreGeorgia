//
//  OverlayActionButtonIcon.swift
//  exploreGeorgia
//
//  Created by Despo on 21.01.25.
//

import SwiftUI

struct OverlayActionButtonIcon: View {
  let iconName: IconsEnum
  let scale: CGFloat
  
  init(
    iconName: IconsEnum,
    scale: CGFloat = 1
  ) {
    self.iconName = iconName
    self.scale = scale
  }
  
  var body: some View {
    Image(systemName: iconName.rawValue)
      .tint(.white)
      .scaleEffect(scale)
      .frame(width: 36, height: 36)
      .background(.customGreen)
      .clipShape(Circle())
  }
}
