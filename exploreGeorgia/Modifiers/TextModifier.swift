//
//  TextModifier.swift
//  exploreGeorgia
//
//  Created by Despo on 26.12.24.
//

import SwiftUI

extension Text {
  func styledText(
    _ textColor: Color,
    _ fontSize: CGFloat = 16,
    _ fontWeight: Font.Weight = .regular,
    _ design: Font.Design = .rounded
  ) -> some View {
    self
      .foregroundStyle(textColor)
      .font(.system(size: fontSize))
      .fontWeight(fontWeight)
      .fontDesign(design)
  }
}
