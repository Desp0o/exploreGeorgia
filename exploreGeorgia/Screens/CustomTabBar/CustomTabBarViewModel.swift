//
//  CustomTabBarViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUI

final class CustomTabBarViewModel: ObservableObject {
  let tabItems = [
    TabBarItemModel(title: "Home", icon: IconsEnum.home.rawValue),
    TabBarItemModel(title: "Explore", icon: IconsEnum.location.rawValue),
    TabBarItemModel(title: "Food", icon: IconsEnum.food.rawValue),
    TabBarItemModel(title: "Board", icon: IconsEnum.book.rawValue),
    TabBarItemModel(title: "Profile", icon: IconsEnum.profile.rawValue)
  ]
}
