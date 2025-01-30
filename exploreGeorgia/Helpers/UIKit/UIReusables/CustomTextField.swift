//
//  CustomTextField.swift
//  exploreGeorgia
//
//  Created by Despo on 31.12.24.
//

import UIKit

final class CustomTextField: UIView, UITextFieldDelegate {
  var placeholderName: String
  private let isPassword: Bool
  private let keyboardType: UIKeyboardType?
  private weak var parentView: UIView?
  weak var delegate: UITextFieldDelegate?
  private let inputHeight: CGFloat?

  private lazy var inputField: UITextField = {
    let field = UITextField()
    field.translatesAutoresizingMaskIntoConstraints = false
    field.placeholder = placeholderName
    field.isSecureTextEntry = isPassword
    field.autocapitalizationType = .none
    field.autocorrectionType = .no
    field.clipsToBounds = true
    field.layer.cornerRadius = 12
    field.layer.borderWidth = 1
    field.layer.borderColor = UIColor.customGreen.cgColor
    field.backgroundColor = .customWhite
    field.delegate = delegate
    field.keyboardType = keyboardType ?? .default
    
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
  
  init(
    placeholderName: String,
    isPassword: Bool,
    parentView: UIView? = nil,
    keyboardType: UIKeyboardType = .default,
    delegate: UITextFieldDelegate? = nil,
    inputHeight: CGFloat = 50
  ) {
    self.placeholderName = placeholderName
    self.isPassword = isPassword
    self.parentView = parentView
    self.keyboardType = keyboardType
    self.delegate = delegate
    self.inputHeight = inputHeight
    super.init(frame: .zero)
    
    self.translatesAutoresizingMaskIntoConstraints = false
    addSubview(inputField)
    setupUI()
    setupKeyboardNotifications()
    inputField.delegate = delegate ?? self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupUI() {
    NSLayoutConstraint.activate([
      inputField.topAnchor.constraint(equalTo: topAnchor),
      inputField.leadingAnchor.constraint(equalTo: leadingAnchor),
      inputField.trailingAnchor.constraint(equalTo: trailingAnchor),
      inputField.bottomAnchor.constraint(equalTo: bottomAnchor),
      inputField.heightAnchor.constraint(equalToConstant: inputHeight ?? 50)
    ])
  }
  
  private func setupKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc private func keyboardWillShow(_ notification: Notification) {
    guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
    guard let parentView = parentView else { return }
    guard let window = findKeyWindow() else { return }
    
    if inputField.isFirstResponder {
      let keyboardHeight = keyboardFrame.height
      let textFieldFrame = self.convert(self.bounds, to: window)
      let bottomSpace = window.frame.height - textFieldFrame.maxY
      
      if bottomSpace < keyboardHeight {
        let offset = keyboardHeight - bottomSpace + 10
        UIView.animate(withDuration: 0.3) {
          parentView.transform = CGAffineTransform(translationX: 0, y: -offset)
        }
      }
    }
  }
  
  @objc private func keyboardWillHide(_ notification: Notification) {
    UIView.animate(withDuration: 0.3) {
      self.parentView?.transform = .identity
    }
  }
  
  private func findKeyWindow() -> UIWindow? {
    return UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
  }
  
  private func toggleVisibility(_ sender: UIButton) {
    inputField.isSecureTextEntry.toggle()
    let eyeIcon = inputField.isSecureTextEntry ? "eye.slash" : "eye"
    sender.setImage(UIImage(systemName: eyeIcon), for: .normal)
  }
  
  func value() -> String {
    return inputField.text ?? ""
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

