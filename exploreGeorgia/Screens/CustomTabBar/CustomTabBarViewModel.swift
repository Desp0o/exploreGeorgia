//
//  CustomTabBarViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUI

final class CustomTabBarViewModel: ObservableObject {
  let tabItems = [
    TabBarItemModel(title: "Home", activeIcon: "homeActive", inactiveIcon: "homeInactive"),
    TabBarItemModel(title: "Explore", activeIcon: "locationActive", inactiveIcon: "locationInactive"),
    TabBarItemModel(title: "Food", activeIcon: "foodActive", inactiveIcon: "foodInactive"),
    TabBarItemModel(title: "Board", activeIcon: "boardActive", inactiveIcon: "boardInactive"),
    TabBarItemModel(title: "Profile", activeIcon: "profileActive", inactiveIcon: "profileInactive")
  ]
}
