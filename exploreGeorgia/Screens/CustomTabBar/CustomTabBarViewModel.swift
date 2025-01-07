//
//  CustomTabBarViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUI

final class CustomTabBarViewModel: ObservableObject {
  let tabItems = [
    TabBarItem(title: "Home", activeIcon: "homeActive", inactiveIcon: "homeInactive"),
    TabBarItem(title: "Explore", activeIcon: "locationActive", inactiveIcon: "locationInactive"),
    TabBarItem(title: "Food", activeIcon: "foodActive", inactiveIcon: "foodInactive"),
    TabBarItem(title: "Board", activeIcon: "boardActive", inactiveIcon: "boardInactive"),
    TabBarItem(title: "Profile", activeIcon: "profileActive", inactiveIcon: "profileInactive")
  ]
}
