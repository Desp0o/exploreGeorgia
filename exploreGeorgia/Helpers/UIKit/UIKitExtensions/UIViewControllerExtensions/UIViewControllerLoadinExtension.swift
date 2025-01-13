//
//  UIViewControllerLoadinExtension.swift
//  exploreGeorgia
//
//  Created by Despo on 05.01.25.
//

import UIKit

extension UIViewController {
    private var loadingView: UIView? {
        view.subviews.first { $0.tag == 999 }
    }
    
    func showLoading() {
        guard loadingView == nil else { return }
        
        let loadingView = UIView()
        loadingView.frame = view.bounds
        loadingView.tag = 999
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .customBlue
        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()

        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
      
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
        
        loadingView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            loadingView.alpha = 1
        }
    }
    
    func hideLoading() {
        guard let loadingView = loadingView else { return }
        
        UIView.animate(withDuration: 0.2) {
            loadingView.alpha = 0
        } completion: { _ in
            loadingView.removeFromSuperview()
        }
    }
}
