//
//  Vocabulary.swift
//  exploreGeorgia
//
//  Created by Despo on 11.01.25.
//

import UIKit

final class VocabularyVC: UIViewController, UISearchBarDelegate {
  private let vm: VocabularyViewModel
  
  init(vm: VocabularyViewModel = VocabularyViewModel()) {
    self.vm = vm
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.placeholder = "Search"
    searchBar.backgroundColor = .clear
    
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
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
      screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      searchBar.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 20),
      searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      
      table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      table.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
      table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      table.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
    ])
  }
}

extension VocabularyVC: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return vm.phrases.keys.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let sectionTitles = Array(vm.phrases.keys)
    return sectionTitles[section]
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionTitles = Array(vm.phrases.keys)
    let key = sectionTitles[section]
    return vm.phrases[key]?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "VocabularyCell", for: indexPath) as? VocabularyCell
    
    let sectionTitles = Array(vm.phrases.keys)
    let key = sectionTitles[indexPath.section]
    let items = vm.phrases[key] ?? []
    
    cell?.setupCell(with: items[indexPath.row])
    
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

#Preview {
  VocabularyVC()
}
