//
//  ButtonModifyer.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUI

extension Button {
  func customStyledButton(
    height: CGFloat = 50,
    bg: Color = .customBlue
  ) -> some View {
    self.frame(height: height)
      .frame(maxWidth: .infinity)
      .background(bg)
      .clipShape(RoundedRectangle(cornerRadius: 12))
  }
}



extension Button {
  func customBorderedButton(
    height: CGFloat = 50,
    corners: CGFloat = 12,
    borderColor: Color = .customBlack,
    borderWidth: CGFloat = 1
  ) -> some View {
    self.frame(maxWidth: .infinity)
      .frame(minHeight: height)
      .background(.clear)
      .overlay(
        RoundedRectangle(cornerRadius: corners)
          .stroke(borderColor, lineWidth: borderWidth)
      )
  }
}
