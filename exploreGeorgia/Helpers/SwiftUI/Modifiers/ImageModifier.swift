//
//  ImageModifier.swift
//  exploreGeorgia
//
//  Created by Despo on 26.12.24.
//

import SwiftUI

extension Image {
  func defaultOptions(color: Color) -> some View {
    self
      .renderingMode(.template)
      .resizable()
      .scaledToFill()
      .foregroundStyle(color)
  }
}
