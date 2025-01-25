//
//  PlaceTypePicker.swift
//  exploreGeorgia
//
//  Created by Despo on 17.01.25.
//

import SwiftUI

struct PlaceTypePicker: View {
  @ObservedObject var vm: AddPlaceViewModel
  
  var body: some View {
    Picker("Place Type", selection: $vm.selectedPlace) {
      ForEach(vm.placeType, id: \.self) { type in
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

