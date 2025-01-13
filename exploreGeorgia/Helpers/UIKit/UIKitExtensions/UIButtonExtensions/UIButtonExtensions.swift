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
    renderingMode: UIImage.RenderingMode = .automatic,
    tintColor: UIColor? = .white,
    backgroundColor: UIColor? = nil,
    cornerRadius: CGFloat = 12,
    borderColor: UIColor = .clear,
    borderWidth: CGFloat = 0
  ) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
    self.setTitle(title, for: .normal)
    self.setTitleColor(titleColor, for: .normal)
    self.tintColor = tintColor
    self.titleLabel?.textAlignment = .center
    self.backgroundColor = backgroundColor
    self.layer.cornerRadius = cornerRadius
    self.layer.borderColor = borderColor.cgColor
    self.layer.borderWidth = borderWidth
    
    if let image = image {
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: imageSize, height: imageSize))
        self.setImage(resizedImage.withRenderingMode(renderingMode), for: .normal)
    }
  }
  
  private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
      let renderer = UIGraphicsImageRenderer(size: targetSize)
      return renderer.image { _ in
          image.draw(in: CGRect(origin: .zero, size: targetSize))
      }
  }
}

