//
//  ImageModifier.swift
//  exploreGeorgia
//
//  Created by Despo on 26.12.24.
//

import SwiftUI

extension Image {
  func defaultOptions() -> some View {
    self
      .resizable()
      .scaledToFill()
  }
}
