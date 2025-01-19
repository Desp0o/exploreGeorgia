//
//  CreditCardCell.swift
//  exploreGeorgia
//
//  Created by Despo on 19.01.25.
//

import Foundation
import UIKit

final class CreditCardCell: UITableViewCell {
  private lazy var cardImage: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleAspectFill
    return image
  }()
  
  private lazy var cardTitle: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private lazy var cardNumber: UILabel = {
    let label = UILabel()
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.backgroundColor = .primaryWhite
    contentView.addSubview(cardImage)
    contentView.addSubview(cardTitle)
    contentView.addSubview(cardNumber)
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      cardImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      cardImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      cardImage.widthAnchor.constraint(equalToConstant: 50),
      cardImage.heightAnchor.constraint(equalToConstant: 30),
      
      cardTitle.leadingAnchor.constraint(equalTo: cardImage.trailingAnchor, constant: 15),
      cardTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      cardTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      
      cardNumber.leadingAnchor.constraint(equalTo: cardImage.trailingAnchor, constant: 15),
      cardNumber.topAnchor.constraint(equalTo: cardTitle.bottomAnchor, constant: 5),
      cardNumber.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      cardNumber.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
    ])
  }
  
  func setupCell(with creditCart: CreditCardModel) {
    let cardfirstNum = creditCart.number.prefix(1)
    
    if cardfirstNum == "5" || cardfirstNum == "2" {
      cardImage.image = UIImage(named: "mastercard")
      cardTitle.createLabel(text: "Mastercard")
    } else if cardfirstNum == "4" {
      cardImage.image = UIImage(named: "visa")
      cardTitle.createLabel(text: "Visa")
      
    } else if cardfirstNum == "3" {
      cardImage.image = UIImage(named: "amex")
      cardTitle.createLabel(text: "Amex")
      
    } else {
      cardImage.image = UIImage(named: "defaultCreditCard")
      cardTitle.createLabel(text: "Your card")
    }
    
    cardNumber.createLabel(text: "****\(creditCart.number.suffix(4))", fontSize: 12)
  }
}
