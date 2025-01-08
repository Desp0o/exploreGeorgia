//
//  ProfileModels.swift
//  exploreGeorgia
//
//  Created by Despo on 08.01.25.
//

import SwiftUICore

struct ProfileStatModel {
  let title: String
  let count: Int
}

struct ProfileSettingsModel: Identifiable {
  let id = UUID() 
  let icon: String
  let title: String
  let location: AnyView
}
