//
//  UISstackViewExtensions.swift
//  exploreGeorgia
//
//  Created by Despo on 31.12.24.
//

import UIKit

extension UIStackView {
  func createCustomStack(
    axis: NSLayoutConstraint.Axis = .vertical,
    alignment: UIStackView.Alignment = .fill,
    distribution: UIStackView.Distribution = .fill,
    spacing: CGFloat = 0,
    isLayoutMarginsRelativeArrangement: Bool = false,
    layoutMargins: UIEdgeInsets = .zero
  ) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.axis = axis
    self.alignment = alignment
    self.distribution = distribution
    self.spacing = spacing
    self.isLayoutMarginsRelativeArrangement = isLayoutMarginsRelativeArrangement
    
    if isLayoutMarginsRelativeArrangement {
      self.layoutMargins = layoutMargins
    }
  }
}
