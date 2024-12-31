//
//  LoginVC.swift
//  exploreGeorgia
//
//  Created by Despo on 31.12.24.
//

import UIKit

final class LoginVC: UIViewController {
  private lazy var screenTitle: UILabel = {
    let label = UILabel()
    label.createLabel(
      text: "Sign In",
      fontSize: 26,
      fontWeight: .bold
    )
    return label
  }()
  
  private lazy var screenSubTitle: UILabel = {
    let label = UILabel()
    label.createLabel(
      text: "Please sign in to continue our app",
      textColor: .customGray
    )
    return label
  }()
  
  private lazy var inputsStack: UIStackView = {
    let stack = UIStackView()
    stack.createCustomStack(spacing: 20)
    return stack
  }()
  
  private lazy var emailInput = CustomTextField(
    placeholderName: "Enter Email",
    isPassword: false
  )
  
  private lazy var passwordInput = CustomTextField(
    placeholderName: "Enter Password",
    isPassword: true
  )
  
  private lazy var loginButton: UIButton = {
    let button = UIButton()
    button.createCustomButton(
      title: "Log In",
      backgroundColor: .customVine
    )
    return button
  }()
  
  private lazy var forgetPwdButton: UIButton = {
    let button = UIButton()
    button.createCustomButton(
      title: "Forget Password?",
      fontSize: 14,
      fontWeight: .medium,
      titleColor: .customVine
    )
    
    button.addAction(UIAction(handler: { [weak self] _ in
      self?.navigateToPasswordReset()
    }), for: .touchUpInside)
    
    return button
  }()
  
  private lazy var signupStack: UIStackView = {
    let stack  = UIStackView()
    stack.createCustomStack(
        axis: .horizontal,
        distribution: .equalSpacing,
        spacing: 10
      )
    return stack
  }()
  
  private lazy var noAccLabel: UILabel = {
    let label = UILabel()
    label.createLabel(
        text: "Don’t have an account?",
        fontSize: 14,
        textColor: .customGray
      )
    return label
  }()
  
  private lazy var signupButton: UIButton = {
    let button = UIButton()
    button.createCustomButton(
        title: "Sign Up",
        fontSize: 14,
        fontWeight: .medium,
        titleColor: .customVine
      )
    button.addAction(UIAction(handler: {[weak self] _ in
      self?.navigateToSignupVC()
    }), for: .touchUpInside)
    return button
  }()
  
  private lazy var connectLabel: UILabel = {
    let label = UILabel()
    label.createLabel(
        text: "Or connect",
        fontSize: 14,
        textColor: .customGray
      )
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  private func setupUI() {
    view.backgroundColor = .customWhite
    
    view.addSubview(screenTitle)
    view.addSubview(screenSubTitle)
    view.addSubview(inputsStack)
    inputsStack.addArrangedSubview(emailInput)
    inputsStack.addArrangedSubview(passwordInput)
    view.addSubview(forgetPwdButton)
    view.addSubview(loginButton)
    view.addSubview(signupStack)
    signupStack.addArrangedSubview(noAccLabel)
    signupStack.addArrangedSubview(signupButton)
    view.addSubview(connectLabel)
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
      screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      screenSubTitle.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 12),
      screenSubTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      inputsStack.topAnchor.constraint(equalTo: screenSubTitle.bottomAnchor, constant: 40),
      inputsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      inputsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      forgetPwdButton.topAnchor.constraint(equalTo: inputsStack.bottomAnchor, constant: 16),
      forgetPwdButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      loginButton.topAnchor.constraint(equalTo: forgetPwdButton.bottomAnchor, constant: 40),
      loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      loginButton.heightAnchor.constraint(equalToConstant: 50),
      
      signupStack.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40),
      signupStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      connectLabel.topAnchor.constraint(equalTo: signupStack.bottomAnchor, constant: 20),
      connectLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])
  }
  
  private func navigateToSignupVC() {
    navigationController?.pushViewController(SignupVC(), animated: true)
  }
  
  private func navigateToPasswordReset() {
    navigationController?.pushViewController(PasswordResetVC(), animated: true)
  }
}
