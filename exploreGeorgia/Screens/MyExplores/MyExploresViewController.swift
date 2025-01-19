//
//  MyExploresViewController.swift
//  exploreGeorgia
//
//  Created by Despo on 17.01.25.
//

import UIKit
import SwiftUI

final class MyExploresViewController: UIViewController {
  private let vm: MyExploresViewModel
  private var PageSize = 10
  
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
      text: "My Explores",
      fontSize: 24,
      fontWeight: .semibold,
      textColor: .customBlue
    )
    return label
  }()
  
  private lazy var table: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.dataSource = self
    table.delegate = self
    table.separatorStyle = .none
    table.backgroundColor = .clear
    table.register(MyExploresCell.self, forCellReuseIdentifier: "MyExploresCell")
    table.showsVerticalScrollIndicator = false
    table.alwaysBounceVertical = false

    return table
  }()
  
  private lazy var noDataStackView: UIStackView = {
    let stack = UIStackView()
    stack
      .createCustomStack(
        axis: .vertical,
        alignment: .center,
        distribution: .equalSpacing,
        spacing: 8
      )
    stack.isHidden = true
    return stack
  }()
  
  private lazy var noDataImage: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.image = UIImage(systemName: "figure.walk.triangle")
    image.tintColor = .customBlue
    image.contentMode = .scaleAspectFit
    
    return image
  }()
  
  private lazy var noDataText: UILabel = {
    let label = UILabel()
    label.createLabel(
      text: "No explored places yet. Start your adventure!",
      fontSize: 16,
      fontWeight: .semibold,
      textColor: .customBlue
    )
    return label
  }()
  
  init(vm: MyExploresViewModel = MyExploresViewModel()) {
    self.vm = vm
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    vm.exploresDelegate = self
    vm.errorDeleage = self
    vm.loadingDelegate = self
    
    setupUI()
  }
  
  private func setupUI() {
    view.backgroundColor = .primaryWhite
    
    view.addSubview(backButton)
    view.addSubview(screenTitle)
    view.addSubview(noDataStackView)
    noDataStackView.addArrangedSubview(noDataImage)
    noDataStackView.addArrangedSubview(noDataText)
    view.addSubview(table)
    
    setupCOnstraints()
  }
  
  private func setupCOnstraints() {
    NSLayoutConstraint.activate([
      backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      
      screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
      screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      noDataStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      noDataStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
      noDataStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
      
      noDataImage.widthAnchor.constraint(equalToConstant: 80),
      noDataImage.heightAnchor.constraint(equalToConstant: 80),
      
      table.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
      table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
      table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      table.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
    ])
  }
}

extension MyExploresViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    vm.fetchedPlaces.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MyExploresCell", for: indexPath) as? MyExploresCell
    let place = vm.fetchedPlaces[indexPath.row]
    cell?.setupCell(with: place)
    
    if indexPath.row == vm.fetchedPlaces.count - 1 {
      PageSize += 10
      vm.fetchData(pageSize: PageSize)
    }
    
    return cell ?? MyExploresCell()
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
      self?.vm.removePlace(index: indexPath.row)
      self?.vm.fetchedPlaces.remove(at: indexPath.row)
      tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .fade)
      if self?.vm.fetchedPlaces.isEmpty ?? false {
        self?.noDataStackView.isHidden = false
      } else {
        self?.noDataStackView.isHidden = true
      }
      completion(true)
    }
    
    deleteAction.backgroundColor = .systemRed
    
    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
    configuration.performsFirstActionWithFullSwipe = true
    return configuration
  }
  
  func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      cell.superview?.subviews.forEach { view in
        if NSStringFromClass(type(of: view)).contains("SwipeActionPullView") {
          view.frame = CGRect(x: view.frame.minX, y: view.frame.minY + 8, width: view.frame.width, height: view.frame.height - 16)
          view.clipsToBounds = true
          view.layer.cornerRadius = 12
          view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
      }
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let place = vm.fetchedPlaces[indexPath.row]
    let swiftUIView = PlaceDetailsView(elementID: place.id ?? "", collectionName: "usersPlaces").navigationBarHidden(true)
    let hostingController = UIHostingController(rootView: swiftUIView)
    
    navigationController?.pushViewController(hostingController, animated: true)
  }
}

extension MyExploresViewController: MyExploresLoadingDelegate {
  func didLoadingStopped() {
    if vm.isLoading {
      showLoading(backgroundOpacity: 0)
    } else {
      hideLoading()
    }
  }
}

extension MyExploresViewController: MyExploresDelegate {
  func didDataLoaded() {
    table.reloadData()
    
    if vm.fetchedPlaces.isEmpty {
      noDataStackView.isHidden = false
    } else {
      noDataStackView.isHidden = true
    }
  }
}

extension MyExploresViewController: MyExploresErrorDelegate {
  func didErrorOccurred() {
    let overlay = UIKitCustomAlert()
    overlay.appear(sender: self, message: vm.errorMessage, messageType: .error)
  }
}

struct MyExploresViewControllerWrapper: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> MyExploresViewController {
    return MyExploresViewController()
  }
  
  func updateUIViewController(_ uiViewController: MyExploresViewController, context: Context) {}
}
