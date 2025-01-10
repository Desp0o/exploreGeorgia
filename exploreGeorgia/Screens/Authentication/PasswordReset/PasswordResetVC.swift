//
//  PasswordResetVC.swift
//  exploreGeorgia
//
//  Created by Despo on 31.12.24.
//

import UIKit

final class PasswordResetVC: UIViewController {
  private let vm: PasswordResetViewModel?
  
  init(vm: PasswordResetViewModel = PasswordResetViewModel()) {
    self.vm = vm
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var backButton: UIButton = {
    let button = UIButton()
    button.createCustomButton(
      image: UIImage(systemName: "arrow.left.circle.fill"),
      imageSize: 40,
      renderingMode: .alwaysTemplate,
      tintColor: .customBlue
    )
    
    button.addAction(UIAction(handler: { [weak self] _ in
      self?.navigationController?.popViewController(animated: true)
    }), for: .touchUpInside)
    
    return button
  }()
  
  private lazy var screenTitle: UILabel = {
    let label = UILabel()
    label.createLabel(
      text: "Forgot password",
      fontSize: 26,
      fontWeight: .bold,
      textColor: .customBlue
    )
    return label
  }()
  
  private lazy var screenSubTitle: UILabel = {
    let label = UILabel()
    label.createLabel(
      text: "Enter your email account to reset  your password",
      textColor: .customGray,
      textAlignment: .center
    )
    return label
  }()
  
  private lazy var resetStack: UIStackView = {
    let stack = UIStackView()
    stack.createCustomStack(
      axis: .vertical,
      spacing: 20
    )
    return stack
  }()
  
  private lazy var emailInput = CustomTextField(
    placeholderName: "Enter Valid Email",
    isPassword: false
  )
  
  private lazy var resetButton: UIButton = {
    let button = UIButton()
    button.createCustomButton(
      title: "Reset Password",
      backgroundColor: .customBlue
    )
    button.addTapAnimation()
    button.addAction(UIAction(handler: { [weak self] _ in
      self?.reqPassReset()
    }), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    vm?.passErrorDelegate = self
    vm?.passResetLoadingDelegate = self
    vm?.successedMessageDelegate = self
    
    setupUI()
  }
  
  private func setupUI() {
    view.backgroundColor = .primaryWhite
    
    view.addSubview(backButton)
    view.addSubview(screenTitle)
    view.addSubview(screenSubTitle)
    view.addSubview(resetStack)
    resetStack.addArrangedSubview(emailInput)
    resetStack.addArrangedSubview(resetButton)
    
    setupContstraints()
  }
  
  private func setupContstraints() {
    NSLayoutConstraint.activate([
      backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      
      screenTitle.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 70),
      screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      screenSubTitle.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 12),
      screenSubTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      screenSubTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      resetStack.topAnchor.constraint(equalTo: screenSubTitle.bottomAnchor, constant: 40),
      resetStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      resetStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      resetButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  
  private func reqPassReset() {
    let emailValue = emailInput.value()
    
    vm?.requestPssReset(email: emailValue)
  }
}

extension PasswordResetVC: ResetPasswordLoadingDelegate {
  func didLoadingStarted() {
    if vm?.isloading ?? false {
      showLoading()
    } else {
      hideLoading()
    }
  }
}

extension PasswordResetVC: ResetPassErrorDelegate {
  func didErrorDuringReseting() {
    let overLayerView = UIKitCustomAlert()
    overLayerView.appear(sender: self, message: vm?.passResetErrMessage ?? "Error", messageType: .error)
  }
}

extension PasswordResetVC: ResetPassowrdSuccessMessageDelegate {
  func didRequestSuccessed() {
    showToast(message: vm?.passSuccessMessage ?? "", toastType: .successfully)
  }
}

#Preview {
  PasswordResetVC()
}
