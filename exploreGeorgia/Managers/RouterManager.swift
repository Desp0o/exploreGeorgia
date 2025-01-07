//
//  RouterManager.swift
//  exploreGeorgia
//
//  Created by Despo on 05.01.25.
//

import FirebaseAuth

final class RouterManager: ObservableObject {
  @Published var isUserAuthenticated = Auth.auth().currentUser != nil
  private var authStateHandle: AuthStateDidChangeListenerHandle?
  
  init() {
    startListeningToAuthChanges()
  }
  
  deinit {
    stopListeningToAuthChanges()
  }
  
  private func startListeningToAuthChanges() {
    authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
      self?.isUserAuthenticated = (user != nil)
    }
  }
  
  private func stopListeningToAuthChanges() {
    if let handle = authStateHandle {
      Auth.auth().removeStateDidChangeListener(handle)
    }
  }
}
