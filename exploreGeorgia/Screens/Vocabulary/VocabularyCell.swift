//
//  VocabularyCell.swift
//  exploreGeorgia
//
//  Created by Despo on 11.01.25.
//

import UIKit

final class VocabularyCell: UITableViewCell {
  private lazy var phraseLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private lazy var stack: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  private lazy var cellView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .customWhite
    view.layer.cornerRadius = 12
    return view
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    self.backgroundColor = .clear
    contentView.backgroundColor = .clear
    
    contentView.addSubview(stack)
    stack.addArrangedSubview(cellView)
    cellView.addSubview(phraseLabel)
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      
      cellView.heightAnchor.constraint(equalToConstant: 50),
      
      phraseLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10),
      phraseLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
    ])
  }
  
  func setupCell(with phrase: String) {
    phraseLabel.createLabel(
      text: phrase,
      fontSize: 16,
      textColor: .customBlack
    )
  }
}
