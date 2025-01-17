//
//  PlaceDetailsBGComponent.swift
//  exploreGeorgia
//
//  Created by Despo on 12.01.25.
//

import SwiftUI

struct PlaceDetailsBGComponent: View {
  @ObservedObject var vm: PlaceDetailsViewModel
  var body: some View {
    VStack {
      CachedAsyncImage(url: URL(string: vm.currentPlace?.cover ?? ""))
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height < 800 ? 270 : 350)
    }
  }
}
