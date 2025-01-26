//
//  OverlayActionButtonIcon.swift
//  exploreGeorgia
//
//  Created by Despo on 21.01.25.
//

import SwiftUI

struct OverlayActionButtonIcon: View {
  let iconName: IconsEnum
  let tint: Color
  let scale: CGFloat
  let bgColor: Color
  let opacity: CGFloat
  
  init(
    iconName: IconsEnum,
    tint: Color,
    scale: CGFloat = 1,
    bgColor: Color = .black,
    opacity: CGFloat = 0.6
  ) {
    self.iconName = iconName
    self.tint = tint
    self.scale = scale
    self.bgColor = bgColor
    self.opacity = opacity
  }
  
  var body: some View {
    Image(systemName: iconName.rawValue)
      .tint(tint)
      .scaleEffect(scale)
      .frame(width: 36, height: 36)
      .background(bgColor.opacity(opacity))
      .clipShape(Circle())
  }
}
