//
//  UIViewControllerToastExtension.swift
//  exploreGeorgia
//
//  Created by Despo on 05.01.25.
//

import UIKit
import SwiftUI

extension UIViewController {
  func showToast(message: String, toastType: ToastTypes) {
    let toastView = ToastView(message: message, bgColor: toastType)
    
    let hostingController = UIHostingController(rootView: toastView)
    hostingController.view.backgroundColor = .clear
    hostingController.view.isUserInteractionEnabled = false
    
    let toastWidth = view.frame.width - 40
    let toastHeight: CGFloat = 50
    
    let topPadding = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.top ?? 0
    
    hostingController.view.frame = CGRect(
      x: 20,
      y: topPadding,
      width: toastWidth,
      height: toastHeight
    )
    
    view.addSubview(hostingController.view)
    
    hostingController.view.alpha = 0
    hostingController.view.transform = CGAffineTransform(translationX: 0, y: -toastHeight)
    
    UIView.animate(withDuration: 0.3, animations: {
      hostingController.view.alpha = 1.0
      hostingController.view.transform = .identity
    }) { _ in
      UIView.animate(withDuration: 0.3, delay: 2, options: .curveEaseIn, animations: {
        hostingController.view.alpha = 0.0
      }) { _ in
        hostingController.view.removeFromSuperview()
      }
    }
  }
}
