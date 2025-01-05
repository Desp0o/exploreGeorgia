//
//  UIButtonAnimateExtension.swift
//  exploreGeorgia
//
//  Created by Despo on 05.01.25.
//

import UIKit

extension UIButton {
  func addTapAnimation(scale: CGFloat = 0.95, duration: TimeInterval = 0.1) {
    self.addAction(UIAction(handler: { [weak self] _ in
      guard let self = self else { return }
      UIView.animate(
        withDuration: duration,
        animations: {
          self.transform = CGAffineTransform(scaleX: scale, y: scale)
        },
        completion: { _ in
          UIView.animate(
            withDuration: duration,
            animations: {
              self.transform = .identity
            }
          )
        }
      )
    }), for: .touchUpInside)
  }
}
