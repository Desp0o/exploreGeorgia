//
//  PlaceTypePicker.swift
//  exploreGeorgia
//
//  Created by Despo on 17.01.25.
//

import SwiftUI

struct PlaceTypePicker: View {
  @Binding var selectedPlace: AddPlaceTypes
  let placeTypes: [AddPlaceTypes]
  
  var body: some View {
    Picker("Place Type", selection: $selectedPlace) {
      ForEach(placeTypes, id: \.self) { type in
        Text(type.rawValue)
      }
    }
    .pickerStyle(SegmentedPickerStyle())
    .onAppear {
      UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.customBlue)
      UISegmentedControl.appearance().setTitleTextAttributes(
        [.foregroundColor: UIColor.white],
        for: .selected
      )
    }
  }
}

