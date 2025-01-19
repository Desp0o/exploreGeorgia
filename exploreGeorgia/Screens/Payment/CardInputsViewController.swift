//
//  CardInputsViewController.swift
//  exploreGeorgia
//
//  Created by Despo on 19.01.25.
//

import UIKit

final class CardInputsViewController: UIViewController {
  private let vm: PaymentViewModel
  
  private lazy var closeButton: UIButton = {
    let button = UIButton()
    button.createCustomButton(
      image: UIImage(systemName: "xmark.circle.fill"),
      imageSize: 30,
      renderingMode: .alwaysTemplate,
      tintColor: .customBlue
    )
    
    button.addAction(UIAction(handler: { [weak self] _ in
      self?.dismiss(animated: true, completion: nil)
    }), for: .touchUpInside)
    
    return button
  }()
  
  private lazy var screenSubTitle: UILabel = {
    let label = UILabel()
    label.createLabel(
      text: "Add card details",
      textColor: .customGray,
      textAlignment: .center
    )
    return label
  }()
  
  private lazy var cardPlaceholder = CustomTextField(
    placeholderName: "Full Name",
    isPassword: false,
    keyboardType: .numberPad,
    delegate: self,
    inputHeight: 40
  )
  
  private lazy var cardNumberTextField = CustomTextField(
    placeholderName: "xxxx xxxx xxxx xxxx",
    isPassword: false,
    keyboardType: .numberPad,
    delegate: self,
    inputHeight: 40
  )
  
  private lazy var expiryDateTextField = CustomTextField(
    placeholderName: "MM/YY",
    isPassword: false,
    keyboardType: .numberPad,
    delegate: self,
    inputHeight: 40
  )
  
  private lazy var ccvTextField = CustomTextField(
    placeholderName: "CCV",
    isPassword: false,
    keyboardType: .numberPad,
    delegate: self,
    inputHeight: 40
  )
  
  private lazy var addCardButton: UIButton = {
    let button = UIButton()
    button.createCustomButton(
      title: "Add card",
      backgroundColor: .customBlue
    )
    button.addTapAnimation()
    return button
  }()
  
  init(vm: PaymentViewModel = PaymentViewModel()) {
    self.vm = vm
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  private func setupUI() {
    view.backgroundColor = .primaryWhite
    view.addSubview(closeButton)
    view.addSubview(screenSubTitle)
    view.addSubview(cardPlaceholder)
    view.addSubview(cardNumberTextField)
    view.addSubview(expiryDateTextField)
    view.addSubview(ccvTextField)
    view.addSubview(addCardButton)
    setupConstraint()
  }
  
  private func setupConstraint() {
    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      
      screenSubTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
      screenSubTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      cardPlaceholder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      cardPlaceholder.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 50),
      cardPlaceholder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      
      cardNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      cardNumberTextField.topAnchor.constraint(equalTo: cardPlaceholder.bottomAnchor, constant: 20),
      cardNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      
      expiryDateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      expiryDateTextField.topAnchor.constraint(equalTo: cardNumberTextField.bottomAnchor, constant: 20),
      expiryDateTextField.trailingAnchor.constraint(equalTo: ccvTextField.leadingAnchor, constant: -10),
      
      ccvTextField.leadingAnchor.constraint(equalTo: expiryDateTextField.trailingAnchor, constant: 10),
      ccvTextField.topAnchor.constraint(equalTo: cardNumberTextField.bottomAnchor, constant: 20),
      ccvTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      ccvTextField.widthAnchor.constraint(equalToConstant: 100),
      
      addCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      addCardButton.topAnchor.constraint(equalTo: ccvTextField.bottomAnchor, constant: 20),
      addCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      addCardButton.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
}

extension CardInputsViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let currentText = textField.text else { return true }
    let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
    textField.text = vm.formatCreditCardNumber(newText)
    
    if textField.text == cardPlaceholder.value() {
      textField.text = vm.formatCardPlaceholder(newText)
    } else if textField.text == cardNumberTextField.value() {
      textField.text = vm.formatCreditCardNumber(newText)
    } else if textField.text == expiryDateTextField.value(){
      textField.text = vm.formatExpiryDate(newText)
    } else if textField.text == ccvTextField.value() {
      textField.text = vm.formatCCV(newText)
    }
    
    return false
  }
}
