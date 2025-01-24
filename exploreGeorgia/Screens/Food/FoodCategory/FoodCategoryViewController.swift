//
//  FoodCategoryViewController.swift
//  exploreGeorgia
//
//  Created by Despo on 24.01.25.
//

import SwiftUI
import UIKit

final class FoodCategoryViewController: UIViewController  {
  private let vm: FoodCategoryViewModel
  let titleText: String
  
  private lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "foodBG")
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
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
  
  private lazy var screenTitle: UILabel = {
    let label = UILabel()
    label.createLabel(
      text: "",
      fontSize: 26,
      fontWeight: .bold,
      textColor: .customBlue
    )
    return label
  }()
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 30, height: 150)
    layout.minimumInteritemSpacing = 10
    layout.minimumLineSpacing = 30
    layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .clear
    collectionView.register(FoodCollectionCell.self, forCellWithReuseIdentifier: "FoodCollectionCell")
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.allowsSelection = true
    collectionView.showsVerticalScrollIndicator = false
    return collectionView
  }()
  
  init(
    vm: FoodCategoryViewModel = FoodCategoryViewModel(),
    titleText: String
  ) {
    self.vm = vm
    self.titleText = titleText
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
    vm.fetchDataFromDB(collectionName: .resturant, pageSize: 10)
    
    vm.dataDelegate = self
    
    screenTitle.text = titleText
    setupConstraints()
  }
  
  private func setupConstraints() {
    view.addSubview(backgroundImageView)
    view.addSubview(backButton)
    view.addSubview(screenTitle)
    view.addSubview(collectionView)
    
    NSLayoutConstraint.activate([
      backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
      backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      
      screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      collectionView.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 30),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

extension FoodCategoryViewController: DataFetchingDelegae {
  func didDataFetched() {
    collectionView.reloadData()
  }
}

extension FoodCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return vm.fetchedData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionCell", for: indexPath) as? FoodCollectionCell else {
      return UICollectionViewCell()
    }
    
    let currentElement = vm.fetchedData[indexPath.row]
    cell.configureCell(with: currentElement)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let place = vm.fetchedData[indexPath.row]
    let swiftUIView = ResturantView(place: place, collection: .resturant).navigationBarHidden(true)
    let hostingController = UIHostingController(rootView: swiftUIView)
    navigationController?.pushViewController(hostingController, animated: true)
  }
}

struct FoodCategoryWrapper: UIViewControllerRepresentable {
  let titleText: String
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
  
  func makeUIViewController(context: Context) -> FoodCategoryViewController {
    return FoodCategoryViewController(titleText: titleText)
  }
}
