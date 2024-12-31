//
//  UIButtonExtensions.swift
//  exploreGeorgia
//
//  Created by Despo on 31.12.24.
//

import UIKit

extension UIButton {
  func createCustomButton(
    title: String? = nil,
    fontSize: CGFloat = 16,
    fontWeight: UIFont.Weight = .bold,
    titleColor: UIColor? = nil,
    image: UIImage? = nil,
    imageSize: CGFloat = 0,
    tintColor: UIColor? = .white,
    backgroundColor: UIColor? = nil,
    cornerRadius: CGFloat = 12
  ) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
    self.setTitle(title, for: .normal)
    self.setTitleColor(titleColor, for: .normal)
    self.tintColor = tintColor
    self.titleLabel?.textAlignment = .center
    self.backgroundColor = backgroundColor
    self.layer.cornerRadius = cornerRadius
    
    if let image = image {
      let config = UIImage.SymbolConfiguration(pointSize: imageSize)
      self.setImage(image.withConfiguration(config)
                         .withRenderingMode(.alwaysTemplate),
                    for: .normal)
    }
  }
}

