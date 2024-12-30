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
    tintColor: UIColor? = .white,
    backgroundColor: UIColor? = nil,
    cornerRadius: CGFloat = 12
  ) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
    self.setTitle(title, for: .normal)
    self.setTitleColor(titleColor, for: .normal)
    self.tintColor = .white
    self.setImage(image, for: .normal)
    self.titleLabel?.textAlignment = .center
    self.backgroundColor = backgroundColor
    self.layer.cornerRadius = cornerRadius
  }
}

