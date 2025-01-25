//
//  SingleUserProfile.swift
//  exploreGeorgia
//
//  Created by Despo on 25.01.25.
//

import UIKit
import SwiftUI

final class SingleUserProfile: UIViewController {
  private let vm: SingleUserProfileViewModel
  
  private lazy var emptyView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .red
    return view
  }()
  
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
  
  private lazy var profieStack: UIStackView = {
    let stack = UIStackView()
    stack.backgroundColor = .customWhite
    stack.createCustomStack(
      axis: .vertical,
      alignment: .center,
      distribution: .fill,
      spacing: 12,
      isLayoutMarginsRelativeArrangement: true,
      layoutMargins: UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    )
    return stack
  }()
  
  private lazy var fullNameLabel: UILabel = {
    let label = UILabel()
    label.createLabel(text: "test")
    return label
  }()
  
  init(vm: SingleUserProfileViewModel = SingleUserProfileViewModel()) {
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
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    roundBottomCorners(view: profieStack, radius: 20)
    applyShadow(view: profieStack)
  }
  
  private func setupUI() {
    view.backgroundColor = .primaryWhite
    vm.fetchUser(userId: "x4ldqrU6VMMFsBmFhH9SRGG16sJ3")
    vm.userDelegate = self
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    view.addSubview(profieStack)
    profieStack.addArrangedSubview(emptyView)
    profieStack.addArrangedSubview(fullNameLabel)
    view.addSubview(backButton)
    
    NSLayoutConstraint.activate([
      backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      
      profieStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
      profieStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
      profieStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
      profieStack.heightAnchor.constraint(equalToConstant: 200),

    ])
  }
  
  private func roundBottomCorners(view: UIView, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: view.bounds,
                            byRoundingCorners: [.bottomLeft, .bottomRight],
                            cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    view.layer.mask = mask
  }
  
  private func applyShadow(view: UIView) {
    let shadowLayer = CALayer()
    shadowLayer.frame = view.frame
    shadowLayer.shadowColor = UIColor.black.cgColor
    shadowLayer.shadowOpacity = 0.25
    shadowLayer.shadowRadius = 4
    shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
    shadowLayer.shadowPath = UIBezierPath(roundedRect: view.bounds,
                                          byRoundingCorners: [.bottomLeft, .bottomRight],
                                          cornerRadii: CGSize(width: 20, height: 20)).cgPath
    view.superview?.layer.insertSublayer(shadowLayer, below: view.layer)
  }
  
  func setupCachedImageHostinger(coverURL: String) {
    view.backgroundColor = .white
    
    let cachedAsyncImage = CachedAsyncImage(url: URL(string: coverURL))
    let hostingController = UIHostingController(rootView: cachedAsyncImage)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    hostingController.view.layer.cornerRadius = 48
    hostingController.view.clipsToBounds = true
    addChild(hostingController)
    profieStack.addArrangedSubview(hostingController.view)
    hostingController.didMove(toParent: self)
    
    NSLayoutConstraint.activate([
      hostingController.view.widthAnchor.constraint(equalToConstant: 96),
      hostingController.view.heightAnchor.constraint(equalToConstant: 96)
    ])
  }
}

extension SingleUserProfile: SingleUserFetchDelegate {
  func didUserFetched() {
    let firstName = vm.user?.firstName ?? ""
    let lastName = vm.user?.lastName ?? ""
    
    fullNameLabel.createLabel(text: firstName + " " + lastName, fontSize: 24, fontWeight: .semibold, textColor: .customBlack)
    setupCachedImageHostinger(coverURL: vm.user?.avatar ?? "")
  }
}

struct SIngleUserProfileWrapper: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> SingleUserProfile {
    return SingleUserProfile()
  }
  
  func updateUIViewController(_ uiViewController: SingleUserProfile, context: Context) {}
}

