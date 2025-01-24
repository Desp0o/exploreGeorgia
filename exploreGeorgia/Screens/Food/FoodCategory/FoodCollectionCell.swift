//
//  FoodCollectionCell.swift
//  exploreGeorgia
//
//  Created by Despo on 24.01.25.
//

import UIKit
import SwiftUI

final class FoodCollectionCell: UICollectionViewCell {
  private var hostingController: UIHostingController<FoodViewSingleComponent>?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.backgroundColor = .clear
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell(with resturant: ResturantModel) {
    hostingController?.view.removeFromSuperview()
    hostingController = nil
    
    let placesComponent = FoodViewSingleComponent(
      cover: resturant.cover,
      name: resturant.name,
      type: resturant.type,
      elementWidth: contentView.bounds.width
    )
    hostingController = UIHostingController(rootView: placesComponent)
    
    if let hostingView = hostingController?.view {
      hostingView.backgroundColor = .clear
      hostingView.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(hostingView)
      
      NSLayoutConstraint.activate([
        hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
        hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
      ])
    }
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    hostingController?.view.removeFromSuperview()
    hostingController = nil
  }
}
