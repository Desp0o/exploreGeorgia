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
      .background(.customBlue)
      .clipShape(RoundedRectangle(cornerRadius: 12))
  }
}
