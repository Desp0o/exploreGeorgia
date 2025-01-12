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
      AsyncImage(url: URL(string: vm.currentPlace?.cover ?? "")) { image in
        image
          .defaultOptions()
      } placeholder: {
        Image("imagePlaceholder")
          .defaultOptions()
      }
      .frame(maxWidth: .infinity)
      .frame(height: UIScreen.main.bounds.height < 800 ? 270 : 400)
      
      Button {
        print("test")
      } label: {
        Text("u k a n g a m o s v l a")
          .styledText(
            .red,
            28,
            .bold
          )
      }
    }
  }
}
