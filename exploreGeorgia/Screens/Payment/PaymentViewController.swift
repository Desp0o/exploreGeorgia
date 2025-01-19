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
  
  private lazy var table: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.dataSource = self
    table.delegate = self
    table.separatorStyle = .singleLine
    table.separatorColor = .customBlue
    table.backgroundColor = .clear
    table.register(CreditCardCell.self, forCellReuseIdentifier: "CreditCardCell")
    table.showsVerticalScrollIndicator = false
    
    return table
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
  
  init(
    vm: PaymentViewModel = PaymentViewModel()
  ) {
    self.vm = vm
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    vm.dataDelegate = self
    
    setupUI()
  }
  
  
  private func setupUI() {
    view.backgroundColor = .primaryWhite
    view.addSubview(backButton)
    view.addSubview(screenTitle)
    view.addSubview(addPaymentButton)
    view.addSubview(table)
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      
      screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      table.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 50),
      table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      table.bottomAnchor.constraint(equalTo: addPaymentButton.topAnchor, constant: -10),

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
    view.delegate = self
    present(view, animated: true, completion: nil)
    if let sheet = view.sheetPresentationController {
      sheet.detents = [.medium(), .large()]
    }
  }
}

extension PaymentViewController: PaymentDataDelegate {
  func didDataFetched() {
    table.reloadData()
  }
}

extension PaymentViewController: UITableViewDataSource, UITableViewDelegate{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    vm.creditCards.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardCell", for: indexPath) as? CreditCardCell
    let currentCard = vm.creditCards[indexPath.row]

    cell?.setupCell(with: currentCard)
    cell?.selectionStyle = .none
    
    return cell ?? CreditCardCell()
  }
}

extension PaymentViewController: CardAddedDelegate {
  func cardAddedSuccessfully() {
    vm.fetchAllUserPayments()
    table.reloadData()
  }
}

//#Preview {
//  PaymentViewWrapper()
//    .preferredColorScheme(.light)
//}
