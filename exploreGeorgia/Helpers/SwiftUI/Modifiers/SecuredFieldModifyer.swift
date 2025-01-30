//
//  SecuredFieldModifyer.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUI

extension SecureField {
  func styledSecureFIeld(
    height: CGFloat = 50,
    bg: Color = .customWhite,
    corners: CGFloat = 12,
    borderColor: Color = .customGreen,
    borderWidth: CGFloat = 1
  ) -> some View {
    self.padding()
      .frame(maxWidth: .infinity)
      .frame(height: height)
      .background(bg)
      .roundedCorners(12)
      .overlay(
        RoundedRectangle(cornerRadius: corners)
          .stroke(borderColor, lineWidth: borderWidth)
      )
  }
}
