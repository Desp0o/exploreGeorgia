//
//  PaymentViewController.swift
//  exploreGeorgia
//
//  Created by Despo on 19.01.25.
//

import SwiftUI

struct PaymentViewWrapper: UIViewControllerRepresentable {
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
  
  func makeUIViewController(context: Context) -> PaymentViewController {
    return PaymentViewController()
  }
}

final class PaymentViewController: UIViewController {
  private let vm: PaymentViewModel
  
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
      text: "Payment",
      fontSize: 26,
      fontWeight: .bold,
      textColor: .customBlue
    )
    return label
  }()
  
  private lazy var addPaymentButton: UIButton = {
    let button = UIButton()
    button.createCustomButton(
      title: "Add payment",
      backgroundColor: .customBlue
    )
    button.addTapAnimation()
    button.addAction(UIAction(handler: {[weak self] _ in
      self?.openSheet()
    }), for: .touchUpInside)
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
    view.addSubview(backButton)
    view.addSubview(screenTitle)
    view.addSubview(addPaymentButton)
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      
      screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      addPaymentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      addPaymentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      addPaymentButton.heightAnchor.constraint(equalToConstant: 42),
      addPaymentButton.widthAnchor.constraint(equalToConstant: 140)
    ])
  }
  
  private func openSheet() {
    let view  = CardInputsViewController()
    view.modalPresentationStyle = .pageSheet
    view.modalTransitionStyle = .coverVertical
    present(view, animated: true, completion: nil)
    if let sheet = view.sheetPresentationController {
      sheet.detents = [.medium(), .large()]
    }
  }
}

extension PaymentViewController: PaymentDataDelegate {
  func didDataFetched() {
    print(vm.creditCards)
  }
}

//#Preview {
//  PaymentViewWrapper()
//    .preferredColorScheme(.light)
//}
