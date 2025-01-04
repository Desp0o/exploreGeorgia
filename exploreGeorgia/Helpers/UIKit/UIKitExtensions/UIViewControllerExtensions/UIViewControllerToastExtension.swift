//
//  UIViewControllerToastExtension.swift
//  exploreGeorgia
//
//  Created by Despo on 05.01.25.
//

enum ToastTypes {
  case successfully
  case warning
  case error
}

import UIKit

extension UIViewController {
  func showToast(message: String, toastType: ToastTypes) {
    let toast = UILabel()
    toast.createLabel(
      text: message,
      fontWeight: .bold,
      textColor: .customWhite,
      textAlignment: .center,
      autoTranslate: true
    )
    
    switch toastType {
    case .successfully:
      toast.backgroundColor = .systemGreen
    case .warning:
      toast.backgroundColor = .systemYellow
    case .error:
      toast.backgroundColor = .systemRed
    }
    
    toast.layer.cornerRadius = 12
    toast.clipsToBounds = true
    toast.alpha = 0.0
    
    let textSize = toast.intrinsicContentSize
    let verticalPadding: CGFloat = 25
    let toastWidth = view.frame.width - 40
    let toastHeight = textSize.height + verticalPadding
    
    toast.frame = CGRect(
      x: 20,
      y: 0,
      width: toastWidth,
      height: toastHeight
    )
    
    view.addSubview(toast)
    
    UIView.animate(withDuration: 0.2, animations: {
      toast.alpha = 1.0
      toast.frame.origin.y = toastHeight + 20
    }) { _ in
      UIView.animate(withDuration: 0.2, delay: 2, options: .curveLinear, animations: {
        toast.alpha = 0.0
        toast.frame.origin.y = 0
      }) { _ in
        toast.removeFromSuperview()
      }
    }
  }
}
