//
//  SingleUserProfile.swift
//  exploreGeorgia
//
//  Created by Despo on 25.01.25.
//

import UIKit
import SwiftUI

final class SingleUserProfileViewController: UIViewController {
  private let vm: SingleUserProfileViewModel
  private var pageSize = 10
  let singleUserId: String
  
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
      tintColor: .customGreen
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
  
  private lazy var table: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.dataSource = self
    table.delegate = self
    table.separatorStyle = .none
    table.separatorColor = .clear
    table.backgroundColor = .primaryWhite
    table.register(SingleUserProfileCell.self, forCellReuseIdentifier: "SingleUserProfileCell")
    table.showsVerticalScrollIndicator = false
    table.alwaysBounceVertical = false
    
    return table
  }()
  
  init(
    vm: SingleUserProfileViewModel = SingleUserProfileViewModel(),
    singleUserId: String
  ) {
    self.vm = vm
    self.singleUserId = singleUserId
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
    
    vm.fetchUser(userId: singleUserId)
    vm.fetchData(pageSize: pageSize, userId: singleUserId)
    
    vm.userDelegate = self
    vm.loadingDelegate = self
    vm.dataDelegate = self
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    view.addSubview(profieStack)
    profieStack.addArrangedSubview(emptyView)
    profieStack.addArrangedSubview(fullNameLabel)
    view.addSubview(backButton)
    view.addSubview(table)
    
    NSLayoutConstraint.activate([
      backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
      backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      
      profieStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
      profieStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
      profieStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
      profieStack.heightAnchor.constraint(equalToConstant: 240),
      
      table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
      table.topAnchor.constraint(equalTo: profieStack.bottomAnchor, constant: 20),
      table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
      table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
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
    shadowLayer.shadowOpacity = 0.05
    shadowLayer.shadowRadius = 4
    shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
    shadowLayer.shadowPath = UIBezierPath(roundedRect: view.bounds,
                                          byRoundingCorners: [.bottomLeft, .bottomRight],
                                          cornerRadii: CGSize(width: 20, height: 20)).cgPath
    view.superview?.layer.insertSublayer(shadowLayer, below: view.layer)
  }
  
  func setupCachedImageHostinger(coverURL: String) {
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

extension SingleUserProfileViewController: SingleUserFetchDelegate {
  func didUserFetched() {
    let firstName = vm.user?.firstName ?? ""
    let lastName = vm.user?.lastName ?? ""
    
    fullNameLabel.createLabel(text: firstName + " " + lastName, fontSize: 24, fontWeight: .semibold, textColor: .customBlack)
    setupCachedImageHostinger(coverURL: vm.user?.avatar ?? "")
  }
}

extension SingleUserProfileViewController: SingleUserLoadingDelegate {
  func didLoadingStopped() {
    if vm.isLoading {
      let shimmer = SingleUserShimmer()
      let hostingController = UIHostingController(rootView: shimmer)
      
      hostingController.view.translatesAutoresizingMaskIntoConstraints = false
      addChild(hostingController)
      view.addSubview(hostingController.view)
      hostingController.didMove(toParent: self)
      
      NSLayoutConstraint.activate([
        hostingController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
        hostingController.view.heightAnchor.constraint(equalTo: view.heightAnchor)
      ])
      
      hostingController.view.tag = 998
    } else {
      if let shimmerView = view.viewWithTag(998) {
        shimmerView.removeFromSuperview()
      }
    }
  }
}

extension SingleUserProfileViewController: SingleUserDataDelegate {
  func didDataFetched() {
    table.reloadData()
  }
}

extension SingleUserProfileViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    vm.fetchedPlaces.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SingleUserProfileCell", for: indexPath) as? SingleUserProfileCell
    let place = vm.fetchedPlaces[indexPath.row]
    cell?.setupCell(with: place)
    cell?.selectionStyle = .none
    
    if indexPath.row == vm.fetchedPlaces.count - 1 {
      pageSize += 10
      vm.fetchData(pageSize: pageSize, userId: singleUserId)
    }
    
    return cell ?? SingleUserProfileCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let place = vm.fetchedPlaces[indexPath.row]
    let swiftUIView = PlaceDetailsView(
      elementID: place.id ?? "",
      collectionName: .usersPlace,
      isNavigationDisabled: true
    ).navigationBarHidden(true)
    let hostingController = UIHostingController(rootView: swiftUIView)
    
    navigationController?.pushViewController(hostingController, animated: true)
  }
}

struct SIngleUserProfileWrapper: UIViewControllerRepresentable {
  let singleUserId: String
  
  func makeUIViewController(context: Context) -> SingleUserProfileViewController {
    return SingleUserProfileViewController(singleUserId: singleUserId)
  }
  
  func updateUIViewController(_ uiViewController: SingleUserProfileViewController, context: Context) {}
}

