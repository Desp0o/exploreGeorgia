//
//  UiLabelExtensions.swift
//  exploreGeorgia
//
//  Created by Despo on 31.12.24.
//

import UIKit

extension UILabel {
  func createLabel(
    text: String,
    fontSize: CGFloat = 16,
    fontWeight: UIFont.Weight = .regular,
    textColor: UIColor = .customBlack,
    textAlignment: NSTextAlignment = .natural,
    lines: Int = 0
  ) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.text = text
    self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
    self.textColor = textColor
    self.textAlignment = textAlignment
    self.numberOfLines = lines
  }
}
