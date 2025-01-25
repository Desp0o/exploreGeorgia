//
//  SingleUserProfileCell.swift
//  exploreGeorgia
//
//  Created by Despo on 25.01.25.
//

import UIKit
import SwiftUI

final class SingleUserProfileCell: UITableViewCell {
  private var hostingController: UIHostingController<PlaceFromUserReusable>?
  
  private lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.isLayoutMarginsRelativeArrangement = true
    stack.layoutMargins = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
    return stack
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.backgroundColor = .clear
    contentView.addSubview(stackView)
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
  
  func setupCell(with place: SightSeenModel) {
    hostingController?.view.removeFromSuperview()
    hostingController = nil
    
    let placesComponent = PlaceFromUserReusable(place: place)
    hostingController = UIHostingController(rootView: placesComponent)
    
    if let hostingView = hostingController?.view {
      hostingView.backgroundColor = .clear
      hostingView.translatesAutoresizingMaskIntoConstraints = false
      stackView.addArrangedSubview(hostingView)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    hostingController?.view.removeFromSuperview()
    hostingController = nil
  }
}
