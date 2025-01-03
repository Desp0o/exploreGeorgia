//
//  SignupVC.swift
//  exploreGeorgia
//
//  Created by Despo on 26.12.24.
//

import UIKit

final class SignupVC: UIViewController {
  private let vm: SignupViewModel
  
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
  
  private lazy var backButton: UIButton = {
    let button = UIButton()
    button.createCustomButton(
      image: UIImage(systemName: "arrow.left.circle.fill"),
      imageSize: 40,
      tintColor: .customVine
    )
    
    button.addAction(UIAction(handler: { [weak self] _ in
      self?.navigationController?.popViewController(animated: true)
    }), for: .touchUpInside)
    return button
  }()
  
  private lazy var screenTitle: UILabel = {
    let label = UILabel()
    label.createLabel(
      text: "Sign Up",
      fontSize: 26,
      fontWeight: .bold
    )
    return label
  }()
  
  private lazy var screenSubTitle: UILabel = {
    let label = UILabel()
    label.createLabel(
      text: "Please fill the details and create account",
      textColor: .customGray
    )
    return label
  }()
  
  private lazy var inputsStack: UIStackView = {
    let stack = UIStackView()
    stack.createCustomStack(
      axis: .vertical,
      spacing: 20
    )
    return stack
  }()
  
  private lazy var firstNameInput = CustomTextField(
    placeholderName: "First Name",
    isPassword: false
  )
  
  private lazy var lastNameInput = CustomTextField(
    placeholderName: "Last Name",
    isPassword: false
  )
  
  private lazy var emailInput = CustomTextField(
    placeholderName: "Enter Email",
    isPassword: false
  )
  
  private lazy var passwordInput = CustomTextField(
    placeholderName: "Enter Password",
    isPassword: true
  )
  
  private lazy var confirmPasswordInput = CustomTextField(
    placeholderName: "Confirm Password",
    isPassword: true
  )
  
  private lazy var signupButton: UIButton = {
    let button = UIButton()
    button.createCustomButton(
      title: "Sign up",
      backgroundColor: .customVine
    )
    
    button.addAction(UIAction(handler: { [weak self] _ in
      self?.registerUser()
    }), for: .touchUpInside)
    
    return button
  }()
  
  private lazy var signinStack: UIStackView = {
    let stack  = UIStackView()
    stack.createCustomStack(
      axis: .horizontal,
      distribution: .equalSpacing,
      spacing: 10
    )
    return stack
  }()
  
  private lazy var existingAcc: UILabel = {
    let label = UILabel()
    label.createLabel(
      text: "Don’t have an account?",
      fontSize: 14,
      textColor: .customGray
    )
    return label
  }()
  
  private lazy var signinButton: UIButton = {
    let button = UIButton()
    button.createCustomButton(
      title: "Sign in",
      fontSize: 14,
      fontWeight: .medium,
      titleColor: .customVine
    )
    button.addAction(UIAction(handler: {[weak self] _ in
      self?.navigationController?.popViewController(animated: true)
    }), for: .touchUpInside)
    return button
  }()
  
  init(vm: SignupViewModel = SignupViewModel()) {
    self.vm = vm
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    vm.errorDelegate = self
    
    setupUI()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    makeViewScrollable()
  }
  
  private func setupUI() {
    view.backgroundColor = .customWhite
    
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(backButton)
    contentView.addSubview(screenTitle)
    contentView.addSubview(screenSubTitle)
    contentView.addSubview(inputsStack)
    inputsStack.addArrangedSubview(firstNameInput)
    inputsStack.addArrangedSubview(lastNameInput)
    inputsStack.addArrangedSubview(emailInput)
    inputsStack.addArrangedSubview(passwordInput)
    inputsStack.addArrangedSubview(confirmPasswordInput)
    inputsStack.addArrangedSubview(signupButton)
    contentView.addSubview(signinStack)
    signinStack.addArrangedSubview(existingAcc)
    signinStack.addArrangedSubview(signinButton)
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
      
      backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      backButton.widthAnchor.constraint(equalToConstant: 40),
      backButton.heightAnchor.constraint(equalToConstant: 40),
      
      screenTitle.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
      screenTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      
      screenSubTitle.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 12),
      screenSubTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      
      inputsStack.topAnchor.constraint(equalTo: screenSubTitle.bottomAnchor, constant: 40),
      inputsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      inputsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      
      signupButton.heightAnchor.constraint(equalToConstant: 50),
      
      signinStack.topAnchor.constraint(equalTo: inputsStack.bottomAnchor, constant: 40),
      signinStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      signinStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
    ])
  }
  
  private func makeViewScrollable() {
    let isScrollEnabled = contentView.frame.height > scrollView.frame.height
    scrollView.isScrollEnabled = isScrollEnabled
  }
  
  private func registerUser() {
    vm.checkUser(
        firstName: firstNameInput.value(),
        lastName: lastNameInput.value(),
        email: emailInput.value(),
        password: passwordInput.value(),
        rePassword: confirmPasswordInput.value()
      )
  }
}

extension SignupVC: RegisterErrorMessageDelegate {
  func didErrorDuringSignup() {
  }
}

#Preview {
  SignupVC()
}
