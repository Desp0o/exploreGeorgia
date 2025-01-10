//
//  CustomAlertManager.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

import SwiftUI

final class CustomAlertManager: ObservableObject {
  @Published var isShown: Bool = false
  
  func showAlert() {
    isShown = true
  }
  
  func hideAlert() {
    isShown = false
  }
}
