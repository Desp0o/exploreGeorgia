//
//  UIKitCustomAlert.swift
//  exploreGeorgia
//
//  Created by Despo on 04.01.25.
//

import UIKit

final class UIKitCustomAlert: UIViewController {
  private lazy var toast: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .black.withAlphaComponent(0.3)
    return view
  }()
  
  private lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .customWhite
    view.layer.cornerRadius = 12
    return view
  }()
  
  private lazy var messageIcon: UIImageView = {
    let image = UIImageView()
    let config = UIImage.SymbolConfiguration(pointSize: 40)
    image.translatesAutoresizingMaskIntoConstraints = false
    image.image = UIImage(systemName: "exclamationmark.triangle.fill")?
      .withRenderingMode(.alwaysTemplate)
      .withConfiguration(config)
    
    return image
  }()
  
  private lazy var label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  
  private lazy var okButton: UIButton = {
    let button = UIButton()
    button.createCustomButton(
      title: "OK",
      backgroundColor: .customBlue
    )
    
    button.addAction(UIAction(handler: { [weak self] _ in
      self?.hide()
    }), for: .touchUpInside)
    
    return button
  }()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    self.modalPresentationStyle = .overFullScreen
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    performBounceAnimation()
  }
  
  private func setupUI() {
    view.addSubview(toast)
    toast.addSubview(contentView)
    contentView.addSubview(messageIcon)
    contentView.addSubview(label)
    contentView.addSubview(okButton)
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      toast.topAnchor.constraint(equalTo: view.topAnchor),
      toast.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      toast.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      toast.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      contentView.leadingAnchor.constraint(equalTo: toast.leadingAnchor, constant: 50),
      contentView.trailingAnchor.constraint(equalTo: toast.trailingAnchor, constant: -50),
      contentView.centerYAnchor.constraint(equalTo: toast.centerYAnchor),
      
      messageIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      messageIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      
      label.topAnchor.constraint(equalTo: messageIcon.bottomAnchor, constant: 20),
      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      
      okButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
      okButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      okButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      okButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      okButton.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
  
  private func performBounceAnimation() {
    let view = contentView
    view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    
    UIView.animate(withDuration: 0.6,
                   delay: 0,
                   usingSpringWithDamping: 0.6,
                   initialSpringVelocity: 1,
                   options: .curveEaseInOut,
                   animations: {
      view.transform = .identity
    })
  }
  
  func appear(sender: UIViewController, message: String, messageType: MessageType) {
    sender.present(self, animated: false)
    
    setupUI()
    
    showToast(message: message, messageType: messageType)
  }
  
  func showToast(message: String, messageType: MessageType) {
    switch messageType {
    case .error:
      messageIcon.tintColor = .systemRed
    case .warning:
      messageIcon.tintColor = .systemYellow
    }
    
    label.createLabel(
      text: message,
      fontWeight: .bold,
      textColor: .customBlack,
      textAlignment: .center
    )
    
    toast.isHidden = false
  }
  
  func hide() {
    self.dismiss(animated: false) { [weak self] in
      self?.view.removeFromSuperview()
    }
  }
}

