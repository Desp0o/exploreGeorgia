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
    ZStack(alignment: .top) {
      NavigationBarReusable(title: vm.currentPlace?.name ?? "")
        .padding(.top, (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.top ?? 0)
        .frame(width: UIScreen.main.bounds.width - 20)
        .zIndex(2)
      
      AsyncImage(url: URL(string: vm.currentPlace?.cover ?? "")) { image in
        image
          .defaultOptions()
      } placeholder: {
        Image("imagePlaceholder")
          .defaultOptions()
      }
      .frame(maxWidth: .infinity)
      .frame(height: UIScreen.main.bounds.height < 800 ? 270 : 400)
    }
  }
}
