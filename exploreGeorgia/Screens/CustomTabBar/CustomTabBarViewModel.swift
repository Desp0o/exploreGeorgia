//
//  CustomTabBarViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUI

final class CustomTabBarViewModel: ObservableObject {
  let tabItems = [
    TabBarItemModel(title: "Home", icon: "home"),
    TabBarItemModel(title: "Explore", icon: "location"),
    TabBarItemModel(title: "Food", icon: "food"),
    TabBarItemModel(title: "Board", icon: "book"),
    TabBarItemModel(title: "Profile", icon: "profile")
  ]
}
