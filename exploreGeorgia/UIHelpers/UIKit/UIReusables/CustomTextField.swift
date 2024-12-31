//
//  CustomTextField.swift
//  exploreGeorgia
//
//  Created by Despo on 31.12.24.
//

import UIKit

final class CustomTextField: UIView {
  private let placeholderName: String
  private let isPassword: Bool
  
  private lazy var inputField: UITextField = {
    let field = UITextField()
    field.translatesAutoresizingMaskIntoConstraints = false
    field.placeholder = placeholderName
    field.isSecureTextEntry = isPassword
    field.clipsToBounds = true
    field.layer.cornerRadius = 12
    field.layer.borderWidth = 1
    field.layer.borderColor = UIColor.customVine.cgColor
    
    let leftContainer = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
    field.leftView = leftContainer
    field.leftViewMode = .always
    
    if isPassword {
      let rightContainer = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 50))
      let eyeIcon = UIButton()
      eyeIcon.setImage(UIImage(systemName: "eye.slash"), for: .normal)
      eyeIcon.tintColor = .customGray
      eyeIcon.frame = CGRect(x: 0, y: rightContainer.frame.height / 2 - 8, width: 24, height: 16)
      
      eyeIcon.addAction(UIAction(handler: { [weak self] action in
        guard let button = action.sender as? UIButton else { return }
        
        self?.toggleVisibility(button)
      }), for: .touchUpInside)
      
      rightContainer.addSubview(eyeIcon)
      
      field.rightView = rightContainer
      field.rightViewMode = .always
    }
    
    return field
  }()
  
  init(placeholderName: String, isPassword: Bool) {
    self.placeholderName = placeholderName
    self.isPassword = isPassword
    super.init(frame: .zero)
    
    self.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(inputField)
    
    setupUI()
  }
  
  func setupUI() {
    NSLayoutConstraint.activate([
      inputField.topAnchor.constraint(equalTo: topAnchor),
      inputField.leadingAnchor.constraint(equalTo: leadingAnchor),
      inputField.trailingAnchor.constraint(equalTo: trailingAnchor),
      inputField.bottomAnchor.constraint(equalTo: bottomAnchor),
      inputField.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func toggleVisibility(_ sender: UIButton) {
    inputField.isSecureTextEntry.toggle()
    
    let eyeIcon = inputField.isSecureTextEntry ? "eye.slash" : "eye"
    
    sender.setImage(UIImage(systemName: eyeIcon), for: .normal)
  }
  
  func value() -> String {
    guard let valueString = inputField.text else { return "" }
    return valueString
  }
}
