//
//  LoginVC.swift
//  exploreGeorgia
//
//  Created by Despo on 31.12.24.
//

import UIKit
import SwiftUI

final class LoginVC: UIViewController {
  private var vm: LoginViewModel?
  
  private lazy var scrollView: UIScrollView = {
    let view = UIScrollView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.showsVerticalScrollIndicator = false
    return view
  }()
  
  private lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var screenTitle: UILabel = {
    let label = UILabel()
    label.createLabel(
      text: "Sign In",
      fontSize: 26,
      fontWeight: .bold,
      textColor: .customBlue
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
      backgroundColor: .customBlue
    )
    
    button.addTapAnimation()
    button.addAction(UIAction(handler: {[weak self] _ in
      self?.loginUser()
    }), for: .touchUpInside)
    
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
  
  private lazy var googleButton: UIButton = {
    let button = UIButton()
    button.createCustomButton(
      title: "    Sign in with Google",
      titleColor: .customBlue,
      image: UIImage(named: "googleIcon"),
      imageSize: 24,
      cornerRadius: 12,
      borderColor: .customBlue,
      borderWidth: 1
    )
    button.addTapAnimation()
    button.addAction(UIAction(handler: { [weak self] _ in
      self?.vm?.googleSignIn()
    }), for: .touchUpInside)
    return button
  }()
  
  init(vm: LoginViewModel = LoginViewModel()) {
    self.vm = vm
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    makeViewScrollable()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    vm?.loginErrorDelegate = self
    vm?.loginLoadingDelegate = self
    
    setupUI()
  }
  
  private func setupUI() {
    view.backgroundColor = .primaryWhite
    
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(screenTitle)
    contentView.addSubview(screenSubTitle)
    contentView.addSubview(inputsStack)
    inputsStack.addArrangedSubview(emailInput)
    inputsStack.addArrangedSubview(passwordInput)
    contentView.addSubview(forgetPwdButton)
    contentView.addSubview(loginButton)
    contentView.addSubview(signupStack)
    signupStack.addArrangedSubview(noAccLabel)
    signupStack.addArrangedSubview(signupButton)
    contentView.addSubview(connectLabel)
    contentView.addSubview(googleButton)
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      
      contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
      
      screenTitle.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 70),
      screenTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      
      screenSubTitle.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 12),
      screenSubTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      
      inputsStack.topAnchor.constraint(equalTo: screenSubTitle.bottomAnchor, constant: 40),
      inputsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      inputsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      
      forgetPwdButton.topAnchor.constraint(equalTo: inputsStack.bottomAnchor, constant: 16),
      forgetPwdButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      
      loginButton.topAnchor.constraint(equalTo: forgetPwdButton.bottomAnchor, constant: 40),
      loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      loginButton.heightAnchor.constraint(equalToConstant: 50),
      
      signupStack.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40),
      signupStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      
      connectLabel.topAnchor.constraint(equalTo: signupStack.bottomAnchor, constant: 20),
      connectLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      
      googleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      googleButton.topAnchor.constraint(equalTo: connectLabel.bottomAnchor, constant: 30),
      googleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      googleButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
      googleButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  
  private func makeViewScrollable() {
    let isScrollEnabled = contentView.frame.height > scrollView.frame.height
    scrollView.isScrollEnabled = isScrollEnabled
  }
  
  private func navigateToSignupVC() {
    navigationController?.pushViewController(SignupVC(), animated: true)
  }
  
  private func navigateToPasswordReset() {
    navigationController?.pushViewController(PasswordResetVC(), animated: true)
  }
  
  private func loginUser() {
    vm?.checkUser(email: emailInput.value(), password: passwordInput.value())
  }
}

extension LoginVC: LoginErrorDelegate {
  func didErrorDuringLogin() {
    let overlay = UIKitCustomAlert()
    overlay.appear(sender: self, message: vm?.loginErrorMsg ?? "", messageType: .error)
  }
}

extension LoginVC: LoginLoadingDelegate {
  func didLoginLoaded() {
    if vm?.isLoading ?? false {
      showLoading()
    } else {
      hideLoading()
    }
  }
}
