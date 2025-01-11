//
//  Vocabulary.swift
//  exploreGeorgia
//
//  Created by Despo on 11.01.25.
//

import UIKit

final class VocabularyVC: UIViewController {
  private let vm: VocabularyViewModel
  
  private lazy var searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.placeholder = "Search"
    searchBar.backgroundColor = .clear
    searchBar.searchBarStyle = .minimal
    searchBar.delegate = self
    
    return searchBar
  }()
  
  private lazy var screenTitle: UILabel = {
    let label = UILabel()
    label.createLabel(
      text: "Words That Will Save You",
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
    table.separatorStyle = .none
    table.backgroundColor = .clear
    table.showsVerticalScrollIndicator = false
    table.register(VocabularyCell.self, forCellReuseIdentifier: "VocabularyCell")
    return table
  }()
  
  init(vm: VocabularyViewModel = VocabularyViewModel()) {
    self.vm = vm
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    vm.delegate = self
    vm.vocabularyLoadingDelegate = self
    vm.didVocabularyFailed = self
    
    setupUI()
  }
  
  private func setupUI() {
    view.backgroundColor = .primaryWhite
    
    view.addSubview(searchBar)
    view.addSubview(screenTitle)
    view.addSubview(table)
    
    setupConstraints()
    
    gesture()
  }
  
  private func gesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
      screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      searchBar.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 5),
      searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      table.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
      table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      table.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
    ])
  }
}

extension VocabularyVC: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      searchBar.resignFirstResponder()
    }
    
    vm.searchTerm = searchText
    table.reloadData()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    vm.searchTerm = ""
    searchBar.text = ""
    table.reloadData()
  }
}

extension VocabularyVC: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return vm.filteredPhrases.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let sectionTitle = vm.filteredPhrases[section].0
    return sectionTitle
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = .customBlue
    
    let label = UILabel()
    label.createLabel(
      text: vm.filteredPhrases[section].0,
      fontSize: 18,
      fontWeight: .bold,
      textColor: .buttonPrimary
    )
    
    headerView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
      label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
    ])
    
    return headerView
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let items = vm.filteredPhrases[section].1
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "VocabularyCell", for: indexPath) as? VocabularyCell
    
    let items = vm.filteredPhrases[indexPath.section].1
    cell?.setupCell(with: items[indexPath.row])
    cell?.selectionStyle = .none
    
    return cell ?? VocabularyCell()
  }
}

extension VocabularyVC: VocabularyFetchDelegate {
  func didPhrasesFetched() {
    table.reloadData()
  }
}

extension VocabularyVC: VocabularyLoadingDelegate {
  func didVocabularyLoaded() {
    if vm.isLoading {
      showLoading()
    } else {
      hideLoading()
    }
  }
}

extension VocabularyVC: VocabularyErrorMessageDelegate {
  func didVocabularyFailed() {
    let overlay = UIKitCustomAlert()
    overlay.appear(sender: self, message: vm.errorMessage, messageType: .error)
  }
}
