//
//  ViewModifier.swift
//  exploreGeorgia
//
//  Created by Despo on 26.12.24.
//

import SwiftUI

extension View {
  func roundedCorners(_ cornerSize: CGFloat) -> some View {
        self
        .clipShape(RoundedRectangle(cornerRadius: cornerSize))
    }
}
